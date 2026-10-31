shader_type canvas_item;

// --- Core Bloom Settings ---
uniform sampler2D t0 : hint_screen_texture, filter_linear, repeat_disable;
uniform float bloom_spread = 1.0;
uniform float bloom_intensity = 2.0;
uniform vec4 bloom_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0); 

// --- Background Compositing ---
uniform float background_dimming : hint_range(0.0, 1.0) = 1.0; 

// --- Pulsation Settings ---
uniform bool enable_pulsation = false;
uniform float pulse_speed : hint_range(0.0, 10.0) = 3.0;
uniform float pulse_min_intensity : hint_range(0.0, 10.0) = 0.5;
uniform float pulse_max_intensity : hint_range(0.0, 10.0) = 2.0;

// --- Independent Corners & Geometry ---
uniform vec4 corner_radii = vec4(0.0); 
uniform bool use_beveled_corners = false; 

// --- Edge Fade Settings ---
uniform bool enable_edge_fade = false;
uniform float fade_start_distance : hint_range(0.0, 500.0) = 50.0;
uniform float fade_smoothness : hint_range(0.1, 10.0) = 1.0;

// Varyings to transfer data from the vertex shader to the fragment shader
varying vec2 local_pos;
varying float v_pulse_mult; // Holds the pre-calculated pulsation math

void vertex() {
    local_pos = VERTEX;
    
    // OPTIMIZATION: Pulsation is calculated once per object here, instead of millions of times per frame in fragment()
    v_pulse_mult = 1.0;
    if (enable_pulsation) {
        float pulse = (sin(TIME * pulse_speed) * 0.5) + 0.5;
        v_pulse_mult = mix(pulse_min_intensity, pulse_max_intensity, pulse);
    }
}

void fragment() {
    // 1. Calculate the exact unscaled local dimensions of the ColorRect
    vec2 local_grad_x = vec2(dFdx(local_pos.x), dFdy(local_pos.x));
    vec2 uv_grad_x = vec2(dFdx(UV.x), dFdy(UV.x));
    float rect_width = length(local_grad_x) / max(length(uv_grad_x), 0.0001);
    
    vec2 local_grad_y = vec2(dFdx(local_pos.y), dFdy(local_pos.y));
    vec2 uv_grad_y = vec2(dFdx(UV.y), dFdy(UV.y));
    float rect_height = length(local_grad_y) / max(length(uv_grad_y), 0.0001);
    
    vec2 dynamic_rect_size = vec2(rect_width, rect_height);

    // 2. Shape and SDF calculation
    vec2 uv_cen = UV - 0.5;
    vec2 pixel_pos = uv_cen * dynamic_rect_size;
    vec2 half_size = dynamic_rect_size * 0.5;
    
    vec2 q_sign = step(0.0, uv_cen); 
    float r = mix(mix(corner_radii.w, corner_radii.z, q_sign.x), mix(corner_radii.x, corner_radii.y, q_sign.x), q_sign.y);
    r = min(r, min(half_size.x, half_size.y));

    vec2 q_box = abs(pixel_pos) - half_size + vec2(r);
    vec2 max_q_vec = max(q_box, 0.0);
    float max_q = max(q_box.x, q_box.y);
    float dist_inner = min(max_q, 0.0) - r;
    
    float d = use_beveled_corners ? max(max_q, (max_q_vec.x + max_q_vec.y) * 0.70710678) + dist_inner : length(max_q_vec) + dist_inner;
    
    // 3. Zoom-Independent Anti-Aliasing
    float screen_scale = 1.0 / max(length(local_grad_x), 0.0001); 
    float d_screen = d * screen_scale;
    float alpha = 1.0 - smoothstep(-0.5, 0.5, d_screen);
    
    if (alpha <= 0.0) {
        discard;
    }

    // 4. MAXIMUM OPTIMIZATION: 13-Tap Circular Pattern
    float scaled_bloom = bloom_spread * screen_scale;
    vec2 texel_step = SCREEN_PIXEL_SIZE * scaled_bloom * 2.0; 
    
    // Center tap
    vec4 sum = texture(t0, SCREEN_UV); 
    
    // Inner Ring (Hexagonal, Radius 1.0)
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 0.0,     1.0));
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 0.866,   0.5));
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 0.866,  -0.5));
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 0.0,    -1.0));
    sum += texture(t0, SCREEN_UV + texel_step * vec2(-0.866,  -0.5));
    sum += texture(t0, SCREEN_UV + texel_step * vec2(-0.866,   0.5));
    
    // Outer Ring (Hexagonal, Radius 2.0)
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 0.0,     2.0));
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 1.732,   1.0));
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 1.732,  -1.0));
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 0.0,    -2.0));
    sum += texture(t0, SCREEN_UV + texel_step * vec2(-1.732,  -1.0));
    sum += texture(t0, SCREEN_UV + texel_step * vec2(-1.732,   1.0));

    vec4 bloom_added = (sum / 13.0) * bloom_intensity;

    // 5. Customization Passes
    bloom_added *= v_pulse_mult; // Apply pre-calculated vertex math
    bloom_added *= bloom_tint;
    
    // 6. Edge Fade Logic 
    if (enable_edge_fade && fade_start_distance > 0.0) {
        float dist_to_edge = -d; 
        float fade_factor = clamp(dist_to_edge / fade_start_distance, 0.0, 1.0);
        fade_factor = pow(smoothstep(0.0, 1.0, fade_factor), fade_smoothness);
        bloom_added *= fade_factor;
    }

    // 7. Background Compositing
    vec4 bg_color = texture(t0, SCREEN_UV);
    bg_color.rgb *= background_dimming; 

    vec4 final_color = bg_color + bloom_added;
    
    COLOR = vec4(final_color.rgb, alpha);
}