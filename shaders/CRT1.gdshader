shader_type canvas_item;

uniform sampler2D tex: filter_linear;

group_uniforms CRT_Geometry;
uniform float curve : hint_range(0.0, 0.5) = 0.0;
uniform float aspect : hint_range(0.5, 1.0) = 0.75;

group_uniforms Mask;
uniform int mask_type : hint_enum(
	"Dots:1", "Aperture Grille:2", "Wide Grille:3", "Wide Soft Grille:4", "Slot Mask:5", "Fake Grouped (Luminance):6", "Null:0") = 6;

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

group_uniforms Interlaced_Flicker;
uniform float interlaced_strength : hint_range(0.0, 1.0) = 0.0;
uniform bool animate_interlaced = false;
uniform sampler2D interlaced_curve;
uniform float interlaced_anim_speed = 1.0;
uniform float interlaced_anim_amplitude = 1.0;
uniform float interlaced_fps : hint_range(1.0, 60.0) = 30.0;

group_uniforms Interlaced_Jitter;
uniform float interlaced_jitter_strength : hint_range(0.0, 0.05) = 0.0;
uniform float interlaced_jitter_speed : hint_range(0.1, 20.0) = 10.0;

group_uniforms VHS_Tracking;
uniform float vhs_tracking_strength : hint_range(0.0, 1.0) = 0.0;
uniform float vhs_tracking_height : hint_range(0.01, 0.5) = 0.08;
uniform float vhs_tracking_speed : hint_range(-10.0, 10.0) = 2.0;

group_uniforms Sharpness;
uniform float sharpness : hint_range(0.5, 1.0) = 0.6666666666666666666666666667;
uniform bool animate_sharpness = false;
uniform sampler2D sharpness_curve;
uniform float sharpness_anim_speed = 1.0;
uniform float sharpness_anim_amplitude = 1.0;

group_uniforms Color_Offset;
uniform float color_offset : hint_range(-5, 5) = 0.0;
uniform bool animate_color_offset = false;
uniform sampler2D color_offset_curve;
uniform float color_offset_anim_speed = 1.0;
uniform float color_offset_anim_amplitude = 1.0;

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

group_uniforms Sweep_Stripe.Chromatic_Aberration;
uniform bool stripe_enable_chroma = false;
uniform float stripe_chroma_aberration : hint_range(0.0, 50.0) = 5.0;
uniform float stripe_chroma_red_weight : hint_range(-5.0, 5.0) = 1.0;
uniform float stripe_chroma_blue_weight : hint_range(-5.0, 5.0) = 1.0;
uniform bool stripe_chroma_wave_enabled = false;
uniform float stripe_chroma_wave_freq : hint_range(0.0, 100.0) = 25.0;

group_uniforms Multipath_Echo;
uniform float echo_strength : hint_range(0.0, 1.0) = 0.0;
uniform bool animate_echo_strength = false;
uniform sampler2D echo_strength_curve;
uniform float echo_strength_anim_speed = 1.0;
uniform float echo_strength_anim_amplitude = 1.0;
uniform float echo_offset : hint_range(-0.05, 0.05) = 0.015;
uniform bool animate_echo_offset = false;
uniform sampler2D echo_offset_curve;
uniform float echo_offset_anim_speed = 1.0;
uniform float echo_offset_anim_amplitude = 1.0;

group_uniforms Dot_Crawl;
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
uniform float noise_strength : hint_range(0.0, 0.5) = 0.03;
uniform bool chroma_noise = false;
uniform bool animate_noise = false;
uniform sampler2D noise_curve;
uniform float noise_anim_speed = 1.0;
uniform float noise_anim_amplitude = 1.0;

group_uniforms Phosphor_Bloom;
uniform float bloom_threshold : hint_range(0.0, 1.0) = 0.6;
uniform float bloom_multiplier : hint_range(0.0, 5.0) = 0.5;
uniform bool animate_bloom = false;
uniform sampler2D bloom_curve;
uniform float bloom_anim_speed = 1.0;
uniform float bloom_anim_amplitude = 1.0;
uniform vec2 bloom_blur_radius = vec2(4.0, 4.0);

