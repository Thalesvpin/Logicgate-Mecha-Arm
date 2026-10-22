shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

group_uniforms Sec_Mask.Curve;
uniform bool sec_use_curve = false;
uniform float sec_curve : hint_range(0.0, 3.0) = 0.0;

group_uniforms Sec_Mask.Pattern;
uniform int sec_mask_pattern : hint_enum("Dots:0", "Checkerboard:1", "Horizontal:2", "Vertical:3", "Crosshatch:4", "Texture:5", "Diagonal Right:6", "Diagonal Left:7", "Hexagons:8", "Stipple Noise:9") = 0;
uniform float sec_mask_scale : hint_range(1.0, 100.0) = 20.0;
uniform float sec_mask_smoothness : hint_range(0.0, 1.0) = 0.1;
uniform bool sec_mask_invert = false;
uniform sampler2D sec_mask_tex : hint_default_white;
uniform float rect_aspect = 1.7778; 
uniform bool sec_mask_decouple_aspect = true;
uniform float sec_mask_custom_aspect = 1.0;

group_uniforms Sec_Mask.Color_Correction;
uniform float sec_hue_shift : hint_range(0.0, 6.28318) = 0.0;
uniform float sec_saturation : hint_range(0.0, 3.0) = 1.0;
uniform float sec_brightness : hint_range(0.0, 3.0) = 1.0;
uniform float sec_contrast : hint_range(0.0, 3.0) = 1.0;

group_uniforms Sec_Mask.FX_Sharpness;
uniform bool sec_use_sharpness = false;
uniform float sec_sharpness : hint_range(0.0, 2.0) = 1.0;

group_uniforms Sec_Mask.FX_Wobble;
uniform bool sec_use_wobble = false;
uniform float sec_wobble_strength : hint_range(0.0, 5.0) = 1.0;
uniform float sec_wobble_speed : hint_range(0.1, 10.0) = 1.0;

group_uniforms Sec_Mask.FX_Sweep_Stripe;
uniform bool sec_use_sweep = false;
uniform float sec_sweep_width : hint_range(0.01, 1.0) = 0.15;
uniform float sec_sweep_speed : hint_range(-5.0, 5.0) = 0.15;
uniform float sec_sweep_interval : hint_range(0.1, 10.0) = 3.0;
uniform float sec_sweep_offset : hint_range(0.0, 1.0) = 0.0;
uniform float sec_sweep_angle : hint_range(0.0, 6.28318) = 0.0;
uniform float sec_sweep_hue : hint_range(0.0, 6.28318) = 1.57;
uniform float sec_sweep_saturation : hint_range(0.0, 3.0) = 1.2;
uniform float sec_sweep_brightness : hint_range(0.0, 3.0) = 1.2;

group_uniforms Sec_Mask.FX_Echo;
uniform bool sec_use_echo = false;
uniform float sec_echo_strength : hint_range(0.0, 1.0) = 0.5;
uniform float sec_echo_offset : hint_range(-0.05, 0.05) = 0.015;

group_uniforms Sec_Mask.FX_Dot_Crawl;
uniform bool sec_use_dot_crawl = false;
uniform float sec_dot_crawl_strength : hint_range(0.0, 1.0) = 0.5;
uniform float sec_dot_crawl_speed : hint_range(0.0, 20.0) = 15.0;

group_uniforms Sec_Mask.FX_Interlaced_Flicker;
uniform bool sec_use_interlaced_flicker = false;
uniform float sec_interlaced_strength : hint_range(0.0, 1.0) = 0.5;

group_uniforms Sec_Mask.FX_Interlaced_Jitter;
uniform bool sec_use_interlaced_jitter = false;
uniform float sec_jitter_strength : hint_range(0.0, 0.05) = 0.005;
uniform float sec_jitter_speed : hint_range(0.1, 20.0) = 10.0;

group_uniforms Sec_Mask.FX_Rolling_Interfere;
uniform bool sec_use_roll = false;
uniform float sec_roll_strength : hint_range(0.0, 1.0) = 0.1;
uniform float sec_roll_speed : hint_range(-10.0, 10.0) = 2.0;
uniform float sec_roll_size : hint_range(0.0, 100.0) = 15.0;

