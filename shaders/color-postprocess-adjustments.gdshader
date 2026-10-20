shader_type canvas_item;

// --- 1. GLOBAL SETTINGS ---
group_uniforms Global_Settings;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap, repeat_disable;
uniform bool invert_colors = false;
uniform bool invert_before_grading = false;

// --- 2. TONEMAPPING ---
// HUE
group_uniforms Tonemapping.Hue;
uniform float hue : hint_range(0.0, 1.0) = 0.0;
group_uniforms Tonemapping.Hue.Spatial_Mask;
uniform bool hue_spatial_enable = false;
uniform sampler2D hue_spatial_mask : hint_default_white, filter_linear, repeat_enable;
uniform float hue_spatial_scroll_speed : hint_range(-2.0, 2.0) = 0.0;
uniform float hue_spatial_rotation : hint_range(0.0, 360.0) = 0.0;
uniform bool hue_spatial_invert = false;

// SATURATION
group_uniforms Tonemapping.Saturation;
uniform float saturation : hint_range(0.0, 2.0) = 1.0;
group_uniforms Tonemapping.Saturation.Spatial_Mask;
uniform bool saturation_spatial_enable = false;
uniform sampler2D saturation_spatial_mask : hint_default_white, filter_linear, repeat_enable;
uniform float saturation_spatial_scroll_speed : hint_range(-2.0, 2.0) = 0.0;
uniform float saturation_spatial_rotation : hint_range(0.0, 360.0) = 0.0;
uniform bool saturation_spatial_invert = false;

// BRIGHTNESS
group_uniforms Tonemapping.Brightness;
uniform float brightness : hint_range(0.0, 2.0) = 1.0;
group_uniforms Tonemapping.Brightness.Spatial_Mask;
uniform bool brightness_spatial_enable = false;
uniform sampler2D brightness_spatial_mask : hint_default_white, filter_linear, repeat_enable;
uniform float brightness_spatial_scroll_speed : hint_range(-2.0, 2.0) = 0.0;
uniform float brightness_spatial_rotation : hint_range(0.0, 360.0) = 0.0;
uniform bool brightness_spatial_invert = false;

// CONTRAST
group_uniforms Tonemapping.Contrast;
uniform float contrast : hint_range(0.0, 2.0) = 1.0;
group_uniforms Tonemapping.Contrast.Spatial_Mask;
uniform bool contrast_spatial_enable = false;
uniform sampler2D contrast_spatial_mask : hint_default_white, filter_linear, repeat_enable;
uniform float contrast_spatial_scroll_speed : hint_range(-2.0, 2.0) = 0.0;
uniform float contrast_spatial_rotation : hint_range(0.0, 360.0) = 0.0;
uniform bool contrast_spatial_invert = false;

// EXPOSURE
group_uniforms Tonemapping.Exposure;
uniform float exposure : hint_range(-2.0, 2.0) = 0.0;
group_uniforms Tonemapping.Exposure.Spatial_Mask;
uniform bool exposure_spatial_enable = false;
uniform sampler2D exposure_spatial_mask : hint_default_white, filter_linear, repeat_enable;
uniform float exposure_spatial_scroll_speed : hint_range(-2.0, 2.0) = 0.0;
uniform float exposure_spatial_rotation : hint_range(0.0, 360.0) = 0.0;
uniform bool exposure_spatial_invert = false;

// COLOR TEMP
group_uniforms Tonemapping.Color_Temp;
uniform float color_temp : hint_range(-1.0, 1.0) = 0.0; 
group_uniforms Tonemapping.Color_Temp.Spatial_Mask;
uniform bool color_temp_spatial_enable = false;
uniform sampler2D color_temp_spatial_mask : hint_default_white, filter_linear, repeat_enable;
uniform float color_temp_spatial_scroll_speed : hint_range(-2.0, 2.0) = 0.0;
uniform float color_temp_spatial_rotation : hint_range(0.0, 360.0) = 0.0;
uniform bool color_temp_spatial_invert = false;

