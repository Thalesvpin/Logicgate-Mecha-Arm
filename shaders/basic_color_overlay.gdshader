shader_type canvas_item;
render_mode unshaded;

// --- BASE OVERLAY ---
group_uniforms BaseOverlay;
uniform int blend_mode : hint_enum("Normal", "Multiply", "Screen", "Overlay", "Darken", "Lighten", "Color Dodge", "Linear Dodge", "Difference") = 0;
uniform vec4 overlay_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float overlay_opacity : hint_range(0.0, 1.0) = 1.0;

// --- GRADIENT OVERLAY ---
group_uniforms GradientOverlay;
uniform bool use_gradient = false;
uniform int gradient_type : hint_enum("Linear", "Radial") = 0;
uniform vec4 gradient_color_start : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 gradient_color_end : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float gradient_angle : hint_range(0.0, 360.0) = 0.0;

// --- PATTERN OVERLAY ---
group_uniforms PatternOverlay;
uniform bool use_pattern = false;
uniform sampler2D pattern_texture : source_color, hint_default_white;
uniform vec2 pattern_scale = vec2(1.0, 1.0);
uniform float pattern_opacity : hint_range(0.0, 1.0) = 1.0;
uniform int pattern_blend_mode : hint_enum("Normal", "Multiply", "Screen", "Overlay") = 1;

group_uniforms; // Resets grouping back to default

// Varying to pass pre-calculated gradient rotation to fragment stage
varying vec2 vertex_gradient_dir;

void vertex() {
    float rads = radians(gradient_angle);
    vertex_gradient_dir = vec2(cos(rads), sin(rads));
}

// Optimized FMA-friendly Blend Math Functions
vec3 blend_normal(vec3 base, vec3 blend) { return blend; }
vec3 blend_multiply(vec3 base, vec3 blend) { return base * blend; }
vec3 blend_screen(vec3 base, vec3 blend) { return base + blend - (base * blend); }
vec3 blend_overlay(vec3 base, vec3 blend) {
    vec3 limit = step(0.5, base);
    return mix(2.0 * base * blend, 2.0 * (base + blend - (base * blend)) - 1.0, limit);
}
vec3 blend_darken(vec3 base, vec3 blend) { return min(base, blend); }
vec3 blend_lighten(vec3 base, vec3 blend) { return max(base, blend); }
vec3 blend_color_dodge(vec3 base, vec3 blend) { 
    return clamp(base / max(vec3(0.0001), 1.0 - blend), 0.0, 1.0); 
}
vec3 blend_linear_dodge(vec3 base, vec3 blend) { return base + blend; }
vec3 blend_difference(vec3 base, vec3 blend) { return abs(base - blend); }

vec3 apply_blend(int mode, vec3 base, vec3 blend) {
    switch (mode) {
        case 0: return blend_normal(base, blend);
        case 1: return blend_multiply(base, blend);
        case 2: return blend_screen(base, blend);
        case 3: return blend_overlay(base, blend);
        case 4: return blend_darken(base, blend);
        case 5: return blend_lighten(base, blend);
        case 6: return blend_color_dodge(base, blend);
        case 7: return blend_linear_dodge(base, blend);
        case 8: return blend_difference(base, blend);
    }
    return blend;
}

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
    if (base_color.a <= 0.0) {
        discard;
    }
    
    // 1. Determine Effective Overlay Color (Solid vs Gradient)
    vec4 current_overlay = overlay_color;
    if (use_gradient) {
        vec2 centered_uv = UV - 0.5;
        float factor = (gradient_type == 0) 
            ? clamp((centered_uv.x * vertex_gradient_dir.x - centered_uv.y * vertex_gradient_dir.y) + 0.5, 0.0, 1.0)
            : clamp(length(centered_uv) * 2.0, 0.0, 1.0);
        
        current_overlay = mix(gradient_color_start, gradient_color_end, factor);
    }
    
    // Cache primary mix weight to eliminate duplicate per-fragment multiplications
    float primary_weight = overlay_opacity * current_overlay.a;
    
    // Apply primary overlay color using selected blend mode
    vec3 blended_rgb = apply_blend(blend_mode, base_color.rgb, current_overlay.rgb);
    vec3 final_rgb = mix(base_color.rgb, blended_rgb, primary_weight);
    
    // 2. Apply Secondary Pattern Texture Overlay (if enabled)
    if (use_pattern) {
        vec4 pattern_col = texture(pattern_texture, UV * pattern_scale);
        vec3 pattern_blended = apply_blend(pattern_blend_mode, final_rgb, pattern_col.rgb);
        final_rgb = mix(final_rgb, pattern_blended, pattern_opacity * pattern_col.a);
    }
    
    COLOR = vec4(final_rgb, base_color.a);
}
