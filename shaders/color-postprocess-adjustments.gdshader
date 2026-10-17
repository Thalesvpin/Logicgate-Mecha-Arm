shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

// HSCB Controls
uniform float brightness : hint_range(0.0, 2.0) = 1.0;
uniform float contrast : hint_range(0.0, 2.0) = 1.0;
uniform float saturation : hint_range(0.0, 2.0) = 1.0;
uniform float hue : hint_range(0.0, 1.0) = 0.0;

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

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 centered_uv = uv - 0.5;
    
    // 1. Optimized Chromatic Aberration (3-tap vector construct)
    vec3 col = vec3(
        texture(screen_texture, uv + centered_uv * chromatic_aberration).r,
        texture(screen_texture, uv).g,
        texture(screen_texture, uv - centered_uv * chromatic_aberration).b
    );
    
    // 2 & 3. Combined Brightness & Contrast pass (reduced instruction count)
    col.rgb = (col.rgb * brightness - 0.5) * contrast + 0.5;
    
    // 4. Hue & Saturation
    vec3 hsv = rgb_to_hsv(col.rgb);
    hsv.x = mod(hsv.x + hue, 1.0);
    hsv.y *= saturation;
    col.rgb = hsv_to_rgb(hsv);
    
    // 5. Optimized Vignette (using squared distance to spare ALU cycles)
    float dist_sq = dot(centered_uv, centered_uv);
    float vignette = smoothstep(0.25, vignette_smoothness * 0.25, dist_sq * (vignette_intensity + 0.5));
    col.rgb = mix(col.rgb, col.rgb * (1.0 - vignette_intensity), vignette);
    
    COLOR = vec4(col, 1.0);
}