// --- 3. GRADIENT MAP ---
group_uniforms Gradient_Map;
uniform bool use_gradient_map = false;
uniform bool grad_before_tonemapping = true;
uniform sampler2D gradient_texture : source_color, filter_linear, repeat_disable;
uniform float grad_mix : hint_range(0.0, 1.0) = 1.0;
uniform int grad_blend_mode : hint_enum("Normal,Multiply,Screen,Overlay,Add,Subtract,Difference,Lighten,Darken,Hard Light") = 0;
uniform float grad_gamma : hint_range(0.1, 3.0) = 1.0;
uniform float grad_min_lum : hint_range(0.0, 1.0) = 0.0;
uniform float grad_max_lum : hint_range(0.0, 1.0) = 1.0;
uniform bool grad_invert = false;

// Spatial Gradient Mix Controls
group_uniforms Gradient_Map.Spatial_Controls;
uniform bool use_spatial_grad_mix = false;
uniform int spatial_grad_type : hint_enum("Linear,Radial,Reflected") = 0;
uniform sampler2D grad_mix_mask : hint_default_white, filter_linear, repeat_enable;
uniform float grad_mix_scale : hint_range(0.1, 10.0) = 1.0;
uniform float grad_mix_rotation : hint_range(0.0, 360.0) = 0.0;
uniform vec2 grad_mix_center = vec2(0.5, 0.5);
uniform float grad_mix_smoothness : hint_range(0.0, 1.0) = 1.0;
uniform float grad_mix_scroll_speed : hint_range(-2.0, 2.0) = 0.0;
uniform bool grad_mix_invert = false;

// --- 4. COLOR BLINDNESS ---
group_uniforms Color_Blindness;
uniform int color_blindness_mode : hint_enum("Off,Protanopia,Deuteranopia,Tritanopia") = 0;

// --- 5. BLURS ---
group_uniforms Blurs;
uniform sampler2D blur_mask : hint_default_white, filter_linear, repeat_enable;
uniform float blur_mask_scroll_speed : hint_range(-2.0, 2.0) = 0.0;
uniform float blur_mask_rotation : hint_range(0.0, 360.0) = 0.0;
uniform bool blur_mask_invert = false;

uniform bool use_gaussian_blur = false;
uniform float gaussian_blur_intensity : hint_range(0.0, 5.0) = 0.0;

uniform int blur_samples : hint_range(2, 32) = 8;
uniform bool use_blur_smoothing = false;
uniform int blur_smoothing_mode : hint_enum("Sandy Jitter,Soft Jitter") = 0;
uniform float blur_smoothing_intensity : hint_range(0.0, 1.0) = 0.5;

uniform bool use_radial_blur = false;
uniform float radial_blur_intensity : hint_range(0.0, 1.0) = 0.05;
uniform vec2 radial_blur_center = vec2(0.5, 0.5);

uniform bool use_directional_blur = false;
uniform float dir_blur_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float dir_blur_angle : hint_range(0.0, 360.0) = 0.0;

// --- 6. CHROMATIC ABERRATION ---
group_uniforms Chromatic_Aberration;
uniform bool use_chromatic_aberration = false;
group_uniforms Chromatic_Aberration.Spatial_Mask;
uniform sampler2D ca_mask : hint_default_white, filter_linear, repeat_enable;
uniform float ca_mask_scroll_speed : hint_range(-2.0, 2.0) = 0.0;
uniform float ca_mask_rotation : hint_range(0.0, 360.0) = 0.0;
uniform bool ca_mask_invert = false;

group_uniforms Chromatic_Aberration;
uniform int ca_type : hint_enum("Linear,Radial,Reflected") = 0;
uniform float chromatic_aberration : hint_range(0.0, 1.0) = 0.02; 
uniform float ca_angle : hint_range(0.0, 360.0) = 0.0;
uniform vec2 ca_center = vec2(0.5, 0.5);

uniform bool use_5tap_ca = false;
uniform vec3 ca_color_1 : source_color = vec3(1.0, 0.0, 0.0);
uniform vec3 ca_color_inter_1 : source_color = vec3(1.0, 0.5, 0.0);
uniform vec3 ca_color_2 : source_color = vec3(0.0, 1.0, 0.0);
uniform vec3 ca_color_inter_2 : source_color = vec3(0.0, 0.5, 1.0);
uniform vec3 ca_color_3 : source_color = vec3(0.0, 0.0, 1.0);

