shader_type canvas_item;

// Mandatory UI dimensioning parameters
uniform vec2 original_texture_size = vec2(64.0, 64.0); 

// CanvasGroup works natively by feeding the merged children into the screen texture channel
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// ==========================================
// OUTDER GLOW SETTINGS
// ==========================================
group_uniforms Outer_Glow;
uniform bool smooth_poisson_distribution = false;
uniform int max_sampling_limit : hint_range(0, 3) = 0;
uniform vec4 glow_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float glow_size : hint_range(0.0, 500.0) = 20.0;
uniform float glow_intensity : hint_range(0.0, 1.0) = 1.0; 
uniform float glow_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float glow_softness : hint_range(0.0, 1.0) = 0.5;
uniform float glow_smooth_gamma : hint_range(0.5, 3.0) = 1.0;
uniform int glow_blend_mode : hint_range(0, 4) = 0; 
uniform bool use_gradient_mapping = false;
uniform sampler2D glow_gradient : hint_default_black;
uniform float gradient_scroll_speed : hint_range(-5.0, 5.0) = 0.0;
uniform bool mask_core_texture = false; 
uniform float boundary_fade_margin : hint_range(0.0, 0.5) = 0.05; 
uniform bool use_soft_clip = false; 
uniform float glow_hdr_threshold : hint_range(1.0, 10.0) = 1.0;
uniform vec2 glow_direction_falloff = vec2(1.0, 1.0);

group_uniforms Outer_Glow.Rim_Lighting;
uniform float glow_rim_margin : hint_range(0.0, 1.0) = 0.0;
uniform float glow_rim_feather : hint_range(0.01, 1.0) = 0.05;
uniform float glow_rim_eccentricity : hint_range(-1.0, 1.0) = 0.0;
uniform float glow_rim_pulse_frequency : hint_range(0.0, 10.0) = 0.0;

group_uniforms Outer_Glow.Steps_and_Styling;
uniform bool use_sharp_steps = false;
uniform float glow_step_count : hint_range(1.0, 10.0) = 3.0;
uniform bool use_color_banding_palette = false;
uniform sampler2D step_color_banding_palette : hint_default_black, repeat_disable, filter_nearest;
uniform float step_outline_thickness : hint_range(0.0, 10.0) = 0.0;
uniform vec4 step_outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

group_uniforms Outer_Glow.Contour_Outline;
uniform bool use_contour_outline = false;
uniform vec4 contour_color_a : source_color = vec4(1.0, 0.85, 0.0, 1.0); 
uniform vec4 contour_color_b : source_color = vec4(1.0, 0.4, 0.0, 1.0);  
uniform float contour_thickness : hint_range(0.0, 30.0) = 2.0;
uniform bool contour_mix_with_glow = false;
uniform bool contour_pixel_snap = false;

group_uniforms Outer_Glow.Size_Animation;
uniform bool animate_glow = false;
uniform float pulse_speed : hint_range(0.0, 10.0) = 2.0;
uniform float min_pulse_scale : hint_range(0.0, 2.0) = 0.5;
uniform float max_pulse_scale : hint_range(0.0, 5.0) = 1.0;

group_uniforms Outer_Glow.Color_Animation;
uniform bool change_color_over_time = false;
uniform vec4 starting_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 ending_color : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform bool sync_color_with_pulse_speed = true;
uniform float color_change_speed : hint_range(0.0, 10.0) = 2.0;
uniform bool color_animation_ping_pong = false;
uniform bool animate_glow_opacity = false;
uniform float opacity_pulse_speed : hint_range(0.0, 10.0) = 2.0;
uniform float min_opacity_scale : hint_range(0.0, 1.0) = 0.2;
uniform float max_opacity_scale : hint_range(0.0, 1.0) = 1.0;

group_uniforms Outer_Glow.Rotation;
uniform float static_angle : hint_range(0.0, 360.0) = 0.0;
uniform bool animate_rotation = false;
uniform float rotation_speed : hint_range(-10.0, 10.0) = 1.0;
uniform vec2 rotation_pivot_offset = vec2(0.0, 0.0);

