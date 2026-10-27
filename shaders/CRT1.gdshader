shader_type canvas_item;

uniform sampler2D tex: filter_linear;

group_uniforms CRT_Geometry;
uniform float curve : hint_range(0.0, 0.5) = 0.0;
uniform float aspect : hint_range(0.5, 1.0) = 0.75;
uniform float bezel_shadow_strength : hint_range(0.0, 1.0) = 0.0;
uniform float bezel_shadow_width : hint_range(0.0, 0.5) = 0.1;

group_uniforms Glass_Reflection;
uniform bool use_glare = false;
uniform float glare_strength : hint_range(0.0, 1.0) = 0.2;
uniform vec2 glare_position = vec2(0.5, 0.5);
uniform float glare_rotation : hint_range(-3.14159, 3.14159) = 0.78539; 
uniform float glare_softness : hint_range(0.01, 2.0) = 0.5;
uniform float glare_size : hint_range(0.01, 2.0) = 0.2;

uniform bool use_glass_reflection = false;
uniform sampler2D glass_env_tex : hint_default_black, filter_linear_mipmap;
uniform float glass_env_strength : hint_range(0.0, 1.0) = 0.5;
uniform vec2 glass_env_offset = vec2(0.0, 0.0);
uniform float glass_env_scale : hint_range(0.1, 10.0) = 1.0;
uniform float glass_blur : hint_range(0.0, 10.0) = 2.0; 
uniform float glass_curve : hint_range(0.0, 0.5) = 0.0;
uniform float glass_brightness : hint_range(0.0, 3.0) = 1.0;
uniform float glass_saturation : hint_range(0.0, 3.0) = 1.0;
uniform vec4 glass_tint : source_color = vec4(1.0);
uniform int glass_blend_mode : hint_enum("Add:0", "Screen:1", "Lighten:2") = 1;

group_uniforms Power_State;
uniform float power_state : hint_range(0.0, 1.0) = 1.0;
uniform int power_close_axis : hint_enum("Vertical:0", "Horizontal:1") = 0;
uniform vec4 power_flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float power_flash_start : hint_range(0.0, 1.0) = 0.8;
uniform float power_flash_end : hint_range(0.0, 1.0) = 0.2;
uniform bool use_hum_bar = false;
uniform float hum_bar_strength : hint_range(0.0, 0.1) = 0.0;
uniform float hum_bar_speed : hint_range(0.0, 10.0) = 2.0;

group_uniforms Profiles;
uniform int crt_profile : hint_enum("Custom:0", "Arcade (Soft/Scanlined):1", "Consumer TV (Blurry/Bleed):2", "PVM (Sharp/Precise):3") = 0;

group_uniforms Mask;
uniform int mask_type : hint_enum(
	"Null:0", "Dots:1", "Aperture Grille:2", "Wide Grille:3", "Wide Soft Grille:4", "Slot Mask:5", "Fake Grouped:6", "Trinitron:7", "LCD Matrix:8", "Staggered Phosphor:9") = 6;
uniform float mask_scale : hint_range(0.1, 10.0, 0.1) = 1.0;
uniform float mask_brightness : hint_range(0.0, 1.0) = 1.0;
uniform bool animate_mask_brightness = false;
uniform sampler2D mask_brightness_curve;
uniform float mask_brightness_anim_speed = 1.0;
uniform float mask_brightness_anim_amplitude = 1.0;

group_uniforms Scanlines;
uniform bool use_scanlines = false;
uniform float scanline_brightness : hint_range(0.5, 1.0) = 1.0;
uniform float scanline_beam_width_min : hint_range(0.1, 1.0) = 0.25;
uniform float scanline_beam_width_max : hint_range(0.5, 3.0) = 1.0;
uniform float scanline_drift_speed : hint_range(-5.0, 5.0) = 0.0;
uniform float scanline_cutoff : hint_range(0.0, 1.0) = 0.0;

group_uniforms Interlaced_Flicker;
uniform float interlaced_strength : hint_range(0.0, 1.0) = 0.0;
uniform bool animate_interlaced = false;
uniform sampler2D interlaced_curve;
uniform float interlaced_anim_speed = 1.0;
uniform float interlaced_anim_amplitude = 1.0;
uniform float interlaced_fps : hint_range(1.0, 60.0) = 30.0;

group_uniforms Interlaced_Jitter;
uniform bool use_interlaced_jitter = false;
uniform float interlaced_jitter_strength : hint_range(0.0, 0.05) = 0.0;
uniform float interlaced_jitter_speed : hint_range(0.1, 20.0) = 10.0;
uniform float interlaced_jitter_frequency : hint_range(0.1, 5.0) = 1.5;
uniform bool interlaced_jitter_random = false;

group_uniforms VHS_Head_Switching;
uniform bool use_head_switching = false;
uniform float head_switch_height : hint_range(0.01, 0.5) = 0.08;
uniform float head_switch_strength : hint_range(-0.1, 0.1) = 0.03;
uniform float head_switch_curve : hint_range(1.0, 5.0) = 1.5;

group_uniforms VHS_Edge_Wobble;
uniform bool use_edge_wobble = false;
uniform float edge_wobble_strength : hint_range(0.0, 0.1) = 0.005;
uniform float edge_wobble_scale : hint_range(0.1, 100.0) = 10.0;
uniform float edge_wobble_speed : hint_range(0.0, 10.0) = 2.0;

group_uniforms VHS_Tracking;
uniform bool use_vhs_tracking = false;
uniform float vhs_tracking_strength : hint_range(0.0, 1.0) = 0.0;
uniform float vhs_tracking_height : hint_range(0.01, 0.5) = 0.08;
uniform float vhs_tracking_speed : hint_range(-10.0, 10.0) = 2.0;
uniform float vhs_tracking_interval : hint_range(0.0, 10.0) = 2.0;
uniform float vhs_tracking_noise_scale : hint_range(1.0, 100.0) = 40.0;

group_uniforms Sharpness;
uniform float sharpness : hint_range(0.5, 1.0) = 0.6666666666666666666666666667;
uniform bool animate_sharpness = false;
uniform sampler2D sharpness_curve;
uniform float sharpness_anim_speed = 1.0;
uniform float sharpness_anim_amplitude = 1.0;