// --- 7. VIGNETTE ---
group_uniforms Vignette;
uniform bool use_vignette = false;
uniform sampler2D vignette_gradient : hint_default_white, source_color, filter_linear, repeat_disable;
uniform sampler2D vignette_opacity_mask : hint_default_white, filter_linear, repeat_disable;
uniform int vignette_blend_mode : hint_enum("Normal,Multiply,Screen,Overlay,Add,Subtract,Difference,Lighten,Darken,Hard Light") = 0;
uniform float vignette_scale : hint_range(0.1, 3.0) = 1.0;
uniform float vignette_master_opacity : hint_range(0.0, 1.0) = 1.0;

// --- 8. STYLIZATION ---
group_uniforms Stylization;
uniform float posterization_steps : hint_range(0.0, 256.0) = 0.0; 

uniform bool use_halftone = false;
uniform float halftone_size : hint_range(1.0, 50.0) = 4.0;
uniform float halftone_angle : hint_range(0.0, 360.0) = 45.0;
uniform float halftone_smoothness : hint_range(0.0, 1.0) = 0.1;
uniform vec3 halftone_dot_color : source_color = vec3(0.0);
uniform vec3 halftone_bg_color : source_color = vec3(1.0);
uniform float halftone_opacity : hint_range(0.0, 1.0) = 1.0;

uniform bool use_dithering = false;
uniform float dither_size : hint_range(1.0, 10.0) = 1.0;
uniform vec3 dither_color_1 : source_color = vec3(0.0);
uniform vec3 dither_color_2 : source_color = vec3(1.0);
uniform float dither_opacity : hint_range(0.0, 1.0) = 1.0;

// --- 9. OVERLAYS ---
group_uniforms Overlays;
uniform bool use_film_grain = false;
uniform float film_grain_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float film_grain_size : hint_range(0.1, 30.0) = 1.0;
uniform float film_grain_speed : hint_range(1.0, 60.0) = 24.0;
uniform bool film_grain_colored = false;

uniform bool use_lens_dirt = false;
uniform sampler2D lens_dirt_texture : hint_default_black, source_color, filter_linear, repeat_disable;
uniform float lens_dirt_intensity : hint_range(0.0, 2.0) = 0.0;
uniform float lens_dirt_threshold : hint_range(0.0, 1.0) = 0.5;


// ==========================================
// CONSTANTS & HELPER FUNCTIONS
// ==========================================

const vec3 LUM_COEFF = vec3(0.2126, 0.7152, 0.0722);

const mat4 BAYER_MATRIX = mat4(
    vec4(0.0, 12.0, 3.0, 15.0) / 16.0,
    vec4(8.0, 4.0, 11.0, 7.0) / 16.0,
    vec4(2.0, 14.0, 1.0, 13.0) / 16.0,
    vec4(10.0, 6.0, 9.0, 5.0) / 16.0
);

float hash(vec2 seed) {
    return fract(sin(dot(seed, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 rgb_to_hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv_to_rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 apply_blend_mode(vec3 base, vec3 blend, int mode) {
    switch (mode) {
        case 0: return blend; 
        case 1: return base * blend; 
        case 2: return 1.0 - (1.0 - base) * (1.0 - blend); 
        case 3: return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), step(0.5, base));
        case 4: return base + blend; 
        case 5: return max(base - blend, vec3(0.0)); 
        case 6: return abs(base - blend); 
        case 7: return max(base, blend); 
        case 8: return min(base, blend); 
        case 9: return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), step(0.5, blend));
        default: return blend;
    }
}

float get_spatial_mask(sampler2D tex, vec2 uv, float scroll_speed, float rot_degrees, bool invert) {
    vec2 centered_uv = uv - 0.5;
    float rot_rad = radians(rot_degrees);
    vec2 sincos = vec2(sin(rot_rad), cos(rot_rad));
    mat2 rm = mat2(vec2(sincos.y, -sincos.x), vec2(sincos.x, sincos.y));
    
    vec2 transformed_uv = rm * centered_uv + 0.5;
    transformed_uv.x -= TIME * scroll_speed; 
    
    float m = texture(tex, fract(transformed_uv)).r;
    return invert ? 1.0 - m : m;
}