group_uniforms Outer_Glow.Pattern_Settings;
uniform bool use_pattern_texture = false;
uniform sampler2D pattern_texture : hint_default_white, repeat_enable;
uniform vec2 pattern_scale = vec2(1.0, 1.0);
uniform vec2 pattern_pan_speed = vec2(0.1, 0.0);
uniform float pattern_influence : hint_range(0.0, 1.0) = 0.5;
uniform bool pattern_fresnel_modulation = false;

group_uniforms Outer_Glow.God_Rays;
uniform bool use_god_rays = false;
uniform vec2 ray_direction = vec2(0.5, -0.5); 
uniform float ray_length : hint_range(1.0, 5.0) = 2.0; 

// ==========================================
// INNER GLOW SETTINGS
// ==========================================
group_uniforms Inner_Glow;
uniform bool use_inner_glow = false;
uniform vec4 inner_glow_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float inner_glow_size : hint_range(0.0, 50.0) = 5.0;
uniform float inner_glow_opacity : hint_range(0.0, 1.0) = 0.5;
uniform float inner_glow_falloff : hint_range(0.1, 5.0) = 1.0;
uniform bool inner_glow_ignore_distortion = false;

group_uniforms Inner_Glow.Size_Animation;
uniform bool animate_inner_glow = false;
uniform float inner_pulse_speed : hint_range(0.0, 10.0) = 2.0;
uniform float min_inner_pulse_scale : hint_range(0.0, 2.0) = 0.5;
uniform float max_inner_pulse_scale : hint_range(0.0, 5.0) = 1.0;

group_uniforms Inner_Glow.Color_Animation;
uniform bool change_inner_color_over_time = false;
uniform vec4 starting_inner_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 ending_inner_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform bool sync_inner_color_with_pulse = true;
uniform float inner_color_change_speed : hint_range(0.0, 10.0) = 2.0;
uniform bool animate_inner_glow_opacity = false;
uniform float inner_opacity_pulse_speed : hint_range(0.0, 10.0) = 2.0;
uniform float min_inner_opacity_scale : hint_range(0.0, 1.0) = 0.2;
uniform float max_inner_opacity_scale : hint_range(0.0, 1.0) = 1.0;

group_uniforms Inner_Glow.Rotation;
uniform float inner_static_angle : hint_range(0.0, 360.0) = 0.0;
uniform bool animate_inner_rotation = false;
uniform float inner_rotation_speed : hint_range(-10.0, 10.0) = 1.0;

group_uniforms Inner_Glow.Pattern_Settings;
uniform bool use_inner_pattern_texture = false;
uniform sampler2D inner_pattern_texture : hint_default_white, repeat_enable;
uniform vec2 inner_pattern_scale = vec2(1.0, 1.0);
uniform vec2 inner_pattern_pan_speed = vec2(0.1, 0.0);
uniform float inner_pattern_influence : hint_range(0.0, 1.0) = 0.5;

// ==========================================
// DISSOLVE & NOISE
// ==========================================
group_uniforms Dissolve_Effect;
uniform bool use_dissolve = false;
uniform sampler2D dissolve_noise : hint_default_black, repeat_enable;
uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec2 d_noise_scale = vec2(1.0, 1.0);
uniform bool mask_dissolve = false;
uniform bool animate_dissolve = false;
uniform float dissolve_speed : hint_range(0.0, 10.0) = 2.0;
uniform bool dissolve_use_ease = false;

// ==========================================
// RETRO & PIXELATION EFFECTS
// ==========================================
group_uniforms Retro_Effects;
uniform bool enable_dithering = true;
uniform float dither_strength_noise : hint_range(0.0, 0.2) = 0.03;

group_uniforms Retro_Effects.Bayer_Dither;
uniform bool use_ordered_dither = false;
uniform float dither_strength : hint_range(0.0, 1.0) = 0.5;
uniform float dither_scale : hint_range(1.0, 8.0) = 1.0;
uniform float dither_bit_depth : hint_range(2.0, 64.0) = 64.0;
uniform bool dither_animate = false;
uniform bool dither_use_luminance = false;
uniform float dither_threshold_bias : hint_range(-0.5, 0.5) = 0.0;
uniform float dither_color_bleeding : hint_range(0.0, 1.0) = 0.0;
uniform float dither_animation_speed : hint_range(1.0, 60.0) = 12.0;
uniform vec4 dither_noise_bleeding_tint : source_color = vec4(1.0, 0.0, 0.0, 1.0);