group_uniforms NTSC_Color_Bleed;
uniform bool use_yiq_bleed = false;
uniform float yiq_bleed_spread : hint_range(0.1, 10.0) = 1.0;
uniform float yiq_chroma_offset : hint_range(-5.0, 5.0) = 0.0;

group_uniforms Wobble;
uniform float wobble_strength : hint_range(0.0, 5.0) = 0.0;
uniform bool animate_wobble = false;
uniform sampler2D wobble_curve;
uniform float wobble_anim_speed = 1.0;
uniform float wobble_anim_amplitude = 1.0;

group_uniforms Rolling_Interference;
uniform float roll_strength : hint_range(0.0, 1.0) = 0.03;
uniform bool animate_roll = false;
uniform sampler2D roll_curve;
uniform float roll_anim_speed = 1.0;
uniform float roll_anim_amplitude = 1.0;
uniform float roll_size : hint_range(0.0, 100.0) = 15.0;
uniform float roll_speed : hint_range(-10.0, 10.0) = 2.0;

group_uniforms Sweep_Stripe;
uniform bool use_sweep_stripe = false;
uniform float stripe_width : hint_range(0.01, 1.0) = 0.15;
uniform float stripe_speed : hint_range(-5.0, 5.0) = 0.15;
uniform float stripe_interval : hint_range(0.1, 10.0) = 3.0;
uniform float stripe_offset : hint_range(0.0, 1.0) = 0.0;
uniform float stripe_angle : hint_range(0.0, 6.28318) = 0.0;
uniform int stripe_profile : hint_enum("Smoothstep:0", "Gaussian:1", "Exponential:2", "Cosine:3") = 0;
uniform float stripe_smoothness_lead : hint_range(0.0, 1.0) = 0.3;
uniform float stripe_smoothness_trail : hint_range(0.0, 1.0) = 0.3;

group_uniforms Sweep_Stripe.Hue;
uniform bool stripe_enable_hue = false;
uniform float stripe_hue_shift : hint_range(0.0, 6.28318) = 1.57;
uniform bool stripe_hue_oscillate = false;
uniform int stripe_hue_osc_profile : hint_enum("Sine:0", "Triangle:1", "Square:2", "Sawtooth:3") = 0;
uniform int stripe_hue_osc_axis : hint_enum("Off:0", "Horizontal:1", "Vertical:2") = 0;
uniform float stripe_hue_osc_min : hint_range(0.0, 6.28318) = 0.0;
uniform float stripe_hue_osc_max : hint_range(0.0, 6.28318) = 3.14159;
uniform float stripe_hue_osc_scale : hint_range(0.1, 10.0) = 1.0;
uniform float stripe_hue_osc_freq : hint_range(0.1, 50.0) = 10.0;
uniform float stripe_hue_osc_speed : hint_range(-20.0, 20.0) = 5.0;
uniform float stripe_hue_osc_intensity : hint_range(0.0, 3.0) = 1.0;
uniform float stripe_hue_osc_offset : hint_range(0.0, 1.0) = 0.0;

group_uniforms Sweep_Stripe.Secondary_Hue;
uniform bool stripe_enable_secondary_hue = false;
uniform float stripe_secondary_hue_shift : hint_range(0.0, 6.28318) = 3.14159;
uniform float stripe_secondary_mix : hint_range(0.0, 1.0) = 0.5;
uniform bool stripe_secondary_wave_enabled = false;
uniform int stripe_secondary_wave_profile : hint_enum("Sine:0", "Triangle:1", "Square:2", "Sawtooth:3") = 0;
uniform int stripe_secondary_wave_axis : hint_enum("Horizontal:0", "Vertical:1") = 0;
uniform float stripe_secondary_wave_min : hint_range(0.0, 6.28318) = 0.0;
uniform float stripe_secondary_wave_max : hint_range(0.0, 6.28318) = 3.14159;
uniform float stripe_secondary_wave_scale : hint_range(0.1, 10.0) = 1.0;
uniform float stripe_secondary_wave_freq : hint_range(0.1, 50.0) = 10.0;
uniform float stripe_secondary_wave_speed : hint_range(-20.0, 20.0) = 8.0;
uniform float stripe_secondary_wave_intensity : hint_range(0.0, 3.0) = 1.0;
uniform float stripe_secondary_wave_offset : hint_range(0.0, 1.0) = 0.0;

group_uniforms Sweep_Stripe.Saturation;
uniform bool stripe_enable_saturation = false;
uniform float stripe_saturation : hint_range(0.0, 3.0) = 1.2;

group_uniforms Sweep_Stripe.Brightness;
uniform bool stripe_enable_brightness = false;
uniform float stripe_brightness : hint_range(0.0, 3.0) = 1.1;

group_uniforms Sweep_Stripe.Contrast;
uniform bool stripe_enable_contrast = false;
uniform float stripe_contrast : hint_range(0.0, 3.0) = 1.1;

group_uniforms Multipath_Echo;
uniform bool use_echo = false;
uniform float echo_strength : hint_range(0.0, 1.0) = 0.0;
uniform bool animate_echo_strength = false;
uniform sampler2D echo_strength_curve;
uniform float echo_strength_anim_speed = 1.0;
uniform float echo_strength_anim_interval : hint_range(0.0, 10.0) = 0.0;
uniform float echo_strength_anim_amplitude = 1.0;

uniform float echo_offset : hint_range(-0.05, 0.05) = 0.015;
uniform bool animate_echo_offset = false;
uniform sampler2D echo_offset_curve;
uniform float echo_offset_anim_speed = 1.0;
uniform float echo_offset_anim_interval : hint_range(0.0, 10.0) = 0.0;
uniform float echo_offset_anim_amplitude = 1.0;

group_uniforms Dot_Crawl;
uniform bool use_dot_crawl = false;
uniform float dot_crawl_strength : hint_range(0.0, 1.0) = 0.0;
uniform float dot_crawl_speed : hint_range(0.0, 20.0) = 15.0;

group_uniforms Signal_Loss_Glitch;
uniform float glitch_strength : hint_range(0.0, 1.0) = 0.0;
uniform float vsync_tearing : hint_range(0.0, 1.0) = 0.0;
uniform bool animate_glitch = false;
uniform sampler2D glitch_curve;
uniform float glitch_anim_speed = 1.0;
uniform float glitch_anim_amplitude = 1.0;
uniform float glitch_rate : hint_range(0.0, 1.0) = 0.05;
uniform float glitch_size : hint_range(0.01, 1.0) = 0.05;

