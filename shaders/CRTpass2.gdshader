shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

group_uniforms Sec_Mask;
uniform int sec_mask_pattern : hint_enum("Dots:0", "Checkerboard:1", "Horizontal:2", "Vertical:3", "Crosshatch:4", "Texture:5") = 0;
uniform float sec_mask_scale : hint_range(0.1, 50.0) = 10.0;
uniform float sec_mask_smoothness : hint_range(0.0, 1.0) = 0.1;
uniform bool sec_mask_invert = false;
uniform sampler2D sec_mask_tex : hint_default_white;
uniform float aspect : hint_range(0.5, 2.0) = 0.75; 

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

vec3 shift_hue(vec3 color, float shift) {
	float c = cos(shift);
	float s = sin(shift);
	vec3 col0 = HUE_LUMA + HUE_V1 * c + HUE_U1 * s;
	vec3 col1 = HUE_LUMA + HUE_V2 * c + HUE_U2 * s;
	vec3 col2 = HUE_LUMA + HUE_V3 * c + HUE_U3 * s;
	return clamp(vec3(dot(color, col0), dot(color, col1), dot(color, col2)), 0.0, 1.0);
}

float get_secondary_mask(vec2 uv) {
	float val = 0.0;
	vec2 scaled = ((uv - 0.5) * vec2(aspect, 1.0) + 0.5) * sec_mask_scale;
	
	if (sec_mask_pattern == 0) {
		val = smoothstep(0.5 + sec_mask_smoothness, 0.5 - sec_mask_smoothness, length(fract(scaled) - 0.5));
	} else if (sec_mask_pattern == 1) {
		float chk = sin(scaled.x * PI) * sin(scaled.y * PI);
		val = smoothstep(-sec_mask_smoothness - 0.001, sec_mask_smoothness + 0.001, chk);
	} else if (sec_mask_pattern == 2) {
		val = smoothstep(0.5 + sec_mask_smoothness, 0.5 - sec_mask_smoothness, abs(fract(scaled.y) - 0.5) * 2.0);
	} else if (sec_mask_pattern == 3) {
		val = smoothstep(0.5 + sec_mask_smoothness, 0.5 - sec_mask_smoothness, abs(fract(scaled.x) - 0.5) * 2.0);
	} else if (sec_mask_pattern == 4) {
		float d1 = abs(fract(scaled.x + scaled.y) - 0.5) * 2.0;
		float d2 = abs(fract(scaled.x - scaled.y) - 0.5) * 2.0;
		val = max(smoothstep(0.5 + sec_mask_smoothness, 0.5 - sec_mask_smoothness, d1),
				  smoothstep(0.5 + sec_mask_smoothness, 0.5 - sec_mask_smoothness, d2));
	} else if (sec_mask_pattern == 5) {
		val = texture(sec_mask_tex, uv).r;
		val = smoothstep(0.5 - sec_mask_smoothness, 0.5 + sec_mask_smoothness, val);
	}
	return sec_mask_invert ? 1.0 - val : val;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	float mask_val = get_secondary_mask(uv);
	vec4 base_col = texture(SCREEN_TEXTURE, uv);
	
	if (mask_val > 0.0) {
		vec2 tex_size = vec2(textureSize(SCREEN_TEXTURE, 0));
		vec2 tex_pixel_size = 1.0 / tex_size;
		vec2 warped_uv = uv;

		// --- SPATIAL DISTORTION FX ---
		if (sec_use_wobble) {
			warped_uv.x += cos(TIME * TAU * sec_wobble_speed) * sec_wobble_strength * 0.000122;
		}
		
		if (sec_use_interlaced_jitter) {
			float row_id = floor(warped_uv.y * tex_size.y);
			warped_uv.x += ((int(row_id) & 1) == 0 ? 1.0 : -1.0) * sin(TIME * sec_jitter_speed + row_id * 1.5) * sec_jitter_strength;
		}

		// --- SHARPNESS / BLUR ESTIMATION ---
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

		// --- COLOR CORRECTION ---
		if (sec_hue_shift > 0.0) col = shift_hue(col, sec_hue_shift);
		col = mix(vec3(dot(col, HUE_LUMA)), col, sec_saturation);
		col *= sec_brightness;
		col = mix(col, clamp((col - 0.5) * sec_contrast + 0.5, 0.0, 1.0), 1.0);

		// --- SWEEP STRIPE ---
		if (sec_use_sweep) {
			float c = cos(sec_sweep_angle);
			float s = sin(sec_sweep_angle);
			vec2 sec_rot = vec2(
				(warped_uv.x - 0.5) * c - (warped_uv.y - 0.5) * s,
				(warped_uv.x - 0.5) * s + (warped_uv.y - 0.5) * c
			) + 0.5;
			
			float margin = sec_sweep_width * 1.5;
			float pos = -margin + fract((TIME * sec_sweep_speed) / sec_sweep_interval + sec_sweep_offset) * (1.0 + margin * 2.0);
			float norm_dist = abs(sec_rot.y - pos) / (sec_sweep_width * 0.5);
			
			if (norm_dist <= 1.0) {
				float t = clamp((1.0 - norm_dist) / 0.3, 0.0, 1.0);
				float sec_stripe_factor = t * t * (3.0 - 2.0 * t);
				
				col = shift_hue(col, sec_sweep_hue * sec_stripe_factor);
				col *= 1.0 + sec_stripe_factor * (sec_sweep_brightness - 1.0);
				col = mix(vec3(dot(col, HUE_LUMA)), col, 1.0 + sec_stripe_factor * (sec_sweep_saturation - 1.0));
			}
		}

		// --- ECHO ---
		if (sec_use_echo) {
			col += texture(SCREEN_TEXTURE, warped_uv - vec2(sec_echo_offset, 0.0)).rgb * sec_echo_strength;
		}

		// --- DOT CRAWL ---
		if (sec_use_dot_crawl) {
			col += length(col - texture(SCREEN_TEXTURE, warped_uv + vec2(tex_pixel_size.x, 0.0)).rgb) * sin(FRAGCOORD.x * PI) * sin(FRAGCOORD.y * PI + TIME * sec_dot_crawl_speed) * sec_dot_crawl_strength;
		}

		// --- ROLLING INTERFERENCE ---
		if (sec_use_roll) {
			col *= 1.0 + smoothstep(0.8, 1.0, sin(warped_uv.y * sec_roll_size - TIME * sec_roll_speed)) * sec_roll_strength;
		}

		// --- INTERLACED FLICKER ---
		if (sec_use_interlaced_flicker) {
			int iy = int(warped_uv.y * tex_size.y);
			int field = int(TIME * 30.0) & 1; 
			col *= 1.0 - float((iy & 1) ^ field) * sec_interlaced_strength;
		}

		// --- STATIC NOISE ---
		if (sec_use_noise) {
			vec2 noise_coords = FRAGCOORD.xy;
			vec3 noise_val;
			if (sec_chroma_noise) {
				noise_val = fract(sin(vec3(dot(noise_coords, vec2(12.9898, 78.233)), dot(noise_coords, vec2(39.346, 11.135)), dot(noise_coords, vec2(73.156, 52.235))) + TIME) * 43758.5453);
			} else {
				noise_val = vec3(fract(sin(dot(noise_coords, vec2(12.9898, 78.233)) + TIME) * 43758.5453));
			}
			col += (noise_val - 0.5) * sec_noise_strength;
		}

		// --- COMPOSITE ---
		COLOR = mix(base_col, vec4(clamp(col, 0.0, 1.0), 1.0), mask_val);
	} else {
		COLOR = base_col;
	}
}