group_uniforms Sec_Mask.FX_Static_Noise;
uniform bool sec_use_noise = false;
uniform float sec_noise_strength : hint_range(0.0, 0.5) = 0.1;
uniform bool sec_chroma_noise = false;

group_uniforms;

const vec3 HUE_LUMA = vec3(0.299, 0.587, 0.114);
const vec3 HUE_V1 = vec3(0.701, -0.587, -0.114);
const vec3 HUE_V2 = vec3(-0.299, 0.413, -0.114);
const vec3 HUE_V3 = vec3(-0.299, -0.587, 0.886);
const vec3 HUE_U1 = vec3(0.168, 0.330, -0.497);
const vec3 HUE_U2 = vec3(0.328, -0.335, 0.007);
const vec3 HUE_U3 = vec3(-1.250, 1.050, 0.200);

varying flat float v_sec_wobble;
varying flat vec4 v_sec_stripe_calc;
varying flat vec4 v_sec_time_data; 
varying flat vec4 v_sec_scales;    
varying flat vec4 v_sec_cam_bc;
varying flat mat3 v_sec_hue_mat;

void vertex() {
	if (sec_use_wobble) {
		v_sec_wobble = cos(TIME * TAU * sec_wobble_speed) * sec_wobble_strength * 0.000122;
	} else {
		v_sec_wobble = 0.0;
	}

	if (sec_use_sweep) {
		float margin = sec_sweep_width * 1.5;
		v_sec_stripe_calc.x = -margin + fract((TIME * sec_sweep_speed) / sec_sweep_interval + sec_sweep_offset) * (1.0 + margin * 2.0);
		v_sec_stripe_calc.y = cos(sec_sweep_angle);
		v_sec_stripe_calc.z = sin(sec_sweep_angle);
		v_sec_stripe_calc.w = 1.0 / max(0.0001, sec_sweep_width * 0.5);
	} else {
		v_sec_stripe_calc = vec4(0.0);
	}

	v_sec_time_data = vec4(
		TIME * sec_jitter_speed, 
		TIME * sec_dot_crawl_speed, 
		TIME * sec_roll_speed, 
		float(int(TIME * 30.0) & 1)
	);
	
	float asp = sec_mask_decouple_aspect ? sec_mask_custom_aspect : rect_aspect;
	
	v_sec_scales.xy = vec2(asp, 1.0) / max(sec_mask_scale, 0.001);
	v_sec_scales.zw = vec2(rect_aspect, 1.0 / rect_aspect);
	
	v_sec_cam_bc.xy = vec2(length(CANVAS_MATRIX[0].xy), length(CANVAS_MATRIX[1].xy));
	v_sec_cam_bc.z = sec_brightness * sec_contrast;
	v_sec_cam_bc.w = 0.5 - 0.5 * sec_contrast;

	if (sec_hue_shift > 0.0001) {
		float c = cos(sec_hue_shift);
		float s = sin(sec_hue_shift);
		v_sec_hue_mat = mat3(
			HUE_LUMA + HUE_V1 * c + HUE_U1 * s,
			HUE_LUMA + HUE_V2 * c + HUE_U2 * s,
			HUE_LUMA + HUE_V3 * c + HUE_U3 * s
		);
	} else {
		v_sec_hue_mat = mat3(1.0);
	}
}

vec3 shift_hue_dynamic(vec3 color, float shift) {
	float c = cos(shift);
	float s = sin(shift);
	vec3 col0 = HUE_LUMA + HUE_V1 * c + HUE_U1 * s;
	vec3 col1 = HUE_LUMA + HUE_V2 * c + HUE_U2 * s;
	vec3 col2 = HUE_LUMA + HUE_V3 * c + HUE_U3 * s;
	return clamp(vec3(dot(color, col0), dot(color, col1), dot(color, col2)), 0.0, 1.0);
}