group_uniforms Retro_Effects.Pixelation;
uniform bool use_pixelate_glow = false;
uniform float pixelate_size : hint_range(1.0, 32.0) = 4.0;
uniform bool pixelate_heat_fluid_fluid = false;  
uniform bool pixelate_heat_fluid_static = false; 

// ==========================================
// DISTORTION & HEAT
// ==========================================
group_uniforms Distortion_and_Heat;
uniform bool use_distortion = false;
uniform sampler2D distortion_noise : hint_default_black, repeat_enable;
uniform float distortion_strength : hint_range(0.0, 0.1) = 0.02;
uniform vec2 distortion_speed = vec2(0.0, -0.2); 
uniform bool distort_texture_as_well = false; 
uniform bool heat_asymmetric_rise = false;
uniform float heat_top_heavy_factor : hint_range(1.0, 5.0) = 2.5;
uniform bool use_convection_fluid = false;
uniform float convection_vortex_twist : hint_range(-5.0, 5.0) = 1.0;
uniform float convection_bubble_frequency : hint_range(1.0, 10.0) = 2.0;
uniform float convection_speed : hint_range(0.1, 5.0) = 1.0;
uniform float convection_wave_amplitude : hint_range(0.1, 3.0) = 1.0;
uniform float distortion_chromatic_aberration : hint_range(0.0, 50.0) = 0.0;
uniform float heat_wind_shear : hint_range(-1.0, 1.0) = 0.0;
uniform float heat_distance_fade : hint_range(0.0, 1.0) = 0.0;
uniform bool distortion_multi_frequency = false;

group_uniforms Distortion_and_Heat.Procedural_Noise_Generator;
uniform vec2 procedural_noise_scale = vec2(10.0, 10.0);
uniform float procedural_noise_speed = 2.0;
uniform vec2 procedural_noise_direction = vec2(0.0, -1.0);
uniform int procedural_noise_octaves : hint_range(1, 4) = 2;

group_uniforms Distortion_and_Heat.Plasma_Caustics;
uniform bool heat_plasma_caustics = false;
uniform float caustics_sharpness : hint_range(0.1, 5.0) = 1.0;
uniform float caustics_contrast : hint_range(1.0, 5.0) = 2.0;
uniform float caustics_frequency : hint_range(1.0, 5.0) = 1.0;

group_uniforms Distortion_and_Heat.Chiseled_Ridge;
uniform bool heat_chiseled_ridge = false;
uniform float ridge_frequency_scale : hint_range(1.0, 10.0) = 3.0;
uniform float ridge_sharpness_steps : hint_range(2.0, 16.0) = 4.0;

group_uniforms Distortion_and_Heat.Convective_Turbulence;
uniform bool heat_convective_turbulence = false;
uniform float turbulence_blend_ratio : hint_range(0.0, 1.0) = 0.4;
uniform vec2 turbulence_scroll_speed = vec2(-0.1, 0.1);

group_uniforms Distortion_and_Heat.Digital_Glitch;
uniform bool heat_digital_glitch = false;
uniform float glitch_frequency_lanes : hint_range(5.0, 100.0) = 30.0;
uniform float glitch_update_speed : hint_range(1.0, 60.0) = 8.0;
uniform float glitch_displacement_force : hint_range(0.0, 2.0) = 0.35;