group_uniforms Stylization_FX;
uniform bool use_gradient_map = false;
uniform sampler2D gradient_texture : hint_default_white;

uniform bool use_color_quantization = false;
uniform float color_levels : hint_range(2.0, 64.0) = 16.0;

uniform bool use_auto_exposure = false;
uniform float exposure_threshold : hint_range(0.0, 1.0) = 0.7;
uniform float exposure_intensity : hint_range(0.0, 2.0) = 0.5;

group_uniforms Runtime_FX;
uniform sampler2D degauss_curve;
uniform float degauss_progress = 1.0; 

group_uniforms Manual_Degauss_Settings;
uniform float degauss_wobble_strength : hint_range(0.0, 500.0) = 250.0;
uniform float degauss_color_split : hint_range(0.0, 10.0) = 4.0;
uniform float degauss_bloom_multiplier : hint_range(0.0, 10.0) = 2.0;
uniform float degauss_bulge_strength : hint_range(0.0, 1.0) = 0.1;
uniform float degauss_tear_strength : hint_range(0.0, 1.0) = 0.2;
uniform float degauss_hue_shift_amount : hint_range(0.0, 6.28318) = 3.14159;
uniform float degauss_invert_strength : hint_range(0.0, 1.0) = 0.3;
uniform float degauss_ripple_strength : hint_range(0.0, 0.2) = 0.05;

group_uniforms;

// Compressed Varying Data Registers
varying flat vec2 v_degauss_wobble;
varying flat vec4 v_dyn_pack1; 
varying flat vec4 v_dyn_pack2; 
varying flat vec4 v_dyn_pack3; 
varying flat vec4 v_glitch_field; 
varying flat vec3 v_stripe_calc;
varying flat vec4 v_time_pack1; 
varying flat vec4 v_time_pack2; 

// Global Precomputed Math Constants
const float INV_TAU = 0.15915494309189535;
const vec3 INV_GAMMA = vec3(0.4166666666666667);
const float TWO_THIRD_PI = 2.09439510239;
const vec3 PHASE_OFFSETS = vec3(0.0, 2.09439510239, 4.18879020479); 

// Unrolled Hue Rotation Matrices for Fast Hardware Alignment
const vec3 HUE_LUMA = vec3(0.299, 0.587, 0.114);
const vec3 HUE_V1 = vec3(0.701, -0.587, -0.114);
const vec3 HUE_V2 = vec3(-0.299, 0.413, -0.114);
const vec3 HUE_V3 = vec3(-0.299, -0.587, 0.886);
const vec3 HUE_U1 = vec3(0.168, 0.330, -0.497);
const vec3 HUE_U2 = vec3(0.328, -0.335, 0.007);
const vec3 HUE_U3 = vec3(-1.250, 1.050, 0.200);