vec4 get_secondary_mask(vec2 screen_uv, vec2 screen_dims) {
	vec2 process_uv = screen_uv;
	
	if (sec_use_curve) {
		process_uv -= 0.5;
		process_uv.x *= v_sec_scales.z;
		process_uv /= 1.0 - sec_curve * (dot(process_uv, process_uv) - 0.25);
		process_uv.x *= v_sec_scales.w;
		process_uv += 0.5;
	}

	vec2 scaled = process_uv * (screen_dims / max(v_sec_cam_bc.xy, vec2(0.0001))) * v_sec_scales.xy;
	
	float val = 0.0;
	vec3 tint = vec3(1.0);
	
	switch (sec_mask_pattern) {
		case 0:
			val = smoothstep(0.5 + sec_mask_smoothness, 0.5 - sec_mask_smoothness, length(fract(scaled) - 0.5));
			break;
		case 1:
			val = smoothstep(-sec_mask_smoothness - 0.001, sec_mask_smoothness + 0.001, sin(scaled.x * PI) * sin(scaled.y * PI));
			break;
		case 2:
			val = smoothstep(0.5 + sec_mask_smoothness, 0.5 - sec_mask_smoothness, abs(fract(scaled.y) - 0.5) * 2.0);
			break;
		case 3:
			val = smoothstep(0.5 + sec_mask_smoothness, 0.5 - sec_mask_smoothness, abs(fract(scaled.x) - 0.5) * 2.0);
			break;
		case 4:
			val = max(smoothstep(0.5 + sec_mask_smoothness, 0.5 - sec_mask_smoothness, abs(fract(scaled.x + scaled.y) - 0.5) * 2.0), smoothstep(0.5 + sec_mask_smoothness, 0.5 - sec_mask_smoothness, abs(fract(scaled.x - scaled.y) - 0.5) * 2.0));
			break;
		case 5: {
			vec4 tex_val = texture(sec_mask_tex, scaled);
			val = smoothstep(0.5 - sec_mask_smoothness, 0.5 + sec_mask_smoothness, tex_val.r);
			tint = tex_val.rgb;
			break;
		}
		case 6:
			val = smoothstep(0.5 + sec_mask_smoothness, 0.5 - sec_mask_smoothness, abs(fract(scaled.x + scaled.y) - 0.5) * 2.0);
			break;
		case 7:
			val = smoothstep(0.5 + sec_mask_smoothness, 0.5 - sec_mask_smoothness, abs(fract(scaled.x - scaled.y) - 0.5) * 2.0);
			break;
		case 8: {
			vec2 h = scaled * vec2(1.0, 1.7320508);
			vec2 a = mod(h, 1.0) - 0.5;
			vec2 b = mod(h - vec2(0.5), 1.0) - 0.5;
			val = smoothstep(0.5 + sec_mask_smoothness, 0.5 - sec_mask_smoothness, length(dot(a, a) < dot(b, b) ? a : b) * 2.0);
			break;
		}
		case 9:
			val = smoothstep(0.5 - sec_mask_smoothness, 0.5 + sec_mask_smoothness, fract(sin(dot(floor(scaled), vec2(12.9898, 78.233))) * 43758.5453));
			break;
	}
	
	return vec4(tint, sec_mask_invert ? 1.0 - val : val);
}