// === VARYINGS FOR PRE-CALCULATED MATH ===
varying float v_current_size;
varying float v_current_inner_size;
varying vec4 v_active_glow_color;
varying vec4 v_active_inner_glow_color;
varying float v_cos_a;
varying float v_sin_a;
varying float v_inner_cos_a;
varying float v_inner_sin_a;
varying vec2 v_dither_anim_offset;
varying float v_dissolve_value;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void vertex() {
    v_current_size = glow_size * mix(1.0, mix(min_pulse_scale, max_pulse_scale, (sin(TIME * pulse_speed) + 1.0) * 0.5), float(animate_glow));
    v_current_inner_size = inner_glow_size * mix(1.0, mix(min_inner_pulse_scale, max_inner_pulse_scale, (sin(TIME * inner_pulse_speed) + 1.0) * 0.5), float(animate_inner_glow));

    float speed_factor = sync_color_with_pulse_speed ? pulse_speed : color_change_speed;
    v_active_glow_color = change_color_over_time ? mix(starting_color, ending_color, mix((sin(TIME * speed_factor) + 1.0) * 0.5, abs(fract(TIME * speed_factor * 0.5) * 2.0 - 1.0), float(color_animation_ping_pong))) : glow_color;

    float inner_speed = sync_inner_color_with_pulse ? inner_pulse_speed : inner_color_change_speed;
    v_active_inner_glow_color = change_inner_color_over_time ? mix(starting_inner_color, ending_inner_color, (sin(TIME * inner_speed) + 1.0) * 0.5) : inner_glow_color;

    v_cos_a = cos(radians(static_angle) + (animate_rotation ? TIME * rotation_speed : 0.0));
    v_sin_a = sin(radians(static_angle) + (animate_rotation ? TIME * rotation_speed : 0.0));
    v_inner_cos_a = cos(radians(inner_static_angle) + (animate_inner_rotation ? TIME * inner_rotation_speed : 0.0));
    v_inner_sin_a = sin(radians(inner_static_angle) + (animate_inner_rotation ? TIME * inner_rotation_speed : 0.0));

    v_dither_anim_offset = dither_animate ? floor(vec2(rand(vec2(floor(TIME * dither_animation_speed), 0.0)), rand(vec2(0.0, floor(TIME * dither_animation_speed)))) * 4.0) : vec2(0.0);
    v_dissolve_value = animate_dissolve ? mix(dissolve_amount, mix((sin(TIME * dissolve_speed) + 1.0) * 0.5, smoothstep(0.0, 1.0, (sin(TIME * dissolve_speed) + 1.0) * 0.5), float(dissolve_use_ease)), 1.0) : dissolve_amount;
}

float interleaved_gradient_noise(vec2 screen_coord) {
    vec3 magic = vec3(0.0605, 0.0073, 52.9829189);
    return fract(magic.z * fract(dot(screen_coord, magic.xy)));
}

vec2 rotate_vector(vec2 dir, float cos_angle, float sin_angle) {
    return vec2(dir.x * cos_angle - dir.y * sin_angle, dir.x * sin_angle + dir.y * cos_angle);
}

float get_bayer_matrix(vec2 coord) {
    int index = int(mod(coord.x, 4.0)) + int(mod(coord.y, 4.0)) * 4;
    const float BAYER[16] = float[16](
        0.0, 0.5, 0.125, 0.625,
        0.75, 0.25, 0.875, 0.375,
        0.1875, 0.6875, 0.0625, 0.5625,
        0.9375, 0.4375, 0.8125, 0.3125
    );
    return BAYER[index];
}

vec4 apply_blend_mode(vec4 glow, vec3 bg, int mode) {
    vec4 result = glow;
    if (mode == 1) result = vec4(glow.rgb * glow.a, glow.a);
    else if (mode == 2) result = vec4(mix(bg, bg * glow.rgb, glow.a), glow.a);
    else if (mode == 3) result = vec4(mix(bg, 1.0 - (1.0 - bg) * (1.0 - glow.rgb), glow.a), glow.a);
    else if (mode == 4) {
        vec3 mode4_mix = mix(2.0 * bg * glow.rgb, 1.0 - 2.0 * (1.0 - bg) * (1.0 - glow.rgb), step(0.5, bg));
        result = vec4(mix(bg, mode4_mix, glow.a), glow.a);
    }
    return result;
}

