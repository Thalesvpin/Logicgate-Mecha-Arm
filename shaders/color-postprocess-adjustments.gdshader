shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

// HSCB Controls
uniform float brightness : hint_range(0.0, 2.0) = 1.0;
uniform float contrast : hint_range(0.0, 2.0) = 1.0;
uniform float saturation : hint_range(0.0, 2.0) = 1.0;
uniform float hue : hint_range(0.0, 1.0) = 0.0;

// Gradient Map Controls
uniform bool use_gradient_map = false;
uniform sampler2D gradient_texture : source_color, filter_linear, repeat_disable;

// Effect Controls
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.4;
uniform float vignette_smoothness : hint_range(0.1, 2.0) = 0.8;
uniform float chromatic_aberration : hint_range(0.0, 0.02) = 0.003;

// Branchless RGB to HSV conversion
vec3 rgb_to_hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

// Branchless HSV to RGB conversion
vec3 hsv_to_rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// Helper to apply full color grading to any color sample
vec3 apply_color_corrections(vec3 col) {
    // Combined Brightness & Contrast
    col = (col * brightness - 0.5) * contrast + 0.5;
    
    // Hue & Saturation
    vec3 hsv = rgb_to_hsv(col);
    hsv.x = mod(hsv.x + hue, 1.0);
    hsv.y *= saturation;
    return hsv_to_rgb(hsv);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 centered_uv = uv - 0.5;
    
    // 1. Sample screen texture at offset locations for chromatic aberration
    vec3 col_r = texture(screen_texture, uv + centered_uv * chromatic_aberration).rgb;
    vec3 col_g = texture(screen_texture, uv).rgb;
    vec3 col_b = texture(screen_texture, uv - centered_uv * chromatic_aberration).rgb;
    
    // 2. Apply color corrections to each sample
    col_r = apply_color_corrections(col_r);
    col_g = apply_color_corrections(col_g);
    col_b = apply_color_corrections(col_b);
    
    // 3. Assemble final color channels
    vec3 col = vec3(col_r.r, col_g.g, col_b.b);
    
    // 4. Gradient Map (Applied if toggled on)
    if (use_gradient_map) {
        float luminance = dot(col, vec3(0.2126, 0.7152, 0.0722));
        col = texture(gradient_texture, vec2(luminance, 0.0)).rgb;
    }
    
    // 5. Optimized Vignette applied last
    float dist_sq = dot(centered_uv, centered_uv);
    float vignette = smoothstep(0.25, vignette_smoothness * 0.25, dist_sq * (vignette_intensity + 0.5));
    col = mix(col, col * (1.0 - vignette_intensity), vignette);
    
    COLOR = vec4(col, 1.0);
}