void fragment() {
	vec2 screen_uv = SCREEN_UV;
	vec2 tex_pixel_size = SCREEN_PIXEL_SIZE;
	vec2 tex_size = 1.0 / tex_pixel_size;
	
	vec4 m_data = get_secondary_mask(screen_uv, tex_size);
	vec4 base_col = texture(SCREEN_TEXTURE, screen_uv);
	
	if (m_data.a <= 0.0) {
		COLOR = base_col;
	} else {
		vec2 warped_uv = screen_uv;

		if (sec_use_wobble) warped_uv.x += v_sec_wobble;
		if (sec_use_interlaced_jitter) {
			float row_id = floor(warped_uv.y * tex_size.y);
			warped_uv.x += ((int(row_id) & 1) == 0 ? 1.0 : -1.0) * sin(v_sec_time_data.x + row_id * 1.5) * sec_jitter_strength;
		}

		vec3 col;
		if (sec_use_sharpness) {
			vec3 c = texture(SCREEN_TEXTURE, warped_uv).rgb;
			vec3 u = texture(SCREEN_TEXTURE, warped_uv + vec2(0.0, -tex_pixel_size.y)).rgb;
			vec3 d = texture(SCREEN_TEXTURE, warped_uv + vec2(0.0, tex_pixel_size.y)).rgb;
			vec3 l = texture(SCREEN_TEXTURE, warped_uv + vec2(-tex_pixel_size.x, 0.0)).rgb;
			vec3 r = texture(SCREEN_TEXTURE, warped_uv + vec2(tex_pixel_size.x, 0.0)).rgb;
			col = mix(c, c + (c - (u + d + l + r) * 0.25), sec_sharpness);
		} else {
			col = texture(SCREEN_TEXTURE, warped_uv).rgb;
		}

		if (sec_hue_shift > 0.0001) col = clamp(vec3(dot(col, v_sec_hue_mat[0]), dot(col, v_sec_hue_mat[1]), dot(col, v_sec_hue_mat[2])), 0.0, 1.0);
		if (abs(sec_saturation - 1.0) > 0.001) col = mix(vec3(dot(col, HUE_LUMA)), col, sec_saturation);
		
		if (abs(v_sec_cam_bc.z - 1.0) > 0.001 || abs(v_sec_cam_bc.w) > 0.001) {
			col = clamp(col * v_sec_cam_bc.z + v_sec_cam_bc.w, 0.0, 1.0);
		}

		if (sec_use_sweep) {
			vec2 sec_rot = vec2((warped_uv.x - 0.5) * v_sec_stripe_calc.y - (warped_uv.y - 0.5) * v_sec_stripe_calc.z, (warped_uv.x - 0.5) * v_sec_stripe_calc.z + (warped_uv.y - 0.5) * v_sec_stripe_calc.y) + 0.5;
			float norm_dist = abs(sec_rot.y - v_sec_stripe_calc.x) * v_sec_stripe_calc.w;
			if (norm_dist <= 1.0) {
				float t = clamp((1.0 - norm_dist) / 0.3, 0.0, 1.0);
				float sec_stripe_factor = t * t * (3.0 - 2.0 * t);
				col = shift_hue_dynamic(col, sec_sweep_hue * sec_stripe_factor);
				col *= 1.0 + sec_stripe_factor * (sec_sweep_brightness - 1.0);
				col = mix(vec3(dot(col, HUE_LUMA)), col, 1.0 + sec_stripe_factor * (sec_sweep_saturation - 1.0));
			}
		}

		if (sec_use_echo) col += texture(SCREEN_TEXTURE, warped_uv - vec2(sec_echo_offset, 0.0)).rgb * sec_echo_strength;
		if (sec_use_dot_crawl) col += length(col - texture(SCREEN_TEXTURE, warped_uv + vec2(tex_pixel_size.x, 0.0)).rgb) * sin(FRAGCOORD.x * PI) * sin(FRAGCOORD.y * PI + v_sec_time_data.y) * sec_dot_crawl_strength;
		if (sec_use_roll) col *= 1.0 + smoothstep(0.8, 1.0, sin(warped_uv.y * sec_roll_size - v_sec_time_data.z)) * sec_roll_strength;
		if (sec_use_interlaced_flicker) {
			int iy = int(warped_uv.y * tex_size.y);
			col *= 1.0 - float((iy & 1) ^ int(v_sec_time_data.w)) * sec_interlaced_strength;
		}
		if (sec_use_noise) {
			vec2 noise_coords = FRAGCOORD.xy;
			vec3 noise_val;
			if (sec_chroma_noise) {
				vec3 noise_dots = vec3(dot(noise_coords, vec2(12.9898, 78.233)), dot(noise_coords, vec2(39.346, 11.135)), dot(noise_coords, vec2(73.156, 52.235)));
				noise_val = fract(sin(noise_dots + TIME) * 43758.5453);
			} else {
				noise_val = vec3(fract(sin(dot(noise_coords, vec2(12.9898, 78.233)) + TIME) * 43758.5453));
			}
			col += (noise_val - 0.5) * sec_noise_strength;
		}

		col *= m_data.rgb;
		COLOR = mix(base_col, vec4(clamp(col, 0.0, 1.0), 1.0), m_data.a);
	}
}