group_uniforms Static_Noise;
uniform bool use_noise = false;
uniform float noise_strength : hint_range(0.0, 0.5) = 0.03;
uniform bool chroma_noise = false;
uniform bool animate_noise = false;
uniform sampler2D noise_curve;
uniform float noise_anim_speed = 1.0;
uniform float noise_anim_amplitude = 1.0;
uniform int noise_octaves : hint_range(1, 5) = 3;
uniform float noise_lacunarity : hint_range(0.1, 5.0) = 2.0;
uniform float noise_gain : hint_range(0.1, 1.0) = 0.5;
uniform float noise_base_scale : hint_range(0.1, 10.0) = 1.0;

group_uniforms Stylization_FX;
uniform bool use_gradient_map = false;
uniform sampler2D gradient_texture : hint_default_white;
uniform bool use_monochrome = false;
uniform vec4 monochrome_color : source_color = vec4(0.2, 1.0, 0.4, 1.0);
uniform bool use_color_quantization = false;
uniform float color_levels : hint_range(2.0, 64.0) = 16.0;
uniform bool use_auto_exposure = false;
uniform float exposure_threshold : hint_range(0.0, 1.0) = 0.7;
uniform float exposure_intensity : hint_range(0.0, 2.0) = 0.5;

group_uniforms Motion_Persistence;
uniform bool use_motion_persistence = false;
uniform sampler2D previous_frame_tex : hint_default_black;
uniform float persistence_strength : hint_range(0.0, 0.99) = 0.5;

group_uniforms Runtime_FX;
uniform sampler2D degauss_curve;
uniform float degauss_progress = 1.0; 

group_uniforms Manual_Degauss_Settings;
uniform float degauss_wobble_strength : hint_range(0.0, 500.0) = 250.0;
uniform float degauss_color_split : hint_range(0.0, 10.0) = 4.0;
uniform float degauss_bulge_strength : hint_range(0.0, 1.0) = 0.1;
uniform float degauss_tear_strength : hint_range(0.0, 1.0) = 0.2;
uniform float degauss_hue_shift_amount : hint_range(0.0, 6.28318) = 3.14159;
uniform float degauss_invert_strength : hint_range(0.0, 1.0) = 0.3;
uniform float degauss_ripple_strength : hint_range(0.0, 0.2) = 0.05;

group_uniforms;

varying flat vec2 v_tex_size;
varying flat vec2 v_tex_pixel_size;

varying flat vec2 v_degauss_wobble;
varying flat vec3 v_degauss_pack2;
varying flat vec4 v_dyn_pack1; 
varying flat vec4 v_dyn_pack2; 
varying flat vec4 v_dyn_pack3; 
varying flat vec4 v_glitch_field; 
varying flat vec4 v_stripe_calc;
varying flat vec4 v_time_pack1; 
varying flat vec4 v_time_pack2; 

varying flat vec4 v_warp_power_pack;
varying flat vec4 v_glare_calc;
varying flat vec4 v_optim_pack; 
varying flat vec4 v_glass_env_pack;
varying flat vec4 v_glass_tint_pack;

const float INV_TAU = 0.15915494309189535;
const vec3 INV_GAMMA = vec3(0.4166666666666667);
const float TWO_THIRD_PI = 2.09439510239;
const vec3 PHASE_OFFSETS = vec3(0.0, 2.09439510239, 4.18879020479); 
const vec3 HUE_LUMA = vec3(0.299, 0.587, 0.114);
const vec3 HUE_V1 = vec3(0.701, -0.587, -0.114);
const vec3 HUE_V2 = vec3(-0.299, 0.413, -0.114);
const vec3 HUE_V3 = vec3(-0.299, -0.587, 0.886);
const vec3 HUE_U1 = vec3(0.168, 0.330, -0.497);
const vec3 HUE_U2 = vec3(0.328, -0.335, 0.007);
const vec3 HUE_U3 = vec3(-1.250, 1.050, 0.200);