void vertex()
{
	float _degauss = 0.0;
	if (degauss_progress < 1.0) {
		_degauss = textureLod(degauss_curve, vec2(degauss_progress, 0.0), 0.0).r;
	}

	float _wobble = wobble_strength;
	if (animate_wobble) _wobble += textureLod(wobble_curve, vec2(fract(TIME * wobble_anim_speed), 0.0), 0.0).r * wobble_anim_amplitude;
	
	_wobble += _degauss * degauss_wobble_strength; 
	v_degauss_wobble = vec2(_degauss, cos(TIME * TAU * 15.0) * _wobble * 0.0001220703125);

	v_dyn_pack1.x = color_offset;
	if (animate_color_offset) v_dyn_pack1.x += textureLod(color_offset_curve, vec2(fract(TIME * color_offset_anim_speed), 0.0), 0.0).r * color_offset_anim_amplitude;
	v_dyn_pack1.x += _degauss * degauss_color_split;

	v_dyn_pack1.y = sharpness;
	if (animate_sharpness) v_dyn_pack1.y += textureLod(sharpness_curve, vec2(fract(TIME * sharpness_anim_speed), 0.0), 0.0).r * sharpness_anim_amplitude;

	v_dyn_pack1.z = mask_brightness;
	if (animate_mask_brightness) v_dyn_pack1.z += textureLod(mask_brightness_curve, vec2(fract(TIME * mask_brightness_anim_speed), 0.0), 0.0).r * mask_brightness_anim_amplitude;

	v_dyn_pack1.w = interlaced_strength;
	if (animate_interlaced) v_dyn_pack1.w += textureLod(interlaced_curve, vec2(fract(TIME * interlaced_anim_speed), 0.0), 0.0).r * interlaced_anim_amplitude;

	v_dyn_pack2.x = roll_strength;
	if (animate_roll) v_dyn_pack2.x += textureLod(roll_curve, vec2(fract(TIME * roll_anim_speed), 0.0), 0.0).r * roll_anim_amplitude;

	v_dyn_pack2.y = glitch_strength;
	if (animate_glitch) v_dyn_pack2.y += textureLod(glitch_curve, vec2(fract(TIME * glitch_anim_speed), 0.0), 0.0).r * glitch_anim_amplitude;

	v_dyn_pack2.z = noise_strength;
	if (animate_noise) v_dyn_pack2.z += textureLod(noise_curve, vec2(fract(TIME * noise_anim_speed), 0.0), 0.0).r * noise_anim_amplitude;

	v_dyn_pack2.w = bloom_multiplier;
	if (animate_bloom) v_dyn_pack2.w += textureLod(bloom_curve, vec2(fract(TIME * bloom_anim_speed), 0.0), 0.0).r * bloom_anim_amplitude;
	v_dyn_pack2.w += _degauss * degauss_bloom_multiplier;

	v_dyn_pack3.x = echo_strength;
	if (animate_echo_strength) v_dyn_pack3.x += textureLod(echo_strength_curve, vec2(fract(TIME * echo_strength_anim_speed), 0.0), 0.0).r * echo_strength_anim_amplitude;

	v_dyn_pack3.y = echo_offset;
	if (animate_echo_offset) v_dyn_pack3.y += textureLod(echo_offset_curve, vec2(fract(TIME * echo_offset_anim_speed), 0.0), 0.0).r * echo_offset_anim_amplitude;
	
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
	} else {
		v_stripe_calc = vec3(0.0);
	}
}

vec2 warp(vec2 uv)
{
	uv -= 0.5;
	uv.x /= aspect;
	uv /= 1.0 - curve * (dot(uv, uv) - 0.25);
	uv.x *= aspect;
	return uv + 0.5;
}

vec3 linear_to_srgb(vec3 col)
{
	return mix((pow(col, INV_GAMMA) * 1.055) - 0.055, col * 12.92, lessThan(col, vec3(0.0031318)));
}

vec3 srgb_to_linear(vec3 col)
{
	return mix(pow((col + 0.055) * 0.947867298578, vec3(2.4)), col * 0.0773993808049, lessThan(col, vec3(0.04045)));
}

