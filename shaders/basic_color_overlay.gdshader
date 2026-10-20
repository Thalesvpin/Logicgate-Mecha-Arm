shader_type canvas_item;
render_mode unshaded; // Bypasses Godot's 2D lighting pipeline entirely

// --- GLOBAL SETTINGS ---
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
uniform sampler2D gradient_texture : source_color; 
uniform mediump float gradient_angle : hint_range(0.0, 360.0) = 0.0;
uniform mediump vec2 gradient_offset = vec2(0.0, 0.0);
uniform mediump float gradient_scale = 1.0;
uniform mediump float gradient_smoothstep : hint_range(0.0, 1.0) = 0.0;

// --- PATTERN OVERLAY ---
group_uniforms PatternOverlay;
uniform bool use_pattern = false;
uniform sampler2D pattern_texture : source_color, hint_default_white, filter_linear_mipmap_anisotropic;
uniform int pattern_blend_mode : hint_enum("Normal", "Multiply", "Screen", "Overlay", "Darken", "Lighten", "Color Dodge", "Linear Dodge", "Difference") = 1;
uniform lowp float pattern_opacity : hint_range(0.0, 1.0) = 1.0;
uniform mediump vec2 pattern_scale = vec2(1.0, 1.0);
uniform mediump float pattern_angle : hint_range(0.0, 360.0) = 0.0;
uniform mediump vec2 pattern_velocity = vec2(0.0, 0.0);
uniform bool pattern_screen_space = false;
uniform ivec2 pattern_frames = ivec2(1, 1);
uniform int pattern_frame = 0;

group_uniforms; // Reset Grouping

// --- VARYINGS (Pre-calculated in Vertex) ---
varying mediump mat2 v_grad_rot;
varying mediump mat2 v_pattern_rot;
varying mediump float v_aspect;
varying mediump vec2 v_sheet_scale;
varying mediump vec2 v_sheet_offset;
varying mediump float v_grad_scale_inv;

// --- VERTEX STAGE (Calculated 4 times per object) ---
void vertex() {
    // Vectorized rotations
    mediump float g_rads = radians(gradient_angle);
    v_grad_rot = mat2(vec2(cos(g_rads), sin(g_rads)), vec2(-sin(g_rads), cos(g_rads)));
    v_grad_scale_inv = 1.0 / max(gradient_scale, 0.001);
    
    mediump float p_rads = radians(pattern_angle);
    v_pattern_rot = mat2(vec2(cos(p_rads), sin(p_rads)), vec2(-sin(p_rads), cos(p_rads)));

    // Pre-calculate texture aspect ratio (TEXTURE_PIXEL_SIZE is valid in vertex)
    v_aspect = TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x;

    // Pre-calculate Sprite Sheet framing (eliminates per-pixel modulo & division)
    v_sheet_scale = 1.0 / vec2(pattern_frames);
    v_sheet_offset = vec2(
        float(pattern_frame % pattern_frames.x), 
        float(pattern_frame / pattern_frames.x)
    ) * v_sheet_scale;
}

// --- EFFICIENT BLEND SWITCH (Zero Warp Divergence) ---
lowp vec3 apply_blend(int mode, lowp vec3 base, lowp vec3 blend) {
    switch (mode) {
        case 0: return blend;
        case 1: return base * blend;
        case 2: return base + blend - (base * blend);
        case 3: return mix(2.0 * base * blend, 2.0 * (base + blend - (base * blend)) - 1.0, step(0.5, base));
        case 4: return min(base, blend);
        case 5: return max(base, blend);
        case 6: return clamp(base / max(vec3(0.0001), 1.0 - blend), 0.0, 1.0);
        case 7: return base + blend;
        case 8: return abs(base - blend);
    }
    return blend;
}

// --- FRAGMENT STAGE (Calculated millions of times) ---
void fragment() {
    lowp vec4 base_color = texture(TEXTURE, UV);
    
    // Uniform branch: Only run feather math if requested
    if (feather_edges > 0.0) {
        base_color.a *= smoothstep(0.0, feather_edges + 0.0001, base_color.a);
    }

    // Consolidated Pow: Apply Gamma AND convert to Linear Space in one mathematical step
    lowp vec3 linear_base = pow(base_color.rgb, vec3(gamma * 2.2));
    
    lowp vec4 current_overlay = use_base_overlay ? overlay_color : vec4(0.0);

    // --- 1. GRADIENT PASS ---
    if (use_gradient) { // Uniform branches completely skip unused logic
        mediump vec2 centered_uv = UV - 0.5 - gradient_offset;
        centered_uv.x *= v_aspect; 
        centered_uv *= v_grad_rot;
        centered_uv *= v_grad_scale_inv;
        
        mediump float factor = (gradient_type == 0) ? centered_uv.x + 0.5 : length(centered_uv) * 2.0;
        factor = clamp(factor, 0.0, 1.0);
        
        if (gradient_smoothstep > 0.0) {
            factor = mix(factor, smoothstep(0.0, 1.0, factor), gradient_smoothstep);
        }
        
        lowp vec4 grad_color = texture(gradient_texture, vec2(factor, 0.5));
        current_overlay = use_base_overlay ? mix(current_overlay, grad_color, grad_color.a) : grad_color;
    }
    
    // Linearize the resulting overlay color
    current_overlay.rgb = pow(current_overlay.rgb, vec3(2.2));
    
    // Evaluate Primary Blend (Bypassed entirely if both overlays are disabled)
    lowp vec3 final_rgb = linear_base;
    if (use_base_overlay || use_gradient) {
        lowp vec3 blended_rgb = apply_blend(blend_mode, linear_base, current_overlay.rgb);
        final_rgb = mix(linear_base, blended_rgb, overlay_opacity * current_overlay.a);
    }
    
    // --- 2. PATTERN PASS ---
    if (use_pattern) {
        mediump vec2 p_uv = pattern_screen_space ? SCREEN_UV : UV;
        p_uv.x *= pattern_screen_space ? (SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x) : v_aspect; 
        
        p_uv *= v_pattern_rot;
        p_uv *= pattern_scale;
        p_uv += TIME * pattern_velocity;
        
        if (pattern_frames.x > 1 || pattern_frames.y > 1) {
            p_uv = fract(p_uv) * v_sheet_scale + v_sheet_offset;
        }

        lowp vec4 pattern_col = texture(pattern_texture, p_uv);
        pattern_col.rgb = pow(pattern_col.rgb, vec3(2.2));
        
        lowp vec3 pattern_blended = apply_blend(pattern_blend_mode, final_rgb, pattern_col.rgb);
        final_rgb = mix(final_rgb, pattern_blended, pattern_opacity * pattern_col.a);
    }
    
    // Convert back to sRGB. (0.454545 is a pre-calculated 1.0 / 2.2 approximation)
    final_rgb = pow(final_rgb, vec3(0.454545));

    // --- 3. FINAL POLISH ---
    if (dither_strength > 0.0) {
        const float bayer_matrix[16] = float[](
            -0.5, 0.0, -0.375, 0.125,
            0.25, -0.25, 0.375, -0.125,
            -0.4375, 0.0625, -0.3125, 0.1875,
            0.3125, -0.1875, 0.4375, -0.0625
        );
        // Fixed bitwise component-wise wrapping
        ivec2 f = ivec2(int(FRAGCOORD.x) & 3, int(FRAGCOORD.y) & 3); 
        int bayer_index = f.x + (f.y << 2); 
        final_rgb += bayer_matrix[bayer_index] * dither_strength;
    }

    final_rgb *= premultiplied_alpha ? base_color.a : 1.0;
    COLOR = vec4(final_rgb, base_color.a);
}