// ==========================================
// CORE RENDERING FUNCTIONS
// ==========================================

vec3 apply_gradient_map(vec3 col, vec2 uv) {
    if (!use_gradient_map) return col;
    
    float lum = dot(col, LUM_COEFF);
    lum += (hash(uv) - 0.5) * 0.015; // Anti-banding
    
    lum = pow(clamp(lum, 0.0, 1.0), grad_gamma); 
    if (grad_invert) lum = 1.0 - lum;            
    
    vec3 grad_color = texture(gradient_texture, vec2(lum, 0.0)).rgb;
    float threshold_mask = step(grad_min_lum, lum) * step(lum, grad_max_lum);
    
    float current_mix = grad_mix;
    if (use_spatial_grad_mix) {
        vec2 centered_uv = uv - grad_mix_center;
        float rot = radians(grad_mix_rotation);
        vec2 sincos = vec2(sin(rot), cos(rot));
        mat2 rm = mat2(vec2(sincos.y, -sincos.x), vec2(sincos.x, sincos.y));
        
        vec2 rot_uv = (rm * centered_uv) * grad_mix_scale + 0.5;
        float grad_coord = 0.0;
        
        switch (spatial_grad_type) {
            case 0: grad_coord = rot_uv.x; break;
            case 1: grad_coord = length(centered_uv * grad_mix_scale); break;
            case 2: grad_coord = abs(rot_uv.x - 0.5) * 2.0; break;
        }
        
        grad_coord = fract(grad_coord - TIME * grad_mix_scroll_speed);
        if (grad_mix_invert) grad_coord = 1.0 - grad_coord;
        grad_coord = smoothstep(0.0, clamp(grad_mix_smoothness, 0.001, 1.0), grad_coord);
        
        current_mix *= texture(grad_mix_mask, fract(vec2(grad_coord, rot_uv.y))).r;
    }
    
    vec3 blended = apply_blend_mode(col, grad_color, grad_blend_mode);
    return mix(col, blended, current_mix * threshold_mask);
}

vec3 apply_tonemapping(vec3 col, vec2 uv) {
    if (invert_colors && invert_before_grading) col = 1.0 - col;
    
    if (hue != 0.0 || saturation != 1.0) {
        vec3 hsv = rgb_to_hsv(col);
        if (hue != 0.0) {
            float target_hue = fract(hsv.x + hue);
            float m = hue_spatial_enable ? get_spatial_mask(hue_spatial_mask, uv, hue_spatial_scroll_speed, hue_spatial_rotation, hue_spatial_invert) : 1.0;
            hsv.x = mix(hsv.x, target_hue, m);
        }
        if (saturation != 1.0) {
            float target_sat = hsv.y * saturation;
            float m = saturation_spatial_enable ? get_spatial_mask(saturation_spatial_mask, uv, saturation_spatial_scroll_speed, saturation_spatial_rotation, saturation_spatial_invert) : 1.0;
            hsv.y = mix(hsv.y, target_sat, m);
        }
        col = hsv_to_rgb(hsv);
    }
    
    if (brightness != 1.0) {
        float m = brightness_spatial_enable ? get_spatial_mask(brightness_spatial_mask, uv, brightness_spatial_scroll_speed, brightness_spatial_rotation, brightness_spatial_invert) : 1.0;
        col = mix(col, col * brightness, m);
    }
    
    if (contrast != 1.0) {
        vec3 target_col = (col - 0.5) * contrast + 0.5;
        float m = contrast_spatial_enable ? get_spatial_mask(contrast_spatial_mask, uv, contrast_spatial_scroll_speed, contrast_spatial_rotation, contrast_spatial_invert) : 1.0;
        col = mix(col, target_col, m);
    }
    
    if (exposure != 0.0) {
        float m = exposure_spatial_enable ? get_spatial_mask(exposure_spatial_mask, uv, exposure_spatial_scroll_speed, exposure_spatial_rotation, exposure_spatial_invert) : 1.0;
        col *= mix(1.0, exp2(exposure), m);
    }
    
    if (color_temp != 0.0) {
        vec3 temp_col = mix(vec3(0.2, 0.6, 1.0), vec3(1.0, 0.6, 0.2), step(0.0, color_temp));
        vec3 target_col = mix(col, col * temp_col, abs(color_temp));
        float m = color_temp_spatial_enable ? get_spatial_mask(color_temp_spatial_mask, uv, color_temp_spatial_scroll_speed, color_temp_spatial_rotation, color_temp_spatial_invert) : 1.0;
        col = mix(col, target_col, m);
    }
    
    return col;
}

