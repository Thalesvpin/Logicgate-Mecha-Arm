shader_type canvas_item;

group_uniforms Core_Bloom;
uniform sampler2D t0 : hint_screen_texture, filter_linear, repeat_disable;
uniform float bloom_spread = 1.0;
uniform float bloom_intensity = 2.0;
uniform vec4 bloom_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0); 

group_uniforms Background_Compositing;
uniform float background_dimming : hint_range(0.0, 1.0) = 1.0; 

group_uniforms Mouse_Interaction;
uniform bool enable_mouse = false;
uniform vec2 mouse_global_pos = vec2(-10000.0, -10000.0); 
uniform float mouse_radius : hint_range(10.0, 1000.0) = 150.0; 
uniform float mouse_smoothness : hint_range(0.0, 1.0) = 0.5; 

group_uniforms Mouse_Interaction.Intensity_And_Color;
uniform float mouse_boost : hint_range(0.0, 50.0) = 3.0; // Greatly increased upper limit
uniform float mouse_hue_shift : hint_range(-3.14159, 3.14159) = 0.0; // Rotates the color wheel (Radians)
uniform float mouse_saturation : hint_range(0.0, 5.0) = 1.0; // 0.0 = Grayscale, 1.0 = Normal, 2.0+ = Hyper vibrant
uniform vec4 mouse_tint_override : source_color = vec4(1.0, 1.0, 1.0, 1.0); // An alternate color to blend into
uniform float mouse_tint_mix : hint_range(0.0, 1.0) = 0.0; // How strongly the override color takes over on hover

group_uniforms FX_And_Animation.Pulsation;
uniform bool enable_pulsation = false;
uniform float pulse_speed : hint_range(0.0, 10.0) = 3.0;
uniform float pulse_min_intensity : hint_range(0.0, 10.0) = 0.5;
uniform float pulse_max_intensity : hint_range(0.0, 10.0) = 2.0;

group_uniforms FX_And_Animation.Glitch;
uniform bool enable_flicker = false;
uniform float flicker_speed : hint_range(0.1, 50.0) = 15.0; 
uniform float flicker_threshold : hint_range(0.0, 1.0) = 0.8; 
uniform float flicker_drop : hint_range(0.0, 1.0) = 0.85; 

group_uniforms Geometry_And_Masking;
uniform vec4 corner_radii = vec4(0.0); 
uniform bool use_beveled_corners = false; 

group_uniforms Geometry_And_Masking.Edge_Fade;
uniform bool enable_edge_fade = false;
uniform float fade_start_distance : hint_range(0.0, 500.0) = 50.0;

varying vec2 local_pos;
varying vec2 v_global_pos; 
varying float v_pulse_mult; 
varying float v_flicker_mult;

// Mathematical Hue Shift Function[cite: 3]
vec3 hue_shift(vec3 color, float shift) {
    const vec3 k = vec3(0.57735);
    float cosAngle = cos(shift);
    return vec3(color * cosAngle + cross(k, color) * sin(shift) + k * dot(k, color) * (1.0 - cosAngle));
}

void vertex() {
    local_pos = VERTEX;
    v_global_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy; 
    
    v_pulse_mult = 1.0;
    if (enable_pulsation) {
        float pulse = (sin(TIME * pulse_speed) * 0.5) + 0.5;
        v_pulse_mult = mix(pulse_min_intensity, pulse_max_intensity, pulse);
    }
    
    v_flicker_mult = 1.0;
    if (enable_flicker) {
        float time_step = floor(TIME * flicker_speed);
        float noise1 = fract(sin(time_step * 12.9898) * 43758.5453);
        float noise2 = fract(sin(time_step * 78.233) * 43758.5453);
        
        if (noise1 > flicker_threshold) {
            v_flicker_mult = 1.0 - (flicker_drop * noise2);
        }
    }
}