void vertex() {
	v_tex_size = vec2(textureSize(tex, 0));
	v_tex_pixel_size = 1.0 / max(v_tex_size, vec2(0.0001));

	v_warp_power_pack.xy = vec2(1.0 / aspect, aspect);
	v_warp_power_pack.zw = (power_close_axis == 0) ? vec2(1.0 / max(smoothstep(0.5, 1.0, power_state), 0.001), 1.0 / max(smoothstep(0.0, 0.5, power_state), 0.001)) : vec2(1.0 / max(smoothstep(0.0, 0.5, power_state), 0.001), 1.0 / max(smoothstep(0.5, 1.0, power_state), 0.001));
	v_optim_pack.x = 0.0;
	
	if (power_state < 1.0) {
		float t = clamp((power_flash_start - power_state) / max(0.0001, power_flash_start - power_flash_end), 0.0, 1.0);
		v_optim_pack.x = t * t * (3.0 - 2.0 * t) * power_flash_color.a;
	}
	
	v_optim_pack.y = -1.0;
	if (use_vhs_tracking && vhs_tracking_strength > 0.0) {
		float speed = abs(vhs_tracking_speed);
		float sweep_time = speed > 0.0 ? 1.0 / speed : 0.0;
		float total_cycle = sweep_time + max(0.001, vhs_tracking_interval);
		float local_time = mod(TIME, total_cycle);
		if (local_time < sweep_time) v_optim_pack.y = local_time * vhs_tracking_speed;
	}
	
	v_optim_pack.z = scanline_brightness;
	if (crt_profile == 1) v_optim_pack.z = 0.8;
	else if (crt_profile == 2) v_optim_pack.z = 0.4;
	
	v_optim_pack.w = TIME * interlaced_jitter_speed;
	
	v_glare_calc = vec4(cos(glare_rotation), sin(glare_rotation), 1.0 - bezel_shadow_width, glare_size + glare_softness);
	v_glass_env_pack = vec4(1.0 / max(0.001, glass_env_scale), 1.0 / max(0.001, glass_env_scale), 0.5 + glass_env_offset.x, 0.5 + glass_env_offset.y);
	v_glass_tint_pack = vec4(glass_tint.rgb * glass_brightness, glass_env_strength * glass_tint.a);

	float _degauss = 0.0;
	if (degauss_progress < 1.0) _degauss = textureLod(degauss_curve, vec2(degauss_progress, 0.0), 0.0).r;

	float _wobble = wobble_strength;
	if (animate_wobble) _wobble += textureLod(wobble_curve, vec2(fract(TIME * wobble_anim_speed), 0.0), 0.0).r * wobble_anim_amplitude;
	
	_wobble += _degauss * degauss_wobble_strength; 
	v_degauss_wobble = vec2(_degauss, cos(TIME * TAU * 15.0) * _wobble * 0.0001220703125);
	
	v_degauss_pack2 = vec3(
		degauss_bulge_strength * v_degauss_wobble.x,
		degauss_ripple_strength * v_degauss_wobble.x,
		degauss_tear_strength * v_degauss_wobble.x
	);

	v_dyn_pack1.x = 0.0; 
	if (_degauss > 0.0) v_dyn_pack1.x += _degauss * degauss_color_split;

	v_dyn_pack1.y = sharpness;
	if (animate_sharpness) v_dyn_pack1.y += textureLod(sharpness_curve, vec2(fract(TIME * sharpness_anim_speed), 0.0), 0.0).r * sharpness_anim_amplitude;
	if (crt_profile == 1) v_dyn_pack1.y = 0.8;
	else if (crt_profile == 2) v_dyn_pack1.y = 0.5;
	else if (crt_profile == 3) v_dyn_pack1.y = 1.0;

	v_dyn_pack1.z = mask_brightness;
	if (animate_mask_brightness) v_dyn_pack1.z += textureLod(mask_brightness_curve, vec2(fract(TIME * mask_brightness_anim_speed), 0.0), 0.0).r * mask_brightness_anim_amplitude;

	v_dyn_pack1.w = interlaced_strength;
	if (animate_interlaced) v_dyn_pack1.w += textureLod(interlaced_curve, vec2(fract(TIME * interlaced_anim_speed), 0.0), 0.0).r * interlaced_anim_amplitude;

	v_dyn_pack2.x = roll_strength;
	if (animate_roll) v_dyn_pack2.x += textureLod(roll_curve, vec2(fract(TIME * roll_anim_speed), 0.0), 0.0).r * roll_anim_amplitude;

	v_dyn_pack2.y = glitch_strength;
	if (animate_glitch) v_dyn_pack2.y += textureLod(glitch_curve, vec2(fract(TIME * glitch_anim_speed), 0.0), 0.0).r * glitch_anim_amplitude;

	v_dyn_pack2.z = use_noise ? noise_strength : 0.0;
	if (animate_noise && use_noise) v_dyn_pack2.z += textureLod(noise_curve, vec2(fract(TIME * noise_anim_speed), 0.0), 0.0).r * noise_anim_amplitude;

	v_dyn_pack3.x = use_echo ? echo_strength : 0.0;
	if (animate_echo_strength && use_echo) {
		if (echo_strength_anim_interval > 0.0) {
			float active_time = 1.0 / max(0.001, echo_strength_anim_speed);
			float total_time = active_time + echo_strength_anim_interval;
			float local_t = mod(TIME, total_time);
			if (local_t < active_time) v_dyn_pack3.x += textureLod(echo_strength_curve, vec2(local_t * echo_strength_anim_speed, 0.0), 0.0).r * echo_strength_anim_amplitude;
		} else {
			v_dyn_pack3.x += textureLod(echo_strength_curve, vec2(fract(TIME * echo_strength_anim_speed), 0.0), 0.0).r * echo_strength_anim_amplitude;
		}
	}

	v_dyn_pack3.y = echo_offset;
	if (animate_echo_offset) {
		if (echo_offset_anim_interval > 0.0) {
			float active_time = 1.0 / max(0.001, echo_offset_anim_speed);
			float total_time = active_time + echo_offset_anim_interval;
			float local_t = mod(TIME, total_time);
			if (local_t < active_time) v_dyn_pack3.y += textureLod(echo_offset_curve, vec2(local_t * echo_offset_anim_speed, 0.0), 0.0).r * echo_offset_anim_amplitude;
		} else {
			v_dyn_pack3.y += textureLod(echo_offset_curve, vec2(fract(TIME * echo_offset_anim_speed), 0.0), 0.0).r * echo_offset_anim_amplitude;
		}
	}
	
	v_dyn_pack3.z = TIME * stripe_hue_osc_speed;
	v_dyn_pack3.w = TIME * stripe_secondary_wave_speed;

	float glitch_time = floor(TIME * 20.0);
	float r1 = fract(sin(glitch_time * 91.2228) * 43758.5453);
	v_glitch_field.x = fract(sin(glitch_time * 50.481) * 43758.5453);
	v_glitch_field.y = step(1.0 - glitch_rate, r1) * (fract(sin(glitch_time * 125.391) * 43758.5453) - 0.5) * v_dyn_pack2.y;
	v_glitch_field.z = float(int(TIME * interlaced_fps) & 1); 
	v_glitch_field.w = TIME * 91.2228;

	v_time_pack1 = vec4(TIME * 60.0, TIME * 30.0, fract(TIME * 0.2), fract(TIME * 0.1));
	v_time_pack2 = vec4(TIME * dot_crawl_speed, TIME * roll_speed, TIME * 15.0, 1.0 / max(mask_scale, 0.01));

	if (use_sweep_stripe) {
		float margin = stripe_width * 1.5;
		v_stripe_calc.x = -margin + fract((TIME * stripe_speed) / stripe_interval + stripe_offset) * (1.0 + (margin * 2.0));
		v_stripe_calc.y = cos(stripe_angle);
		v_stripe_calc.z = sin(stripe_angle);
		v_stripe_calc.w = 1.0 / max(0.0001, stripe_width * 0.5);
	} else {
		v_stripe_calc = vec4(0.0);
	}
}

vec3 rgb_to_yiq(vec3 rgb) {
    return vec3(
        0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b,
        0.5959 * rgb.r - 0.2746 * rgb.g - 0.3213 * rgb.b,
        0.2115 * rgb.r - 0.5227 * rgb.g + 0.3112 * rgb.b
    );
}

