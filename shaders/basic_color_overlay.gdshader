shader_type canvas_item;
render_mode unshaded; // Removes unnecessary lighting passes

// --- GLOBAL SETTINGS & OPTIMIZATIONS ---
group_uniforms GlobalSettings;
uniform mediump float gamma : hint_range(0.1, 3.0) = 1.0;
uniform bool premultiplied_alpha = false;
uniform lowp float feather_edges : hint_range(0.0, 1.0) = 0.0;
uniform lowp float dither_strength : hint_range(0.0, 0.1) = 0.0;

// --- BASE OVERLAY ---
group_uniforms BaseOverlay;
uniform bool use_base_overlay = true;
uniform int blend_mode : hint_enum("Normal", "Multiply", "Screen", "Overlay", "Darken", "Lighten", "Color Dodge", "Linear Dodge", "Difference") = 0;
uniform lowp vec4 overlay_color : source_color = vec4(1.0);
uniform lowp float overlay_opacity : hint_range(0.0, 1.0) = 1.0;

// --- 1D GRADIENT OVERLAY ---
group_uniforms GradientOverlay;
uniform bool use_gradient = false;
uniform int gradient_type : hint_enum("Linear", "Radial") = 0;
uniform sampler2D gradient_texture : source_color; // Assign a GradientTexture1D here
uniform mediump float gradient_angle : hint_range(0.0, 360.0) = 0.0;
uniform mediump vec2 gradient_offset = vec2(0.0, 0.0);
uniform mediump float gradient_scale = 1.0;
uniform mediump float gradient_smoothstep : hint_range(0.0, 1.0) = 0.0; // S-Curve easing

// --- PATTERN OVERLAY ---
group_uniforms PatternOverlay;
uniform bool use_pattern = false;
uniform sampler2D pattern_texture : source_color, hint_default_white, filter_linear_mipmap_anisotropic;
uniform int pattern_blend_mode : hint_enum("Normal", "Multiply", "Screen", "Overlay", "Darken", "Lighten", "Color Dodge", "Linear Dodge", "Difference") = 1;
uniform lowp float pattern_opacity : hint_range(0.0, 1.0) = 1.0;
uniform mediump vec2 pattern_scale = vec2(1.0, 1.0);
uniform mediump float pattern_angle : hint_range(0.0, 360.0) = 0.0;
uniform mediump vec2 pattern_velocity = vec2(0.0, 0.0); // Auto-scrolling
uniform bool pattern_screen_space = false;
uniform ivec2 pattern_frames = ivec2(1, 1); // For Sprite Sheets
uniform int pattern_frame = 0;

group_uniforms; // Reset Grouping

// Varyings for Vectorized Rotation Math
varying mediump mat2 v_grad_rot;
varying mediump mat2 v_pattern_rot;

// --- VERTEX STAGE (Pre-calculations) ---
void vertex() {
    mediump float g_rads = radians(gradient_angle);
    mediump float g_c = cos(g_rads);
    mediump float g_s = sin(g_rads);
    v_grad_rot = mat2(vec2(g_c, g_s), vec2(-g_s, g_c));
    
    mediump float p_rads = radians(pattern_angle);
    mediump float p_c = cos(p_rads);
    mediump float p_s = sin(p_rads);
    v_pattern_rot = mat2(vec2(p_c, p_s), vec2(-p_s, p_c));
}

// --- OPTIMIZED BRANCHLESS BLEND FUNCTION ---
lowp vec3 apply_blend_branchless(int mode, lowp vec3 base, lowp vec3 blend) {
    lowp vec3 result = vec3(0.0);
    
    // Evaluate all math trees in parallel (FMA Algebra)
    lowp vec3 b_normal = blend;
    lowp vec3 b_mult = base * blend;
    lowp vec3 b_screen = base + blend - (base * blend);
    lowp vec3 limit = step(0.5, base);
    lowp vec3 b_overlay = mix(2.0 * base * blend, 2.0 * (base + blend - (base * blend)) - 1.0, limit);
    lowp vec3 b_darken = min(base, blend);
    lowp vec3 b_lighten = max(base, blend);
    lowp vec3 b_dodge = clamp(base / max(vec3(0.0001), 1.0 - blend), 0.0, 1.0);
    lowp vec3 b_lin_dodge = base + blend;
    lowp vec3 b_diff = abs(base - blend);

    // Filter via algebraic boolean casting (Branchless execution)
    result += b_normal * float(mode == 0);
    result += b_mult * float(mode == 1);
    result += b_screen * float(mode == 2);
    result += b_overlay * float(mode == 3);
    result += b_darken * float(mode == 4);
    result += b_lighten * float(mode == 5);
    result += b_dodge * float(mode == 6);
    result += b_lin_dodge * float(mode == 7);
    result += b_diff * float(mode == 8);

    return result;
}