void fragment() {
    vec2 local_grad_x = vec2(dFdx(local_pos.x), dFdy(local_pos.x));
    vec2 uv_grad_x = vec2(dFdx(UV.x), dFdy(UV.x));
    float rect_width = length(local_grad_x) / max(length(uv_grad_x), 0.0001);
    
    vec2 local_grad_y = vec2(dFdx(local_pos.y), dFdy(local_pos.y));
    vec2 uv_grad_y = vec2(dFdx(UV.y), dFdy(UV.y));
    float rect_height = length(local_grad_y) / max(length(uv_grad_y), 0.0001);
    
    vec2 dynamic_rect_size = vec2(rect_width, rect_height);

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
    
    float screen_scale = 1.0 / max(length(local_grad_x), 0.0001); 
    float d_screen = d * screen_scale;
    float alpha = 1.0 - smoothstep(-0.5, 0.5, d_screen);
    
    if (alpha <= 0.0) {
        discard;
    }

    float scaled_bloom = bloom_spread * screen_scale;
    vec2 texel_step = SCREEN_PIXEL_SIZE * scaled_bloom * 2.0; 
    
    vec4 sum = texture(t0, SCREEN_UV); 
    
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 0.0,     1.0));
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 0.866,   0.5));
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 0.866,  -0.5));
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 0.0,    -1.0));
    sum += texture(t0, SCREEN_UV + texel_step * vec2(-0.866,  -0.5));
    sum += texture(t0, SCREEN_UV + texel_step * vec2(-0.866,   0.5));
    
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 0.0,     2.0));
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 1.732,   1.0));
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 1.732,  -1.0));
    sum += texture(t0, SCREEN_UV + texel_step * vec2( 0.0,    -2.0));
    sum += texture(t0, SCREEN_UV + texel_step * vec2(-1.732,  -1.0));
    sum += texture(t0, SCREEN_UV + texel_step * vec2(-1.732,   1.0));

    float local_intensity = bloom_intensity;
    float mouse_factor = 0.0;
    
    if (enable_mouse) {
        float dist_to_mouse = length(v_global_pos - mouse_global_pos);
        mouse_factor = 1.0 - smoothstep(mouse_radius * (1.0 - mouse_smoothness), mouse_radius, dist_to_mouse);
        local_intensity += (mouse_boost * mouse_factor);
    }

    vec4 bloom_added = (sum / 13.0) * local_intensity;

    bloom_added *= v_pulse_mult; 
    bloom_added *= v_flicker_mult; 
    bloom_added *= bloom_tint;
    
    // Dynamic Mouse Color Injection
    if (enable_mouse && mouse_factor > 0.0) {
        // 1. Tint Override Blend
        bloom_added.rgb = mix(bloom_added.rgb, bloom_added.rgb * mouse_tint_override.rgb, mouse_tint_mix * mouse_factor);
        
        // 2. Hue Shifting
        if (mouse_hue_shift != 0.0) {
            bloom_added.rgb = hue_shift(bloom_added.rgb, mouse_hue_shift * mouse_factor);
        }
        
        // 3. Saturation Modification
        if (mouse_saturation != 1.0) {
            vec3 gray = vec3(dot(bloom_added.rgb, vec3(0.299, 0.587, 0.114)));
            float current_sat = mix(1.0, mouse_saturation, mouse_factor);
            bloom_added.rgb = mix(gray, bloom_added.rgb, current_sat);
        }
    }
    
    if (enable_edge_fade && fade_start_distance > 0.0) {
        float dist_to_edge = -d; 
        float fade_factor = clamp(dist_to_edge / fade_start_distance, 0.0, 1.0);
        bloom_added *= smoothstep(0.0, 1.0, fade_factor);
    }

    vec4 bg_color = texture(t0, SCREEN_UV);
    bg_color.rgb *= background_dimming; 

    vec4 final_color = bg_color + bloom_added;
    
    COLOR = vec4(final_color.rgb, alpha);
}