vec2 generate_procedural_gabor_waves(vec2 coord, float time) {
    vec2 p = coord * procedural_noise_scale;
    vec2 move = procedural_noise_direction * time * procedural_noise_speed;
    float w1 = sin(p.x + move.x) * cos(p.y + move.y);
    float w2 = cos(p.x - move.y) * sin(p.y + move.x);
    vec2 accum = vec2(w1, w2) * 0.5 + 0.5;
    float amplitude = 0.5;
    float frequency = 2.15;
    for (int i = 1; i < 4; i++) {
        if (i >= procedural_noise_octaves) break;
        vec2 p_oct = p * frequency;
        vec2 m_oct = move * (frequency * 0.7);
        float o1 = sin(p_oct.x + m_oct.x) * cos(p_oct.y + m_oct.y);
        float o2 = cos(p_oct.x - m_oct.y) * sin(p_oct.y + m_oct.x);
        accum += vec2(o1, o2) * (amplitude * 0.5);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return clamp(accum, 0.0, 1.0);
}

void fragment() {
    vec2 screen_pixel_to_uv = SCREEN_PIXEL_SIZE;
    vec2 tex_uv = SCREEN_UV;
    
    vec2 continuous_glow_uv = SCREEN_UV;
    
    if (use_distortion || heat_plasma_caustics || heat_chiseled_ridge || heat_convective_turbulence || heat_digital_glitch) {
        vec2 pixelate_grid = original_texture_size / max(pixelate_size, 1.0);
        vec2 noise_base_uv = mix(UV, floor(UV * pixelate_grid) / pixelate_grid, float(use_pixelate_glow && pixelate_size > 0.0 && !pixelate_heat_fluid_fluid));
        vec2 noise_coord = noise_base_uv + vec2(noise_base_uv.y * heat_wind_shear, 0.0);
        
        if (use_convection_fluid) {
            vec2 radial_vec = noise_coord - 0.5;
            noise_coord = vec2(length(radial_vec) * convection_bubble_frequency - TIME * 0.1 * convection_speed, (atan(radial_vec.y, radial_vec.x) + length(radial_vec) * convection_vortex_twist) / 6.28318);
        }
        vec2 base_time_offset = TIME * distortion_speed;
        vec2 noise_offset = vec2(0.5);
        
        if (use_distortion) {
            noise_offset = texture(distortion_noise, noise_coord + base_time_offset).rg;
            if (distortion_multi_frequency) {
                vec2 noise_octave = texture(distortion_noise, (noise_coord * 2.15) + (base_time_offset * 1.55)).rg;
                noise_offset = mix(noise_offset, noise_offset + (noise_octave * 0.45) - 0.225, 0.5);
            }
        } else {
            noise_offset = generate_procedural_gabor_waves(noise_coord, TIME);
        }
        if (heat_plasma_caustics) {
            noise_offset = clamp(noise_offset * caustics_frequency, 0.0, 1.0);
            noise_offset = 1.0 - pow(abs(noise_offset * 2.0 - 1.0), vec2(caustics_sharpness));
            noise_offset = clamp(pow(noise_offset, vec2(caustics_contrast)), 0.0, 1.0);
        }
        if (heat_chiseled_ridge) {
            noise_offset = abs(fract(noise_offset * ridge_frequency_scale) - 0.5) * 2.0;
            noise_offset = floor(noise_offset * ridge_sharpness_steps) / ridge_sharpness_steps;
        }
        if (heat_convective_turbulence) {
            vec2 secondary_wave = use_distortion ? texture(distortion_noise, noise_coord.yx + (TIME * turbulence_scroll_speed)).rg : generate_procedural_gabor_waves(noise_coord.yx, TIME * 0.7);
            noise_offset = mix(noise_offset, secondary_wave, turbulence_blend_ratio);
        }
        noise_offset = noise_offset * 2.0 - 1.0;
        
        vec2 glitch_offset_vector = vec2(0.0);
        if (heat_digital_glitch) {
            float slice = sign(sin(noise_coord.y * glitch_frequency_lanes + floor(TIME * glitch_update_speed)));
            glitch_offset_vector.x = slice * glitch_displacement_force;
        }
        
        float weight = mix(1.0, pow(1.0 - noise_base_uv.y, heat_top_heavy_factor), float(heat_asymmetric_rise));
        vec2 delta_center = UV - 0.5;
        weight *= mix(1.0, smoothstep(0.25, 0.01, delta_center.x * delta_center.x + delta_center.y * delta_center.y), heat_distance_fade);
        
        float final_strength = use_distortion ? distortion_strength : 0.02;
        vec2 fluid_offset = noise_offset * final_strength * weight * mix(1.0, convection_wave_amplitude, float(use_convection_fluid));
        vec2 total_displacement = (fluid_offset + glitch_offset_vector) * screen_pixel_to_uv * original_texture_size;
        
        if (use_pixelate_glow && pixelate_heat_fluid_static) {
            total_displacement = floor(total_displacement * pixelate_grid) / pixelate_grid;
        }
        continuous_glow_uv += total_displacement;
        if (distort_texture_as_well) tex_uv += total_displacement;
    }

    vec2 active_fragcoord = continuous_glow_uv / screen_pixel_to_uv;
    vec2 glow_uv = continuous_glow_uv;

    if (use_pixelate_glow && pixelate_size > 0.0) {
        active_fragcoord = floor(active_fragcoord / pixelate_size) * pixelate_size + (pixelate_size * 0.5);
        glow_uv = active_fragcoord * screen_pixel_to_uv;
    }
    
    vec4 col = texture(screen_texture, tex_uv);
    vec4 active_glow_color = use_gradient_mapping ? texture(glow_gradient, vec2(fract(TIME * gradient_scroll_speed), 0.0)) : v_active_glow_color;

    float total_alpha = 0.0;
    float inner_alpha = 0.0;
    float contour_alpha = 0.0;
    float rim_cut_alpha = 0.0;
    
    float sample_limit = 32.0;
    if (max_sampling_limit == 0) sample_limit = (v_current_size > 150.0) ? 96.0 : ((v_current_size > 50.0) ? 64.0 : 32.0);
    else if (max_sampling_limit == 1) sample_limit = 32.0;
    else if (max_sampling_limit == 2) sample_limit = 64.0;
    else if (max_sampling_limit == 3) sample_limit = 96.0;
    
    float inv_sample_limit = 1.0 / sample_limit;
    float dither = enable_dithering ? interleaved_gradient_noise(active_fragcoord) * dither_strength_noise : 0.0;

    if (v_current_size > 0.0 || use_contour_outline) {
        vec2 norm_ray_dir = normalize(ray_direction);
        float c_gold = 0.73010729;
        float s_gold = 0.68333215;
        vec2 direction = vec2(1.0, 0.0);
        
        vec2 cached_contour_step = mix(contour_thickness, floor(contour_thickness), float(contour_pixel_snap)) * screen_pixel_to_uv;
        vec2 cached_glow_step = v_current_size * screen_pixel_to_uv;
        float dynamic_rim_radius = clamp(glow_rim_margin + mix(0.0, sin(TIME * glow_rim_pulse_frequency) * 0.05, float(glow_rim_pulse_frequency > 0.001)), 0.0, 1.0);
        float total_rim_samples = sample_limit * dynamic_rim_radius;
        float inv_glow_softness = 1.0 / (1.0 - glow_softness * 0.9);
        
        float jitter_angle = smooth_poisson_distribution ? rand(active_fragcoord) * 6.2831853 : 0.0;
        float cos_j = cos(jitter_angle);
        float sin_j = sin(jitter_angle);
        
        float half_gamma = glow_smooth_gamma * 0.5;
        vec2 cached_god_ray_mod = ray_direction * (float(use_god_rays) * (ray_length - 1.0));
        float scaled_eccentricity = glow_rim_eccentricity * 0.1;
        
        for (float i = 0.0; i < sample_limit; i++) {
            float radius_factor = clamp(pow((i + 0.5) * inv_sample_limit, half_gamma) + dither, 0.0, 1.0);
            vec2 sampled_dir = direction + cached_god_ray_mod * max(0.0, dot(direction, norm_ray_dir));
            
            sampled_dir = vec2(sampled_dir.x * cos_j - sampled_dir.y * sin_j, sampled_dir.x * sin_j + sampled_dir.y * cos_j);
            vec2 rotated_dir = rotate_vector((sampled_dir + rotation_pivot_offset) * glow_direction_falloff, v_cos_a, v_sin_a);
            
            if (use_contour_outline) contour_alpha += texture(screen_texture, glow_uv + (rotated_dir * cached_contour_step)).a;
            
            float sample_a = texture(screen_texture, glow_uv + (rotated_dir * cached_glow_step * radius_factor)).a;
            
            float linear_falloff = 1.0 - radius_factor * glow_softness;
            float falloff = mix(linear_falloff, linear_falloff * (1.0 / (1.0 + radius_factor * radius_factor * 10.0 * glow_softness)), float(use_soft_clip));
            total_alpha += sample_a * falloff;
            
            float adjusted_rim_bound = max(0.0, dynamic_rim_radius + (rotated_dir.y * scaled_eccentricity));
            if (radius_factor < adjusted_rim_bound) {
                rim_cut_alpha += sample_a * (1.0 - smoothstep(adjusted_rim_bound - glow_rim_feather, adjusted_rim_bound, radius_factor));
            }
            direction = vec2(direction.x * c_gold - direction.y * s_gold, direction.x * s_gold + direction.y * c_gold);
        }
        
        total_alpha = min(1.0, (total_alpha * inv_sample_limit) * inv_glow_softness);
        total_alpha = clamp(total_alpha - (rim_cut_alpha / max(1.0, total_rim_samples)), 0.0, 1.0);
        
        if (use_sharp_steps && total_alpha > 0.001) total_alpha = ceil(total_alpha * glow_step_count) / glow_step_count;
        contour_alpha = clamp(contour_alpha, 0.0, 1.0);
        total_alpha *= float(v_current_size > 0.0);
    }

    if (use_inner_glow && col.a > 0.05 && v_current_inner_size > 0.0) {
        float inner_accum = 0.0;
        vec2 targeted_inner_uv = mix(glow_uv, tex_uv, float(inner_glow_ignore_distortion));
        float internal_jitter = smooth_poisson_distribution ? rand(active_fragcoord + vec2(0.125)) * 0.5 : 0.0;
        
        vec2 inner_dir = vec2(v_inner_cos_a, v_inner_sin_a);
        vec2 inner_step_base = screen_pixel_to_uv * v_current_inner_size * (1.0 + dither + internal_jitter);
        
        float c_30 = 0.86602540378; 
        float s_30 = 0.5;           
        
        for (float i = 0.0; i < 12.0; i++) {
            inner_accum += texture(screen_texture, targeted_inner_uv + (inner_dir * inner_step_base)).a;
            inner_dir = vec2(inner_dir.x * c_30 - inner_dir.y * s_30, inner_dir.x * s_30 + inner_dir.y * c_30);
        }
        
        float calculated_inner_opacity = inner_glow_opacity;
        if (animate_inner_glow_opacity) calculated_inner_opacity *= mix(min_inner_opacity_scale, max_inner_opacity_scale, (sin(TIME * inner_opacity_pulse_speed) + 1.0) * 0.5);
        inner_alpha = pow((1.0 - (inner_accum * 0.0833333)), inner_glow_falloff) * calculated_inner_opacity * v_active_inner_glow_color.a;
    }

    if (boundary_fade_margin > 0.0) {
        vec2 fade = smoothstep(vec2(0.0), vec2(boundary_fade_margin), UV) * smoothstep(vec2(0.0), vec2(boundary_fade_margin), 1.0 - UV);
        total_alpha *= fade.x * fade.y;
        inner_alpha *= fade.x * fade.y;
    }

    float dissolve_tex = texture(dissolve_noise, UV * d_noise_scale).r;
    float dissolve_mask = mix(1.0, step(v_dissolve_value, dissolve_tex), float(use_dissolve));
    float pattern_weight = texture(pattern_texture, UV * pattern_scale + (TIME * pattern_pan_speed)).r;
    
    if (use_pattern_texture && pattern_fresnel_modulation) {
        pattern_weight = mix(pattern_weight, pattern_weight * (1.0 - smoothstep(0.0, 0.85, total_alpha)), 0.75);
    }
    
    float calculated_glow_opacity = glow_opacity;
    if (animate_glow_opacity) calculated_glow_opacity *= mix(min_opacity_scale, max_opacity_scale, (sin(TIME * opacity_pulse_speed) + 1.0) * 0.5);
    
    vec4 final_glow = active_glow_color;
    final_glow.a = total_alpha * calculated_glow_opacity * mix(1.0, pattern_weight, pattern_influence);
    final_glow.rgb *= glow_intensity * glow_hdr_threshold;
    
    if (use_sharp_steps && use_color_banding_palette) {
        float sample_coord = clamp(total_alpha, 0.001, 0.999);
        vec4 palette_color = texture(step_color_banding_palette, vec2(sample_coord, 0.0));
        final_glow.rgb = palette_color.rgb;
        final_glow.a *= palette_color.a;
    }
    
    if (use_sharp_steps && step_outline_thickness > 0.001) {
        float step_fraction = fract(total_alpha * glow_step_count);
        float line_width = step_outline_thickness * 0.05;
        if (step_fraction < line_width || step_fraction > (1.0 - line_width)) {
            final_glow.rgb = mix(final_glow.rgb, step_outline_color.rgb, step_outline_color.a);
        }
    }
    
    if (use_ordered_dither) {
        final_glow.rgb = mix(final_glow.rgb, mix(final_glow.rgb, dither_noise_bleeding_tint.rgb, 0.5), dither_color_bleeding * total_alpha);
        if (dither_bit_depth < 64.0) final_glow.rgb = floor(final_glow.rgb * dither_bit_depth) / dither_bit_depth;
    }
    
    if (col.a > 0.05 && !mask_core_texture) {
        if (use_inner_glow) {
            float pattern_mod = mix(1.0, texture(inner_pattern_texture, UV * inner_pattern_scale + (TIME * inner_pattern_pan_speed)).r, inner_pattern_influence);
            col.rgb = mix(col.rgb, v_active_inner_glow_color.rgb, inner_alpha * pattern_mod * dissolve_mask);
        }
        COLOR = col;
    } else if (use_contour_outline && contour_alpha > 0.01 && !mask_core_texture) {
        COLOR = mix(mix(contour_color_a, contour_color_b, UV.y), vec4(final_glow.rgb, mix(contour_color_a, contour_color_b, UV.y).a), float(contour_mix_with_glow));
    } else if (total_alpha > 0.0 && dissolve_mask > 0.0) {
        if (use_ordered_dither) {
            vec2 dither_coord = (FRAGCOORD.xy / dither_scale) + v_dither_anim_offset;
            float inv_damage_flash_weight = 1.0 / dither_strength;
            float dither_target_weight = mix(total_alpha, dot(final_glow.rgb, vec3(0.299, 0.587, 0.114)) * total_alpha, float(dither_use_luminance));
            if (((dither_target_weight * inv_damage_flash_weight) + dither_threshold_bias) < get_bayer_matrix(dither_coord)) discard;
        }
        if (use_distortion && distortion_chromatic_aberration > 0.001) {
            float chrom = distortion_chromatic_aberration * TEXTURE_PIXEL_SIZE.x * total_alpha;
            vec3 ab_r = apply_blend_mode(final_glow, texture(screen_texture, glow_uv + vec2(chrom, 0.0)).rgb, glow_blend_mode).rgb;
            vec3 ab_g = apply_blend_mode(final_glow, texture(screen_texture, glow_uv).rgb, glow_blend_mode).rgb;
            vec3 ab_b = apply_blend_mode(final_glow, texture(screen_texture, glow_uv - vec2(chrom, 0.0)).rgb, glow_blend_mode).rgb;
            COLOR = vec4(ab_r.r, ab_g.g, ab_b.b, final_glow.a);
        } else {
            COLOR = apply_blend_mode(final_glow, texture(screen_texture, glow_uv).rgb, glow_blend_mode);
        }
    } else {
        COLOR = vec4(0.0);
    }
}