// --- FRAGMENT STAGE ---
void fragment() {
    lowp vec4 base_color = texture(TEXTURE, UV);
    
    // Soft/Feathered Edge Masking (Replaces expensive 'discard')
    lowp float alpha_mask = smoothstep(0.0, feather_edges + 0.0001, base_color.a);
    base_color.a *= alpha_mask;

    // Dynamically calculate aspect ratio natively on the GPU without external scripts
    mediump float aspect_ratio = TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x;

    // Apply manual Gamma Correction & Convert to Linear Math Space
    base_color.rgb = pow(base_color.rgb, vec3(gamma));
    lowp vec3 linear_base = pow(base_color.rgb, vec3(2.2));
    
    lowp vec4 current_overlay = use_base_overlay ? overlay_color : vec4(0.0);

    // --- 1. GRADIENT PASS ---
    if (use_gradient) {
        mediump vec2 centered_uv = UV - 0.5 - gradient_offset;
        centered_uv.x *= aspect_ratio; // Correct aspect stretching
        centered_uv *= v_grad_rot; // Apply rotation matrix
        centered_uv /= max(gradient_scale, 0.001); // Apply zoom
        
        mediump float factor = (gradient_type == 0) 
            ? centered_uv.x + 0.5 
            : length(centered_uv) * 2.0;
        
        factor = clamp(factor, 0.0, 1.0);
        factor = mix(factor, smoothstep(0.0, 1.0, factor), gradient_smoothstep); // Apply ease curve
        
        // Sample infinite colors from 1D Texture
        lowp vec4 grad_color = texture(gradient_texture, vec2(factor, 0.5));
        
        current_overlay = use_base_overlay 
            ? mix(current_overlay, grad_color, grad_color.a) 
            : grad_color;
    }
    
    // Linearize overlay
    current_overlay.rgb = pow(current_overlay.rgb, vec3(2.2));
    
    // Apply primary blend
    lowp vec3 blended_rgb = apply_blend_branchless(blend_mode, linear_base, current_overlay.rgb);
    lowp vec3 final_rgb = mix(linear_base, blended_rgb, overlay_opacity * current_overlay.a);
    
    // --- 2. PATTERN PASS ---
    if (use_pattern) {
        mediump vec2 p_uv = pattern_screen_space ? SCREEN_UV : UV;
        
        // Correct aspect stretching for patterns
        if (pattern_screen_space) {
            p_uv.x /= SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
        } else {
            p_uv.x *= aspect_ratio; 
        }
        
        p_uv *= v_pattern_rot; // Rotate
        p_uv *= pattern_scale; // Scale
        p_uv += TIME * pattern_velocity; // Auto-Scroll
        
        // Sprite Sheet Extraction Logic
        if (pattern_frames.x > 1 || pattern_frames.y > 1) {
            mediump vec2 sheet_scale = 1.0 / vec2(pattern_frames);
            mediump vec2 sheet_offset = vec2(
                float(pattern_frame % pattern_frames.x), 
                float(pattern_frame / pattern_frames.x)
            ) * sheet_scale;
            p_uv = fract(p_uv) * sheet_scale + sheet_offset;
        }

        lowp vec4 pattern_col = texture(pattern_texture, p_uv);
        pattern_col.rgb = pow(pattern_col.rgb, vec3(2.2)); // Linearize pattern
        
        lowp vec3 pattern_blended = apply_blend_branchless(pattern_blend_mode, final_rgb, pattern_col.rgb);
        final_rgb = mix(final_rgb, pattern_blended, pattern_opacity * pattern_col.a);
    }
    
    // Convert Back to sRGB display space
    final_rgb = pow(final_rgb, vec3(1.0 / 2.2));

    // --- 3. FINAL POLISH ---
    // Apply Bayer Matrix Dithering to eliminate color banding
    if (dither_strength > 0.0) {
        const float bayer_matrix[16] = float[](
            -0.5, 0.0, -0.375, 0.125,
            0.25, -0.25, 0.375, -0.125,
            -0.4375, 0.0625, -0.3125, 0.1875,
            0.3125, -0.1875, 0.4375, -0.0625
        );
        int bayer_index = int(mod(FRAGCOORD.x, 4.0)) + int(mod(FRAGCOORD.y, 4.0)) * 4;
        final_rgb += bayer_matrix[bayer_index] * dither_strength;
    }

    // Output with optional Premultiplied Alpha for halo-free particle blending
    final_rgb *= premultiplied_alpha ? base_color.a : 1.0;
    
    COLOR = vec4(final_rgb, base_color.a);
}