vec3 yiq_to_rgb(vec3 yiq) {
    return clamp(vec3(
        yiq.x + 0.956 * yiq.y + 0.619 * yiq.z,
        yiq.x - 0.272 * yiq.y - 0.647 * yiq.z,
        yiq.x - 1.106 * yiq.y + 1.703 * yiq.z
    ), 0.0, 1.0);
}

// 2D to 1D Hash for grayscale noise
float hash12(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * 0.1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

// 2D to 3D Hash for chroma noise
vec3 hash32(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
	p3 += dot(p3, p3.yxz + 33.33);
	return fract((p3.xxy + p3.yzz) * p3.zyx);
}

// 2D Value Noise (1 Channel)
float value_noise_1(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash12(i + vec2(0.0, 0.0)), hash12(i + vec2(1.0, 0.0)), u.x),
			   mix(hash12(i + vec2(0.0, 1.0)), hash12(i + vec2(1.0, 1.0)), u.x), u.y);
}

// 2D Value Noise (3 Channels)
vec3 value_noise_3(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash32(i + vec2(0.0, 0.0)), hash32(i + vec2(1.0, 0.0)), u.x),
			   mix(hash32(i + vec2(0.0, 1.0)), hash32(i + vec2(1.0, 1.0)), u.x), u.y);
}

// Fractional Brownian Motion (1 Channel)
float fbm_1(vec2 p, int octaves, float lacunarity, float gain) {
	float val = 0.0;
	float amp = 1.0;
	float norm = 0.0;
	for (int i = 0; i < 5; i++) {
		if (i >= octaves) break;
		val += amp * value_noise_1(p);
		norm += amp;
		p *= lacunarity;
		amp *= gain;
	}
	return val / norm;
}

// Fractional Brownian Motion (3 Channels)
vec3 fbm_3(vec2 p, int octaves, float lacunarity, float gain) {
	vec3 val = vec3(0.0);
	float amp = 1.0;
	float norm = 0.0;
	for (int i = 0; i < 5; i++) {
		if (i >= octaves) break;
		val += amp * value_noise_3(p);
		norm += amp;
		p *= lacunarity;
		amp *= gain;
	}
	return val / norm;
}

vec2 warp(vec2 uv) {
	uv -= 0.5;
	uv.x *= v_warp_power_pack.x;
	uv /= 1.0 - curve * (dot(uv, uv) - 0.25);
	uv.x *= v_warp_power_pack.y;
	uv += 0.5;
	
	return (uv - 0.5) * v_warp_power_pack.zw + 0.5;
}

vec3 linear_to_srgb(vec3 col) {
	return mix((pow(col, INV_GAMMA) * 1.055) - 0.055, col * 12.92, lessThan(col, vec3(0.0031318)));
}

vec3 srgb_to_linear(vec3 col) {
	return mix(pow((col + 0.055) * 0.947867298578, vec3(2.4)), col * 0.0773993808049, lessThan(col, vec3(0.04045)));
}

vec3 shift_hue(vec3 color, float shift) {
	float c = cos(shift);
	float s = sin(shift);
	vec3 col0 = HUE_LUMA + HUE_V1 * c + HUE_U1 * s;
	vec3 col1 = HUE_LUMA + HUE_V2 * c + HUE_U2 * s;
	vec3 col2 = HUE_LUMA + HUE_V3 * c + HUE_U3 * s;
	return clamp(vec3(dot(color, col0), dot(color, col1), dot(color, col2)), 0.0, 1.0);
}

float evaluate_wave(int profile, float pos) {
	if (profile == 0) return 0.5 + 0.5 * sin(pos);
	float f = fract(pos * INV_TAU);
	if (profile == 1) return abs(f - 0.5) * 2.0;
	if (profile == 2) return step(0.5, f);
	return f;
}

vec3 sample_row(int ix, int iy, vec3 wa, vec3 wb, vec3 wc, vec3 wd, vec3 we) {
	return srgb_to_linear(texelFetch(tex, ivec2(ix - 2, iy), 0).rgb) * wa +
	       srgb_to_linear(texelFetch(tex, ivec2(ix - 1, iy), 0).rgb) * wb +
	       srgb_to_linear(texelFetch(tex, ivec2(ix,     iy), 0).rgb) * wc +
	       srgb_to_linear(texelFetch(tex, ivec2(ix + 1, iy), 0).rgb) * wd +
	       srgb_to_linear(texelFetch(tex, ivec2(ix + 2, iy), 0).rgb) * we;
}