vec3 get_blurred_screen(vec2 uv, float mipmap_blur, float blur_mask_val) {
    float r_int = use_radial_blur ? (radial_blur_intensity * blur_mask_val) : 0.0;
    float d_int = use_directional_blur ? (dir_blur_intensity * blur_mask_val) : 0.0;
    
    if (r_int > 0.0 || d_int > 0.0) {
        vec3 col = vec3(0.0);
        float d_angle = radians(dir_blur_angle);
        vec2 d_vec = vec2(cos(d_angle), sin(d_angle)) * d_int;
        vec2 r_offset = (uv - radial_blur_center) * r_int;
        
        float jitter = 0.0;
        float actual_mip = mipmap_blur;
        
        if (use_blur_smoothing) {
            jitter = hash(uv) * blur_smoothing_intensity;
            if (blur_smoothing_mode == 1) actual_mip += 1.5; 
        }
        
        float inv_samples = 1.0 / float(blur_samples);
        for (int i = 0; i < blur_samples; i++) {
            float f_i = (float(i) + jitter) * inv_samples;
            vec2 suv = uv + (r_offset * f_i) + (d_vec * (f_i - 0.5));
            col += textureLod(screen_texture, suv, actual_mip).rgb;
        }
        return col * inv_samples;
    }
    return textureLod(screen_texture, uv, mipmap_blur).rgb;
}

vec3 get_base_color(vec2 uv, float blur_mask_val, float actual_blur) {
    vec3 col = get_blurred_screen(uv, actual_blur, blur_mask_val);
    if (use_gradient_map && grad_before_tonemapping) col = apply_gradient_map(col, uv);
    col = apply_tonemapping(col, uv);
    if (use_gradient_map && !grad_before_tonemapping) col = apply_gradient_map(col, uv);
    return col;
}

