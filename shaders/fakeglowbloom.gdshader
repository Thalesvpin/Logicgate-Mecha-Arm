shader_type canvas_item;

uniform sampler2D t0 : hint_screen_texture;
uniform float bloom_spread = 1.0;
uniform float bloom_intensity = 2.0;

// --- Independent Corners & Geometry ---
uniform vec4 corner_radii = vec4(0.0); // TL, TR, BR, BL
uniform bool use_beveled_corners = false; 

// --- Edge Fade Settings ---
uniform bool enable_edge_fade = false;
uniform float fade_start_distance : hint_range(0.0, 500.0) = 50.0;
uniform float fade_smoothness : hint_range(0.1, 10.0) = 1.0;

// Varying to transfer the local vertex position to the fragment shader
varying vec2 local_pos;

void vertex() {
    // Captures the local unscaled coordinates of the ColorRect
    local_pos = VERTEX;
}

void fragment() {
    // 1. Calculate the exact unscaled local dimensions of the ColorRect, independent of camera zoom
    vec2 local_grad_x = vec2(dFdx(local_pos.x), dFdy(local_pos.x));
    vec2 uv_grad_x = vec2(dFdx(UV.x), dFdy(UV.x));
    float rect_width = length(local_grad_x) / max(length(uv_grad_x), 0.0001);
    
    vec2 local_grad_y = vec2(dFdx(local_pos.y), dFdy(local_pos.y));
    vec2 uv_grad_y = vec2(dFdx(UV.y), dFdy(UV.y));
    float rect_height = length(local_grad_y) / max(length(uv_grad_y), 0.0001);
    
    vec2 dynamic_rect_size = vec2(rect_width, rect_height);

    // 2. Shape and SDF calculation (evaluated purely in local unscaled pixels)
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
    // We calculate exactly how many screen pixels fit into 1 local pixel.
    float screen_scale = 1.0 / max(length(local_grad_x), 0.0001); 
    
    // Convert the local SDF back to screen space purely for a perfectly crisp 1px cut edge
    float d_screen = d * screen_scale;
    float alpha = 1.0 - smoothstep(-0.5, 0.5, d_screen);
    
    if (alpha <= 0.0) {
        discard;
    }

    // 4. Bloom Logic
    // Multiply spread by screen scale so the bloom radius physically inflates/deflates with camera zoom
    float scaled_bloom = bloom_spread * screen_scale;

    ivec2 size = textureSize(t0, 0);
    float uv_x = SCREEN_UV.x * float(size.x);
    float uv_y = SCREEN_UV.y * float(size.y);

    vec4 sum = vec4(0.0);
    for (int n = 0; n < 9; ++n) {
        uv_y = (SCREEN_UV.y * float(size.y)) + float(scaled_bloom * float(n - 4));
        vec4 h_sum = vec4(0.0);
        h_sum += texelFetch(t0, ivec2(int(uv_x) - int(4.0 * scaled_bloom), int(uv_y)), 0);
        h_sum += texelFetch(t0, ivec2(int(uv_x) - int(3.0 * scaled_bloom), int(uv_y)), 0);
        h_sum += texelFetch(t0, ivec2(int(uv_x) - int(2.0 * scaled_bloom), int(uv_y)), 0);
        h_sum += texelFetch(t0, ivec2(int(uv_x) - int(scaled_bloom), int(uv_y)), 0);
        h_sum += texelFetch(t0, ivec2(int(uv_x), int(uv_y)), 0);
        h_sum += texelFetch(t0, ivec2(int(uv_x) + int(scaled_bloom), int(uv_y)), 0);
        h_sum += texelFetch(t0, ivec2(int(uv_x) + int(2.0 * scaled_bloom), int(uv_y)), 0);
        h_sum += texelFetch(t0, ivec2(int(uv_x) + int(3.0 * scaled_bloom), int(uv_y)), 0);
        h_sum += texelFetch(t0, ivec2(int(uv_x) + int(4.0 * scaled_bloom), int(uv_y)), 0);
        sum += h_sum / 9.0;
    }

    vec4 bloom_added = (sum / 9.0) * bloom_intensity;
    
    // 5. Edge Fade Logic 
    if (enable_edge_fade && fade_start_distance > 0.0) {
        // -d is the inward distance from the border in purely local pixels
        float dist_to_edge = -d; 
        
        // This math is entirely zoom-agnostic. 50 fade distance means 50 unscaled ColorRect pixels.
        float fade_factor = clamp(dist_to_edge / fade_start_distance, 0.0, 1.0);
        fade_factor = pow(smoothstep(0.0, 1.0, fade_factor), fade_smoothness);
        
        bloom_added *= fade_factor;
    }

    vec4 final_color = texture(t0, SCREEN_UV) + bloom_added;
    
    COLOR = vec4(final_color.rgb, alpha);
}