vec3 sample_image(vec2 uv, vec2 local_chroma_offset) {
	vec2 scaled_uv = uv * v_tex_size;
	int ix = int(floor(scaled_uv.x));
	bool fast = (v_dyn_pack1.y >= 0.999 && v_dyn_pack1.x == 0.0 && local_chroma_offset == vec2(0.0));
	
	vec3 weight_a, weight_b, weight_c, weight_d, weight_e;
	vec3 weight_scaler_vec = vec3(0.0);
	
	if (!fast) {
		float diff_base = fract(scaled_uv.x) - 0.5; 
		vec3 diff = vec3(diff_base - (v_dyn_pack1.x + local_chroma_offset.x), diff_base, diff_base + (v_dyn_pack1.x + local_chroma_offset.y));
		weight_a = smoothstep(vec3(1.0), vec3(0.0), (diff + 2.0) * v_dyn_pack1.y);
		weight_b = smoothstep(vec3(1.0), vec3(0.0), (diff + 1.0) * v_dyn_pack1.y);
		weight_c = smoothstep(vec3(1.0), vec3(0.0), abs(diff) * v_dyn_pack1.y);
		weight_d = smoothstep(vec3(1.0), vec3(0.0), (1.0 - diff) * v_dyn_pack1.y);
		weight_e = smoothstep(vec3(1.0), vec3(0.0), (2.0 - diff) * v_dyn_pack1.y);
		weight_scaler_vec = 1.0 / (weight_a + weight_b + weight_c + weight_d + weight_e);
	}

	if (use_scanlines) {
		float scan_drift = fract((scaled_uv.y + 0.5) - TIME * scanline_drift_speed);
		int iy = int(floor(scaled_uv.y + 0.5)) - 1;
		int lower_y = iy + 1;

		vec3 raw_upper, raw_lower;
		if (fast) {
			raw_upper = srgb_to_linear(texelFetch(tex, ivec2(ix, iy), 0).rgb);
			raw_lower = srgb_to_linear(texelFetch(tex, ivec2(ix, lower_y), 0).rgb);
		} else {
			raw_upper = sample_row(ix, iy, weight_a, weight_b, weight_c, weight_d, weight_e) * weight_scaler_vec;
			raw_lower = sample_row(ix, lower_y, weight_a, weight_b, weight_c, weight_d, weight_e) * weight_scaler_vec;
		}

		vec3 upper_col = raw_upper * v_optim_pack.z;
		vec3 lower_col = raw_lower * v_optim_pack.z;

		vec3 upper_thickness = mix(vec3(scanline_beam_width_min), vec3(scanline_beam_width_max), upper_col);
		vec3 lower_thickness = mix(vec3(scanline_beam_width_min), vec3(scanline_beam_width_max), lower_col);
		
		vec3 inv_upper_thickness = 1.0 / upper_thickness;
		vec3 inv_lower_thickness = 1.0 / lower_thickness;

		vec3 upper_line = smoothstep(vec3(1.0), vec3(0.0), vec3(scan_drift) * inv_upper_thickness) * upper_col * inv_upper_thickness;
		vec3 lower_line = smoothstep(vec3(1.0), vec3(0.0), vec3(1.0 - scan_drift) * inv_lower_thickness) * lower_col * inv_lower_thickness;
		
		int field_glitch = int(v_glitch_field.z);
		upper_line *= 1.0 - float((iy & 1) ^ field_glitch) * v_dyn_pack1.w;
		lower_line *= 1.0 - float((lower_y & 1) ^ field_glitch) * v_dyn_pack1.w;

		vec3 final_lines = upper_line + lower_line;
		if (scanline_cutoff > 0.0) {
			float luma = dot(raw_upper, vec3(0.333));
			return mix(raw_upper, final_lines, smoothstep(0.0, scanline_cutoff, luma));
		}
		return final_lines;
	} else {
		int iy = int(floor(scaled_uv.y));
		vec3 color = fast ? srgb_to_linear(texelFetch(tex, ivec2(ix, iy), 0).rgb) : sample_row(ix, iy, weight_a, weight_b, weight_c, weight_d, weight_e) * weight_scaler_vec;
		color *= 1.0 - float((iy & 1) ^ int(v_glitch_field.z)) * v_dyn_pack1.w; 
		return color;
	}
}

vec3 mask(vec3 linear_color, vec2 coords) {
	vec3 m_rgb = vec3(0.5);
	float m_w = 0.5;

	switch (mask_type) {
		case 1: 
			m_rgb = 0.5 + 0.5 * cos(coords.x * TWO_THIRD_PI - PHASE_OFFSETS);
			m_w = 0.25;
			m_rgb *= (0.5 + 0.5 * cos(coords.y * PI));
			break;
		case 2: 
			m_rgb = mix(vec3(0.0, 1.0, 0.0), vec3(1.0, 0.0, 1.0), 0.5 + 0.5 * cos(coords.x * PI));
			break;
		case 3: 
			m_rgb = clamp(0.5 + 0.8 * cos(coords.x * TWO_THIRD_PI - PHASE_OFFSETS), 0.0, 1.0);
			m_w = 0.25;
			break;
		case 4: 
			m_rgb = 0.5 + 0.5 * cos(coords.x * TWO_THIRD_PI - PHASE_OFFSETS);
			m_w = 0.3125;
			break;
		case 5: 
			m_rgb = 0.5 + 0.5 * cos(coords.x * TWO_THIRD_PI - PHASE_OFFSETS);
			m_w = 0.375;
			m_rgb *= (0.5 + 0.5 * cos((coords.y + float(int(coords.x * 0.6666666666667) & 1) * 0.5) * TAU));
			break;
		case 6: 
			m_rgb = vec3(1.0);
			m_w = (int(coords.x) % 3 == 0) ? 0.6 : 1.0; 
			break;
		case 7: { 
			int x = int(coords.x) % 3;
			m_rgb = (x == 0) ? vec3(1.0, 0.0, 0.0) : ((x == 1) ? vec3(0.0, 1.0, 0.0) : vec3(0.0, 0.0, 1.0));
			m_w = 0.6;
			break;
		}
		case 8: { 
			vec2 cell = fract(coords * vec2(0.33333, 1.0));
			m_rgb = vec3(step(cell.x, 0.333), step(0.333, cell.x) * step(cell.x, 0.666), step(0.666, cell.x));
			m_rgb *= step(0.1, cell.y) * step(cell.y, 0.9);
			break;
		}
		case 9: { 
			int odd_row = int(coords.y) % 2;
			int x = (int(coords.x) + odd_row) % 3;
			m_rgb = (x == 0) ? vec3(1.0, 0.0, 0.0) : ((x == 1) ? vec3(0.0, 1.0, 0.0) : vec3(0.0, 0.0, 1.0));
			break;
		}
	}

	linear_color *= mix(m_w, 1.0, v_dyn_pack1.z);
	vec3 target_color = linear_color * (1.0 / m_w);
	vec3 primary_col = clamp(target_color, 0.0, 1.0);
	vec3 highlights = target_color - primary_col;
	
	if (m_w < 0.999) {
		highlights *= m_w / (1.0 - m_w);
	} else {
		highlights = vec3(0.0); 
	}
	
	return primary_col * m_rgb + highlights * (1.0 - m_rgb);
}