vec3 apply_overlays(vec3 col, vec2 uv, vec2 tex_size) {
    if (posterization_steps > 0.0) col = floor(col * posterization_steps) / posterization_steps;

    float current_lum = dot(col, LUM_COEFF);

    if (use_halftone) {
        float rot = radians(halftone_angle);
        vec2 sincos = vec2(sin(rot), cos(rot));
        mat2 rm = mat2(vec2(sincos.y, -sincos.x), vec2(sincos.x, sincos.y));
        
        vec2 grid_uv = fract(rm * (uv * (tex_size / halftone_size)));
        float dist = length(grid_uv - 0.5); 
        float radius = (1.0 - current_lum) * 0.707; 
        float circle = smoothstep(radius - halftone_smoothness, radius + halftone_smoothness, dist);
        
        vec3 half_col = mix(halftone_dot_color, halftone_bg_color, circle);
        col = mix(col, half_col, halftone_opacity);
        current_lum = dot(col, LUM_COEFF); 
    } 
    
    if (use_dithering) {
        vec2 dith_pos = uv * (tex_size / dither_size);
        int bx = int(dith_pos.x) % 4; 
        int by = int(dith_pos.y) % 4;
        float threshold = BAYER_MATRIX[bx][by];
        
        vec3 dithered = mix(dither_color_1, dither_color_2, step(threshold, current_lum));
        col = mix(col, dithered, dither_opacity);
    }

    if (use_vignette) {
        vec2 centered_uv = uv - 0.5;
        float dist_sq = dot(centered_uv, centered_uv) * vignette_scale;
        
        vec3 vig_color = texture(vignette_gradient, vec2(clamp(dist_sq, 0.0, 1.0), 0.0)).rgb;
        float vig_alpha = texture(vignette_opacity_mask, vec2(clamp(dist_sq, 0.0, 1.0), 0.0)).r * vignette_master_opacity; 
        
        vec3 blended = apply_blend_mode(col, vig_color, vignette_blend_mode);
        col = mix(col, blended, vig_alpha);
    }

    if (use_lens_dirt && lens_dirt_intensity > 0.0) {
        current_lum = dot(col, LUM_COEFF);
        vec3 dirt = texture(lens_dirt_texture, uv).rgb;
        col += dirt * smoothstep(lens_dirt_threshold, 1.0, current_lum) * lens_dirt_intensity;
    }

    if (use_film_grain && film_grain_intensity > 0.0) {
        vec2 grain_uv = uv * (tex_size / (film_grain_size * 10.0));
        float t = floor(TIME * film_grain_speed);
        
        float n_r = hash(grain_uv + vec2(t, t * 0.7));
        vec3 grain = vec3(n_r);
        
        if (film_grain_colored) {
            grain.g = hash(grain_uv + vec2(t + 1.5, t * 1.3));
            grain.b = hash(grain_uv + vec2(t + 2.7, t * 0.4));
        }
        col += (grain - 0.5) * film_grain_intensity * 0.4;
    }

    if (invert_colors && !invert_before_grading) col = 1.0 - col;

    switch (color_blindness_mode) {
        case 1: col = vec3(dot(col, vec3(0.56667, 0.43333, 0.0)), dot(col, vec3(0.55833, 0.44167, 0.0)), dot(col, vec3(0.0, 0.24167, 0.75833))); break;
        case 2: col = vec3(dot(col, vec3(0.625, 0.375, 0.0)), dot(col, vec3(0.7, 0.3, 0.0)), dot(col, vec3(0.0, 0.3, 0.7))); break;
        case 3: col = vec3(dot(col, vec3(0.95, 0.05, 0.0)), dot(col, vec3(0.0, 0.43333, 0.56667)), dot(col, vec3(0.0, 0.475, 0.525))); break;
    }

    return col;
}

// ==========================================
// MAIN FRAGMENT ROOT
// ==========================================
void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 tex_size = vec2(textureSize(screen_texture, 0));
    
    float blur_mask_val = get_spatial_mask(blur_mask, uv, blur_mask_scroll_speed, blur_mask_rotation, blur_mask_invert);
    float actual_blur = use_gaussian_blur ? (gaussian_blur_intensity * blur_mask_val) : 0.0;
    
    vec3 base_col = get_base_color(uv, blur_mask_val, actual_blur);
    vec3 col = base_col;

    if (use_chromatic_aberration) {
        float ca_m = get_spatial_mask(ca_mask, uv, ca_mask_scroll_speed, ca_mask_rotation, ca_mask_invert);
        vec2 ca_offset = vec2(0.0);
        float ca_rad = radians(ca_angle);
        vec2 sincos = vec2(sin(ca_rad), cos(ca_rad));
        
        switch (ca_type) {
            case 0: ca_offset = vec2(sincos.y, sincos.x) * chromatic_aberration * ca_m; break;
            case 1: ca_offset = (uv - ca_center) * chromatic_aberration * ca_m; break;
            case 2: ca_offset = reflect(uv - ca_center, vec2(sincos.y, sincos.x)) * chromatic_aberration * ca_m; break;
        }
        
        vec3 c1 = get_base_color(uv + ca_offset, blur_mask_val, actual_blur);
        vec3 c2 = get_base_color(uv - ca_offset, blur_mask_val, actual_blur);
        
        if (use_5tap_ca) {
            vec3 c1_half = get_base_color(uv + ca_offset * 0.5, blur_mask_val, actual_blur);
            vec3 c2_half = get_base_color(uv - ca_offset * 0.5, blur_mask_val, actual_blur);
            col = (c1 * ca_color_1) + (c1_half * ca_color_inter_1) + (base_col * ca_color_2) + (c2_half * ca_color_inter_2) + (c2 * ca_color_3);
        } else {
            col = (c1 * ca_color_1) + (base_col * ca_color_2) + (c2 * ca_color_3);
        }
    }

    COLOR = vec4(clamp(apply_overlays(col, uv, tex_size), 0.0, 1.0), 1.0);
}