vec3 shift_hue(vec3 color, float shift)
{
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

vec3 sample_image(vec2 uv, vec2 local_chroma_offset, vec2 tex_size)
{
	vec2 scaled_uv = uv * tex_size;
	int ix = int(floor(scaled_uv.x));
	float diff_base = fract(scaled_uv.x) - 0.5; 
	
	vec3 diff = vec3(
		diff_base - (v_dyn_pack1.x + local_chroma_offset.x), 
		diff_base, 
		diff_base + (v_dyn_pack1.x + local_chroma_offset.y)
	);

	vec3 weight_a = smoothstep(vec3(1.0), vec3(0.0), (diff + 2.0) * v_dyn_pack1.y);
	vec3 weight_b = smoothstep(vec3(1.0), vec3(0.0), (diff + 1.0) * v_dyn_pack1.y);
	vec3 weight_c = smoothstep(vec3(1.0), vec3(0.0), abs(diff) * v_dyn_pack1.y);
	vec3 weight_d = smoothstep(vec3(1.0), vec3(0.0), (1.0 - diff) * v_dyn_pack1.y);
	vec3 weight_e = smoothstep(vec3(1.0), vec3(0.0), (2.0 - diff) * v_dyn_pack1.y);
	vec3 weight_scaler = 1.0 / (weight_a + weight_b + weight_c + weight_d + weight_e);

	if (use_scanlines) 
	{
		int iy = int(scaled_uv.y + 0.5) - 1;
		int lower_y = iy + 1;

		vec3 upper_col = sample_row(ix, iy, weight_a, weight_b, weight_c, weight_d, weight_e) * weight_scaler * scanline_brightness;
		vec3 lower_col = sample_row(ix, lower_y, weight_a, weight_b, weight_c, weight_d, weight_e) * weight_scaler * scanline_brightness;

		vec3 upper_thickness = mix(vec3(scanline_beam_width_min), vec3(scanline_beam_width_max), upper_col);
		vec3 lower_thickness = mix(vec3(scanline_beam_width_min), vec3(scanline_beam_width_max), lower_col);
		
		vec3 inv_upper_thickness = 1.0 / upper_thickness;
		vec3 inv_lower_thickness = 1.0 / lower_thickness;
		float sawtooth = (scaled_uv.y + 0.5) - float(iy);

		vec3 upper_line = smoothstep(vec3(1.0), vec3(0.0), vec3(sawtooth) * inv_upper_thickness) * upper_col * inv_upper_thickness;
		vec3 lower_line = smoothstep(vec3(1.0), vec3(0.0), vec3(1.0 - sawtooth) * inv_lower_thickness) * lower_col * inv_lower_thickness;
		
		int field_glitch = int(v_glitch_field.z);
		upper_line *= 1.0 - float((iy & 1) ^ field_glitch) * v_dyn_pack1.w;
		lower_line *= 1.0 - float((lower_y & 1) ^ field_glitch) * v_dyn_pack1.w;

		return upper_line + lower_line;
	} 
	else 
	{
		int iy = int(floor(scaled_uv.y));
		vec3 color = sample_row(ix, iy, weight_a, weight_b, weight_c, weight_d, weight_e) * weight_scaler;
		color *= 1.0 - float((iy & 1) ^ int(v_glitch_field.z)) * v_dyn_pack1.w; 
		return color;
	}
}

vec4 generate_mask(vec2 coords)
{
	switch (mask_type)
	{
		case 1: { 
			float x_phase = coords.x * TWO_THIRD_PI;
			vec3 rgb = 0.5 + 0.5 * cos(x_phase - PHASE_OFFSETS);
			return vec4(rgb * (0.5 + 0.5 * cos(coords.y * PI)), 0.25);
		}
		case 2: { 
			return vec4(mix(vec3(0.0, 1.0, 0.0), vec3(1.0, 0.0, 1.0), 0.5 + 0.5 * cos(coords.x * PI)), 0.5);
		}
		case 3: { 
			return vec4(clamp(0.5 + 0.8 * cos(coords.x * TWO_THIRD_PI - PHASE_OFFSETS), 0.0, 1.0), 0.25);
		}
		case 4: { 
			return vec4(0.5 + 0.5 * cos(coords.x * TWO_THIRD_PI - PHASE_OFFSETS), 0.3125);
		}
		case 5: { 
			vec3 rgb = 0.5 + 0.5 * cos(coords.x * TWO_THIRD_PI - PHASE_OFFSETS);
			return vec4(rgb * (0.5 + 0.5 * cos((coords.y + float(int(coords.x * 0.6666666666667) & 1) * 0.5) * TAU)), 0.375);
		}
		case 6: { 
			return vec4(vec3(1.0), (int(coords.x) % 3 == 0) ? 0.6 : 1.0); 
		}
		default:
			return vec4(0.5);
	}
}

vec3 mask(vec3 linear_color, vec2 coords)
{
	vec4 m = generate_mask(coords);
	linear_color *= mix(m.w, 1.0, v_dyn_pack1.z);

	vec3 target_color = linear_color * (1.0 / m.w);
	vec3 primary_col = clamp(target_color, 0.0, 1.0);
	vec3 highlights = target_color - primary_col;
	
	if (m.w < 0.999) {
		highlights *= m.w / (1.0 - m.w);
	} else {
		highlights = vec3(0.0); 
	}

	return primary_col * m.rgb + highlights * (1.0 - m.rgb);
}

void fragment()
{
	vec2 tex_size = vec2(textureSize(tex, 0));
	vec2 tex_pixel_size = 1.0 / tex_size;

	vec2 warped_coords = warp(UV);
	warped_coords.x += v_degauss_wobble.y;

	if (interlaced_jitter_strength > 0.0) {
		float row_id = floor(warped_coords.y * tex_size.y);
		float jitter_mod = sin(TIME * interlaced_jitter_speed + row_id * 1.5) * interlaced_jitter_strength;
		warped_coords.x += ((int(row_id) & 1) == 0 ? jitter_mod : -jitter_mod);
	}

	if (vhs_tracking_strength > 0.0) {
		float track_band = step(1.0 - vhs_tracking_height, fract(warped_coords.y + TIME * vhs_tracking_speed));
		if (track_band > 0.0) {
			float pseudo_rand = fract(sin(floor(warped_coords.y * 40.0) + TIME * 10.0) * 43758.5453);
			warped_coords.x += (pseudo_rand - 0.5) * vhs_tracking_strength * 0.2;
		}
	}
	
	if (v_degauss_wobble.x > 0.0) {
		vec2 center_offset = warped_coords - 0.5;
		float dist = length(center_offset);
		
		float bulge = sin(dist * 20.0 - v_time_pack1.x) * degauss_bulge_strength * v_degauss_wobble.x;
		float ripple = sin(dist * 50.0 - v_time_pack1.y) * degauss_ripple_strength * v_degauss_wobble.x;
		warped_coords += center_offset * (bulge + ripple);
		
		float tear_dist = warped_coords.y - v_time_pack1.z;
		warped_coords.x += exp(-50.0 * tear_dist * tear_dist) * sin(warped_coords.y * 100.0) * v_degauss_wobble.x * degauss_tear_strength;
	}

	if (v_dyn_pack2.y > 0.0) {
		warped_coords.x += step(abs(warped_coords.y - v_glitch_field.x), glitch_size) * v_glitch_field.y;
	}
	
	if (vsync_tearing > 0.0) {
		float tear_dist = warped_coords.y - v_time_pack1.w;
		warped_coords.x += exp(-100.0 * tear_dist * tear_dist) * sin(warped_coords.y * 150.0) * vsync_tearing;
	}

	// --- ADVANCED SWEEP STRIPE CALCULATION ---
	float stripe_factor = 0.0;
	vec2 local_chroma = vec2(0.0);
	vec2 rotated_uv = vec2(0.0);
	
	if (use_sweep_stripe) {
		vec2 centered_uv = warped_coords - 0.5;
		
		rotated_uv = vec2(
			centered_uv.x * v_stripe_calc.y - centered_uv.y * v_stripe_calc.z,
			centered_uv.x * v_stripe_calc.z + centered_uv.y * v_stripe_calc.y
		) + 0.5;

		float half_w = stripe_width * 0.5;
		float norm_dist = abs(rotated_uv.y - v_stripe_calc.x) / half_w;

		if (norm_dist <= 1.0) {
			if (stripe_profile == 1) { 
				stripe_factor = exp(-4.0 * norm_dist * norm_dist);
			} else if (stripe_profile == 2) { 
				stripe_factor = (1.0 - norm_dist) * (1.0 - norm_dist); 
			} else { 
				float norm_smooth = max((rotated_uv.y < v_stripe_calc.x) ? stripe_smoothness_lead : stripe_smoothness_trail, 0.001);
				float t = clamp((1.0 - norm_dist) / norm_smooth, 0.0, 1.0);
				
				if (stripe_profile == 0) {
					stripe_factor = t * t * (3.0 - 2.0 * t);
				} else {
					stripe_factor = (0.5 + 0.5 * cos(norm_dist * PI)) * t;
				}
			}
		}

		if (stripe_factor > 0.0 && stripe_enable_chroma) {
			float chroma_mod = stripe_chroma_aberration * stripe_factor;
			if (stripe_chroma_wave_enabled) {
				chroma_mod *= (1.0 + sin(rotated_uv.x * stripe_chroma_wave_freq + v_time_pack2.z));
			}
			local_chroma = vec2(chroma_mod * stripe_chroma_red_weight, chroma_mod * stripe_chroma_blue_weight);
		}
	}
	// ------------------------------------------------------------------

	vec3 col = sample_image(warped_coords, local_chroma, tex_size);

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
		if (stripe_enable_brightness) {
			col *= 1.0 + stripe_factor * (stripe_brightness - 1.0); 
		}
		if (stripe_enable_contrast) {
			col = mix(col, clamp((col - 0.5) * stripe_contrast + 0.5, 0.0, 1.0), stripe_factor);
		}
		if (stripe_enable_saturation) {
			col = mix(vec3(dot(col, HUE_LUMA)), col, 1.0 + stripe_factor * (stripe_saturation - 1.0)); 
		}
	}

	if (v_degauss_wobble.x > 0.0) {
		if (degauss_hue_shift_amount > 0.0) col = shift_hue(col, v_degauss_wobble.x * degauss_hue_shift_amount);
		if (degauss_invert_strength > 0.0) col = mix(col, vec3(1.0) - col, v_degauss_wobble.x * degauss_invert_strength);
	}

	if (dot_crawl_strength > 0.0) {
		col += length(col - srgb_to_linear(texture(tex, warped_coords + vec2(tex_pixel_size.x, 0.0)).rgb)) * sin(FRAGCOORD.x * PI) * sin(FRAGCOORD.y * PI + v_time_pack2.x) * dot_crawl_strength;
	}

	if (v_dyn_pack3.x > 0.0) {
		col += srgb_to_linear(texture(tex, warped_coords - vec2(v_dyn_pack3.y, 0.0)).rgb) * v_dyn_pack3.x;
	}

	if (v_dyn_pack2.x > 0.0) {
		col *= 1.0 + smoothstep(0.8, 1.0, sin(warped_coords.y * roll_size - v_time_pack2.y)) * v_dyn_pack2.x;
	}

	if (v_dyn_pack2.z > 0.0) {
		vec2 noise_coords = FRAGCOORD.xy * v_time_pack2.w;
		vec3 noise_val;
		if (chroma_noise) {
			noise_val = fract(sin(vec3(dot(noise_coords, vec2(12.9898, 78.233)), dot(noise_coords, vec2(39.346, 11.135)), dot(noise_coords, vec2(73.156, 52.235))) + v_glitch_field.w) * 43758.5453);
		} else {
			noise_val = vec3(fract(sin(dot(noise_coords, vec2(12.9898, 78.233)) + v_glitch_field.w) * 43758.5453));
		}
		col += (noise_val - 0.5) * v_dyn_pack2.z;
	}

	col = mask(col, FRAGCOORD.xy * v_time_pack2.w);

	if (use_auto_exposure) {
		float luma = dot(col, HUE_LUMA);
		col = mix(col, vec3(1.0), smoothstep(exposure_threshold, 1.0, luma) * exposure_intensity);
	}

	if (use_color_quantization) {
		col = floor(col * color_levels) / color_levels;
	}

	// --- FEATURE: 1D GRADIENT MAPPING / DUOTONE ---
	if (use_gradient_map) {
		float luma = dot(col, HUE_LUMA);
		col = textureLod(gradient_texture, vec2(clamp(luma, 0.0, 1.0), 0.0), 0.0).rgb;
	}

	if (v_dyn_pack2.w > 0.0) {
		vec2 offX = vec2(bloom_blur_radius.x * tex_pixel_size.x, 0.0);
		vec2 offY = vec2(0.0, bloom_blur_radius.y * tex_pixel_size.y);
		
		vec3 raw_bloom = srgb_to_linear(texture(tex, warped_coords).rgb)
		               + srgb_to_linear(texture(tex, warped_coords + offX).rgb)
		               + srgb_to_linear(texture(tex, warped_coords - offX).rgb)
		               + srgb_to_linear(texture(tex, warped_coords + offY).rgb)
		               + srgb_to_linear(texture(tex, warped_coords - offY).rgb);
		
		col += max(raw_bloom * 0.2 - bloom_threshold, 0.0) * v_dyn_pack2.w; 
	}

    COLOR.rgb = linear_to_srgb(col);
}