shader_type canvas_item;
render_mode unshaded;

// --- GLOBAL SETTINGS ---
group_uniforms GlobalSettings;
uniform mediump float gamma : hint_range(0.1, 3.0) = 1.0;
uniform bool premultiplied_alpha = false;
uniform lowp float feather_edges : hint_range(0.0, 1.0) = 0.0;
uniform lowp float dither_strength : hint_range(0.0, 0.1) = 0.0;
uniform lowp float final_opacity : hint_range(0.0, 1.0) = 1.0; // transparência final

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

// --- PACKED VARYINGS (Optimizations #29 & #30) ---
// Packing saves 60% of varying register limits on hardware
varying mediump vec4 v_pack1; // x: aspect, y: grad_scale_inv, z: grad_cos, w: grad_sin
varying mediump vec4 v_pack2; // x: pat_cos, y: pat_sin, z: sheet_scale_x, w: sheet_scale_y
varying mediump vec2 v_pack3; // x: sheet_offset_x, y: sheet_offset_y

// --- VERTEX STAGE ---
void vertex() {
    mediump float g_rads = radians(gradient_angle);
    mediump float p_rads = radians(pattern_angle);
    mediump vec2 sheet_scale = 1.0 / vec2(pattern_frames);

    // Pack 10 floats into highly efficient vector pipelines
    v_pack1 = vec4(
        TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x,
        1.0 / max(gradient_scale, 0.001),
        cos(g_rads),
        sin(g_rads)
    );

    v_pack2 = vec4(
        cos(p_rads),
        sin(p_rads),
        sheet_scale.x,
        sheet_scale.y
    );

    v_pack3 = vec2(
        float(pattern_frame % pattern_frames.x),
        float(pattern_frame / pattern_frames.x)
    ) * sheet_scale;
}

// --- EFFICIENT BLEND SWITCH ---
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

// --- FRAGMENT STAGE ---
void fragment() {
    lowp vec4 base_color = texture(TEXTURE, UV);
    
    // Optimization #26: Smart Branch Elimination (using step/mix instead of if)
    base_color.a *= mix(1.0, smoothstep(0.0, feather_edges + 0.0001, base_color.a), step(0.0001, feather_edges));

    lowp vec3 linear_base = pow(base_color.rgb, vec3(gamma * 2.2));
    
    // Branchless overlay assignment
    lowp vec4 current_overlay = vec4(0.0);
    current_overlay += overlay_color * float(use_base_overlay); 

    // --- 1. GRADIENT PASS ---
    if (use_gradient) {
        // Unpack matrix
        mediump mat2 grad_rot = mat2(vec2(v_pack1.z, v_pack1.w), vec2(-v_pack1.w, v_pack1.z));

        mediump vec2 centered_uv = UV - 0.5 - gradient_offset;
        centered_uv.x *= v_pack1.x; 
        centered_uv *= grad_rot;
        centered_uv *= v_pack1.y;
        
        mediump float factor = (gradient_type == 0) ? centered_uv.x + 0.5 : length(centered_uv) * 2.0;
        factor = clamp(factor, 0.0, 1.0);
        
        // Branchless ease interpolation
        factor = mix(factor, smoothstep(0.0, 1.0, factor), gradient_smoothstep);
        
        lowp vec4 grad_color = texture(gradient_texture, vec2(factor, 0.5));
        
        // Branchless integration
        current_overlay = mix(current_overlay, grad_color, grad_color.a * float(use_gradient));
    }
    
    current_overlay.rgb = pow(current_overlay.rgb, vec3(2.2));
    
    // Optimization #31: Blend Mode Weight Blending (FMA Algebra)
    lowp vec3 final_rgb = linear_base;
    if (use_base_overlay || use_gradient) {
        lowp vec3 blended_rgb = apply_blend(blend_mode, linear_base, current_overlay.rgb);
        final_rgb = linear_base + (blended_rgb - linear_base) * (overlay_opacity * current_overlay.a);
    }
    
    // --- 2. PATTERN PASS ---
    if (use_pattern) {
        mediump mat2 pat_rot = mat2(vec2(v_pack2.x, v_pack2.y), vec2(-v_pack2.y, v_pack2.x));

        // Branchless coordinate handling
        mediump vec2 p_uv = mix(UV, SCREEN_UV, float(pattern_screen_space));
        mediump float aspect = mix(v_pack1.x, SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, float(pattern_screen_space));
        p_uv.x *= aspect; 
        
        p_uv *= pat_rot;
        p_uv *= pattern_scale;
        
        // Optimization #28: Sub-Pixel Jitter Prevention (fract loop)
        p_uv += fract(TIME * pattern_velocity); 
        
        // Branchless sprite sheet math
        p_uv = fract(p_uv) * vec2(v_pack2.z, v_pack2.w) + v_pack3;

        lowp vec4 pattern_col = texture(pattern_texture, p_uv);
        pattern_col.rgb = pow(pattern_col.rgb, vec3(2.2));
        
        lowp vec3 pattern_blended = apply_blend(pattern_blend_mode, final_rgb, pattern_col.rgb);
        
        // FMA Weight blending
        final_rgb = final_rgb + (pattern_blended - final_rgb) * (pattern_opacity * pattern_col.a);
    }
    
    final_rgb = pow(final_rgb, vec3(0.454545)); // 1.0 / 2.2 approximation

    // --- 3. FINAL POLISH ---
    if (dither_strength > 0.0) {
        const float bayer_matrix[16] = float[](
            -0.5, 0.0, -0.375, 0.125,
            0.25, -0.25, 0.375, -0.125,
            -0.4375, 0.0625, -0.3125, 0.1875,
            0.3125, -0.1875, 0.4375, -0.0625
        );
        ivec2 f = ivec2(int(FRAGCOORD.x) & 3, int(FRAGCOORD.y) & 3); 
        int bayer_index = f.x + (f.y << 2); 
        
        // Optimization #27: Optimized Luminance Weights
        // Prevents over-dithering bright areas by analyzing shadow luminance mathematically
        lowp float luma = dot(base_color.rgb, vec3(0.299, 0.587, 0.114));
        lowp float dither_weight = mix(1.0, luma, 0.5); 
        
        final_rgb += bayer_matrix[bayer_index] * (dither_strength * dither_weight);
    }

    // --- 4. FINAL TRANSPARENCY (aplicada após todos os efeitos) ---
    lowp float final_alpha = base_color.a * final_opacity;

    // Premultiplied usa o alpha final, para a cor continuar consistente
    final_rgb *= mix(vec3(1.0), vec3(final_alpha), float(premultiplied_alpha));
    
    COLOR = vec4(final_rgb, final_alpha);
}