void fragment() {
	vec2 warped_coords = warp(UV);
	
	if (power_state < 0.001 || warped_coords.x < 0.0 || warped_coords.x > 1.0 || warped_coords.y < 0.0 || warped_coords.y > 1.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		warped_coords.x += v_degauss_wobble.y;

		if (use_edge_wobble) {
			float wobble_noise = value_noise_1(vec2(warped_coords.y * edge_wobble_scale, TIME * edge_wobble_speed));
			warped_coords.x += (wobble_noise - 0.5) * edge_wobble_strength;
		}

		if (use_head_switching) {
			float switch_start = 1.0 - head_switch_height;
			if (warped_coords.y > switch_start) {
				float t = (warped_coords.y - switch_start) / max(0.0001, head_switch_height);
				float curve_power = pow(t, head_switch_curve);
				float jitter = value_noise_1(vec2(warped_coords.y * 100.0, TIME * 15.0));
				warped_coords.x += curve_power * head_switch_strength * (0.8 + 0.4 * jitter);
			}
		}

		if (use_interlaced_jitter && interlaced_jitter_strength > 0.0) {
			float row_id = floor(warped_coords.y * v_tex_size.y);
			float jitter_mod = sin(v_optim_pack.w + row_id * interlaced_jitter_frequency);
			if (interlaced_jitter_random) {
				jitter_mod *= fract(sin(row_id * 12.9898 + TIME) * 43758.5453);
			}
			warped_coords.x += ((int(row_id) & 1) == 0 ? jitter_mod : -jitter_mod) * interlaced_jitter_strength;
		}

		if (v_optim_pack.y >= 0.0) {
			float track_band = step(1.0 - vhs_tracking_height, fract(warped_coords.y + v_optim_pack.y));
			if (track_band > 0.0) {
				float pseudo_rand = fract(sin(floor(warped_coords.y * vhs_tracking_noise_scale) + TIME * 10.0) * 43758.5453);
				warped_coords.x += (pseudo_rand - 0.5) * vhs_tracking_strength * 0.2;
			}
		}
		
		if (v_degauss_wobble.x > 0.0) {
			vec2 center_offset = warped_coords - 0.5;
			float dist = length(center_offset);
			float bulge = sin(dist * 20.0 - v_time_pack1.x) * v_degauss_pack2.x;
			float ripple = sin(dist * 50.0 - v_time_pack1.y) * v_degauss_pack2.y;
			warped_coords += center_offset * (bulge + ripple);
			warped_coords.x += exp(-50.0 * (warped_coords.y - v_time_pack1.z) * (warped_coords.y - v_time_pack1.z)) * sin(warped_coords.y * 100.0) * v_degauss_pack2.z;
		}

		if (v_dyn_pack2.y > 0.0) warped_coords.x += step(abs(warped_coords.y - v_glitch_field.x), glitch_size) * v_glitch_field.y;
		if (vsync_tearing > 0.0) {
			float tear_dist = warped_coords.y - v_time_pack1.w;
			warped_coords.x += exp(-100.0 * tear_dist * tear_dist) * sin(warped_coords.y * 150.0) * vsync_tearing;
		}

		float stripe_factor = 0.0;
		vec2 local_chroma = vec2(0.0);
		vec2 rotated_uv = vec2(0.0); 
		
		if (use_sweep_stripe) {
			vec2 centered_uv = warped_coords - 0.5;
			rotated_uv = vec2(centered_uv.x * v_stripe_calc.y - centered_uv.y * v_stripe_calc.z, centered_uv.x * v_stripe_calc.z + centered_uv.y * v_stripe_calc.y) + 0.5;
			float norm_dist = abs(rotated_uv.y - v_stripe_calc.x) * v_stripe_calc.w;

			if (norm_dist <= 1.0) {
				if (stripe_profile == 1) stripe_factor = exp(-4.0 * norm_dist * norm_dist);
				else if (stripe_profile == 2) stripe_factor = (1.0 - norm_dist) * (1.0 - norm_dist); 
				else { 
					float norm_smooth = max((rotated_uv.y < v_stripe_calc.x) ? stripe_smoothness_lead : stripe_smoothness_trail, 0.001);
					float t = clamp((1.0 - norm_dist) / norm_smooth, 0.0, 1.0);
					if (stripe_profile == 0) stripe_factor = t * t * (3.0 - 2.0 * t);
					else stripe_factor = (0.5 + 0.5 * cos(norm_dist * PI)) * t;
				}
			}
		}

		vec3 col = sample_image(warped_coords, local_chroma);

		if (use_yiq_bleed) {
			vec3 center_yiq = rgb_to_yiq(col);
			
			vec3 raw_col = srgb_to_linear(texture(tex, warped_coords).rgb);
			float raw_luma = rgb_to_yiq(raw_col).x;
			float luma_mask = (raw_luma > 0.001) ? (center_yiq.x / raw_luma) : 0.0;
			
			float spread = yiq_bleed_spread * v_tex_pixel_size.x;
			float offset = yiq_chroma_offset * v_tex_pixel_size.x;
			
			vec3 c0 = rgb_to_yiq(srgb_to_linear(texture(tex, warped_coords + vec2(offset - spread * 2.0, 0.0)).rgb));
			vec3 c1 = rgb_to_yiq(srgb_to_linear(texture(tex, warped_coords + vec2(offset - spread, 0.0)).rgb));
			vec3 c2 = rgb_to_yiq(srgb_to_linear(texture(tex, warped_coords + vec2(offset, 0.0)).rgb));
			vec3 c3 = rgb_to_yiq(srgb_to_linear(texture(tex, warped_coords + vec2(offset + spread, 0.0)).rgb));
			vec3 c4 = rgb_to_yiq(srgb_to_linear(texture(tex, warped_coords + vec2(offset + spread * 2.0, 0.0)).rgb));

			float i_blurred = (c0.y + c4.y) * 0.0625 + (c1.y + c3.y) * 0.25 + c2.y * 0.375;
			float q_blurred = (c0.z + c4.z) * 0.0625 + (c1.z + c3.z) * 0.25 + c2.z * 0.375;

			col = yiq_to_rgb(vec3(center_yiq.x, i_blurred * luma_mask, q_blurred * luma_mask));
		}

		if (use_sweep_stripe && stripe_factor > 0.0) {
			if (stripe_enable_hue) {
				float current_hue = stripe_hue_shift;
				if (stripe_hue_oscillate) {
					float spatial_coord = ((stripe_hue_osc_axis == 1) ? rotated_uv.x : rotated_uv.y) * stripe_hue_osc_scale;
					float osc_val = evaluate_wave(stripe_hue_osc_profile, (spatial_coord + stripe_hue_osc_offset) * stripe_hue_osc_freq + v_dyn_pack3.z);
					current_hue += mix(stripe_hue_osc_min, stripe_hue_osc_max, osc_val) * stripe_hue_osc_intensity;
				}
				col = shift_hue(col, current_hue * stripe_factor);
			}
			if (stripe_enable_secondary_hue) {
				float current_secondary_hue = stripe_secondary_hue_shift;
				float current_mix_factor = stripe_secondary_mix * stripe_factor;
				if (stripe_secondary_wave_enabled) {
					float spatial_coord = ((stripe_secondary_wave_axis == 0) ? rotated_uv.x : rotated_uv.y) * stripe_secondary_wave_scale;
					float wave_val = evaluate_wave(stripe_secondary_wave_profile, (spatial_coord + stripe_secondary_wave_offset) * stripe_secondary_wave_freq + v_dyn_pack3.w);
					current_secondary_hue += mix(stripe_secondary_wave_min, stripe_secondary_wave_max, wave_val) * stripe_secondary_wave_intensity;
				}
				col = mix(col, shift_hue(col, current_secondary_hue * stripe_factor), current_mix_factor);
			}
			if (stripe_enable_brightness) col *= 1.0 + stripe_factor * (stripe_brightness - 1.0); 
			if (stripe_enable_contrast) col = clamp((col - 0.5) * mix(1.0, stripe_contrast, stripe_factor) + 0.5, 0.0, 1.0);
			if (stripe_enable_saturation) col = mix(vec3(dot(col, HUE_LUMA)), col, 1.0 + stripe_factor * (stripe_saturation - 1.0)); 
		}

		if (v_degauss_wobble.x > 0.0) {
			if (degauss_hue_shift_amount > 0.0) col = shift_hue(col, v_degauss_wobble.x * degauss_hue_shift_amount);
			if (degauss_invert_strength > 0.0) col = mix(col, vec3(1.0) - col, v_degauss_wobble.x * degauss_invert_strength);
		}
		if (use_dot_crawl && dot_crawl_strength > 0.0) col += length(col - srgb_to_linear(texture(tex, warped_coords + vec2(v_tex_pixel_size.x, 0.0)).rgb)) * sin(FRAGCOORD.x * PI) * sin(FRAGCOORD.y * PI + v_time_pack2.x) * dot_crawl_strength;
		if (v_dyn_pack3.x > 0.0) col += srgb_to_linear(texture(tex, warped_coords - vec2(v_dyn_pack3.y, 0.0)).rgb) * v_dyn_pack3.x;
		if (v_dyn_pack2.x > 0.0) col *= 1.0 + smoothstep(0.8, 1.0, sin(warped_coords.y * roll_size - v_time_pack2.y)) * v_dyn_pack2.x;

		if (v_dyn_pack2.z > 0.0) {
			vec2 frame_offset = vec2(
				fract(sin(floor(v_time_pack1.x) * 12.9898) * 43758.5453),
				fract(sin(floor(v_time_pack1.x) * 78.233) * 43758.5453)
			) * 1000.0;
			
			vec2 noise_coords = (warped_coords * v_tex_size) * (noise_base_scale * 0.05) + frame_offset;

			vec3 noise_val;
			if (chroma_noise) {
				noise_val = fbm_3(noise_coords, noise_octaves, noise_lacunarity, noise_gain);
			} else {
				noise_val = vec3(fbm_1(noise_coords, noise_octaves, noise_lacunarity, noise_gain));
			}
			col += (noise_val - 0.5) * v_dyn_pack2.z;
		}

		col = mask(col, FRAGCOORD.xy * v_time_pack2.w);

		if (use_auto_exposure) {
			float luma = dot(col, HUE_LUMA);
			col = mix(col, vec3(1.0), smoothstep(exposure_threshold, 1.0, luma) * exposure_intensity);
		}
		if (use_color_quantization) col = floor(col * color_levels) / color_levels;
		if (use_gradient_map) {
			float luma = dot(col, HUE_LUMA);
			col = textureLod(gradient_texture, vec2(clamp(luma, 0.0, 1.0), 0.0), 0.0).rgb;
		}
		if (use_monochrome) {
			float luma = dot(col, HUE_LUMA);
			col = monochrome_color.rgb * luma;
		}
		if (use_motion_persistence) {
			vec3 prev_col = srgb_to_linear(texture(previous_frame_tex, warped_coords).rgb);
			col = mix(col, prev_col, persistence_strength);
		}

		if (use_hum_bar && hum_bar_strength > 0.0) {
			float hum = 0.5 + 0.5 * sin(warped_coords.y * 10.0 - TIME * hum_bar_speed);
			col *= 1.0 - (hum * hum_bar_strength);
		}
		if (use_glare && glare_strength > 0.0) {
			vec2 centered = warped_coords - glare_position;
			vec2 rot_uv = vec2(centered.x * v_glare_calc.x - centered.y * v_glare_calc.y, centered.x * v_glare_calc.y + centered.y * v_glare_calc.x);
			float glare = smoothstep(v_glare_calc.w, glare_size, abs(rot_uv.x));
			col += vec3(glare * glare_strength);
		}
		if (use_glass_reflection) {
			vec2 env_uv = warped_coords - 0.5;
			if (glass_curve > 0.0) {
				env_uv.x *= v_warp_power_pack.x;
				env_uv /= 1.0 - glass_curve * (dot(env_uv, env_uv) - 0.25);
				env_uv.x *= v_warp_power_pack.y;
			}
			env_uv = (env_uv * v_glass_env_pack.xy) + v_glass_env_pack.zw;
			
			vec3 env = srgb_to_linear(textureLod(glass_env_tex, env_uv, glass_blur).rgb);
			env *= v_glass_tint_pack.rgb;
			
			if (abs(glass_saturation - 1.0) > 0.001) {
				env = mix(vec3(dot(env, HUE_LUMA)), env, glass_saturation);
			}
			
			vec3 blended;
			if (glass_blend_mode == 0) blended = col + env;
			else if (glass_blend_mode == 1) blended = 1.0 - (1.0 - col) * (1.0 - env);
			else blended = max(col, env);
			
			col = mix(col, blended, v_glass_tint_pack.a);
		}
		if (bezel_shadow_strength > 0.0) {
			vec2 edge_dist = abs(warped_coords - 0.5) * 2.0;
			float shadow = smoothstep(v_glare_calc.z, 1.0, max(edge_dist.x, edge_dist.y));
			col *= 1.0 - (shadow * bezel_shadow_strength);
		}
		
		if (v_optim_pack.x > 0.0) {
			col = mix(col, power_flash_color.rgb, v_optim_pack.x);
		}

		COLOR.rgb = linear_to_srgb(col);
	}
}