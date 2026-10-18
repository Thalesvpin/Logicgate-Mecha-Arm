// CRT Shader by Harrison Allen
// V12 - Master Optimized, Proportional Resolution Independence, Optional Scanline Toggle

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
uniform float min_scanline_thickness : hint_range(0.25, 1.0) = 0.5;

group_uniforms Interlaced_Flicker;
uniform float interlaced_strength : hint_range(0.0, 1.0) = 0.0;
uniform bool animate_interlaced = false;
uniform sampler2D interlaced_curve;
uniform float interlaced_anim_speed = 1.0;
uniform float interlaced_anim_amplitude = 1.0;
uniform float interlaced_fps : hint_range(1.0, 60.0) = 30.0;

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

group_uniforms Signal_Loss_Glitch;
uniform float glitch_strength : hint_range(0.0, 1.0) = 0.0;
uniform bool animate_glitch = false;
uniform sampler2D glitch_curve;
uniform float glitch_anim_speed = 1.0;
uniform float glitch_anim_amplitude = 1.0;
uniform float glitch_rate : hint_range(0.0, 1.0) = 0.05;
uniform float glitch_size : hint_range(0.01, 1.0) = 0.05;

group_uniforms Static_Noise;
uniform float noise_strength : hint_range(0.0, 0.5) = 0.03;
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
uniform float bloom_blur_radius : hint_range(0.0, 10.0) = 4.0;

group_uniforms;

varying flat float v_wobble;
varying flat vec4 v_dyn_pack1; 
varying flat vec4 v_dyn_pack2; 
varying flat vec4 v_glitch_field; 

const float TWO_THIRD_PI = 2.09439510239;
const float FOUR_THIRD_PI = 4.18879020479;

void vertex()
{
	float _wobble = wobble_strength;
	if (animate_wobble) _wobble += textureLod(wobble_curve, vec2(fract(TIME * wobble_anim_speed), 0.0), 0.0).r * wobble_anim_amplitude;
	v_wobble = cos(TIME * TAU * 15.0) * _wobble / 8192.0;

	v_dyn_pack1.x = color_offset;
	if (animate_color_offset) v_dyn_pack1.x += textureLod(color_offset_curve, vec2(fract(TIME * color_offset_anim_speed), 0.0), 0.0).r * color_offset_anim_amplitude;

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

	float glitch_time = floor(TIME * 20.0);
	float r1 = fract(sin(glitch_time * 91.2228) * 43758.5453);
	float is_glitching = step(1.0 - glitch_rate, r1); 
	
	v_glitch_field.x = fract(sin(glitch_time * 50.481) * 43758.5453);
	float r3 = fract(sin(glitch_time * 125.391) * 43758.5453);
	v_glitch_field.y = is_glitching * (r3 - 0.5) * v_dyn_pack2.y;
	
	v_glitch_field.z = mod(floor(TIME * interlaced_fps), 2.0);
	v_glitch_field.w = TIME * 91.2228;
}

vec2 warp(vec2 uv, float _aspect, float _curve)
{
	vec2 aspect_scale = vec2(_aspect, 1.0);
	uv = (uv - 0.5) / aspect_scale;
	float warping = dot(uv, uv) * _curve - (_curve * 0.25);
	return (uv / (1.0 - warping)) * aspect_scale + 0.5;
}

vec3 linear_to_srgb(vec3 col)
{
	return mix(
		(pow(col, vec3(1.0 / 2.4)) * 1.055) - 0.055,
		col * 12.92,
		lessThan(col, vec3(0.0031318))
	);
}

vec3 srgb_to_linear(vec3 col)
{
	return mix(
		pow((col + 0.055) / 1.055, vec3(2.4)),
		col / 12.92,
		lessThan(col, vec3(0.04045))
	);
}

vec3 sample_image(vec2 uv)
{
	uv *= vec2(textureSize(tex, 0));

	int ix = int(floor(uv.x));
	float fx = float(ix);

	float diff_base = uv.x - 0.5 - fx;
	vec3 diff = vec3(diff_base - v_dyn_pack1.x, diff_base, diff_base + v_dyn_pack1.x);

	vec3 weight_a = smoothstep(1.0, 0.0, (diff + 2.0) * v_dyn_pack1.y);
	vec3 weight_b = smoothstep(1.0, 0.0, (diff + 1.0) * v_dyn_pack1.y);
	vec3 weight_c = smoothstep(1.0, 0.0, abs(diff) * v_dyn_pack1.y);
	vec3 weight_d = smoothstep(1.0, 0.0, (1.0 - diff) * v_dyn_pack1.y);
	vec3 weight_e = smoothstep(1.0, 0.0, (2.0 - diff) * v_dyn_pack1.y);

	vec3 weight_scaler = vec3(1.0) / (weight_a + weight_b + weight_c + weight_d + weight_e);

	if (use_scanlines) 
	{
		// 10-Tap Heavy Branch (Active only when toggled ON)
		int iy = int(uv.y + 0.5) - 1;
		int lower_y = iy + 1;

		vec3 upper_a = srgb_to_linear(texelFetch(tex, ivec2(ix - 2, iy), 0).rgb);
		vec3 upper_b = srgb_to_linear(texelFetch(tex, ivec2(ix - 1, iy), 0).rgb);
		vec3 upper_c = srgb_to_linear(texelFetch(tex, ivec2(ix,     iy), 0).rgb);
		vec3 upper_d = srgb_to_linear(texelFetch(tex, ivec2(ix + 1, iy), 0).rgb);
		vec3 upper_e = srgb_to_linear(texelFetch(tex, ivec2(ix + 2, iy), 0).rgb);

		vec3 lower_a = srgb_to_linear(texelFetch(tex, ivec2(ix - 2, lower_y), 0).rgb);
		vec3 lower_b = srgb_to_linear(texelFetch(tex, ivec2(ix - 1, lower_y), 0).rgb);
		vec3 lower_c = srgb_to_linear(texelFetch(tex, ivec2(ix,     lower_y), 0).rgb);
		vec3 lower_d = srgb_to_linear(texelFetch(tex, ivec2(ix + 1, lower_y), 0).rgb);
		vec3 lower_e = srgb_to_linear(texelFetch(tex, ivec2(ix + 2, lower_y), 0).rgb);

		vec3 upper_col = (upper_a * weight_a + upper_b * weight_b + upper_c * weight_c + upper_d * weight_d + upper_e * weight_e) * weight_scaler * scanline_brightness;
		vec3 lower_col = (lower_a * weight_a + lower_b * weight_b + lower_c * weight_c + lower_d * weight_d + lower_e * weight_e) * weight_scaler * scanline_brightness;

		vec3 upper_thickness = mix(vec3(min_scanline_thickness), vec3(1.0), upper_col);
		vec3 lower_thickness = mix(vec3(min_scanline_thickness), vec3(1.0), lower_col);
		
		float sawtooth = (uv.y + 0.5) - float(iy);

		vec3 upper_line = smoothstep(1.0, 0.0, vec3(sawtooth) / upper_thickness) * upper_col / upper_thickness;
		vec3 lower_line = smoothstep(1.0, 0.0, vec3(1.0 - sawtooth) / lower_thickness) * lower_col / lower_thickness;
		
		float upper_field = mod(float(iy), 2.0);
		float lower_field = 1.0 - upper_field;
		
		upper_line *= 1.0 - (abs(upper_field - v_glitch_field.z) * v_dyn_pack1.w);
		lower_line *= 1.0 - (abs(lower_field - v_glitch_field.z) * v_dyn_pack1.w);

		return upper_line + lower_line;
	} 
	else 
	{
		// 5-Tap Lightweight Branch (Active when toggled OFF)
		int iy = int(floor(uv.y));
		
		vec3 upper_a = srgb_to_linear(texelFetch(tex, ivec2(ix - 2, iy), 0).rgb);
		vec3 upper_b = srgb_to_linear(texelFetch(tex, ivec2(ix - 1, iy), 0).rgb);
		vec3 upper_c = srgb_to_linear(texelFetch(tex, ivec2(ix,     iy), 0).rgb);
		vec3 upper_d = srgb_to_linear(texelFetch(tex, ivec2(ix + 1, iy), 0).rgb);
		vec3 upper_e = srgb_to_linear(texelFetch(tex, ivec2(ix + 2, iy), 0).rgb);

		vec3 color = (upper_a * weight_a + upper_b * weight_b + upper_c * weight_c + upper_d * weight_d + upper_e * weight_e) * weight_scaler;
		
		float field = mod(float(iy), 2.0);
		color *= 1.0 - (abs(field - v_glitch_field.z) * v_dyn_pack1.w);

		return color;
	}
}

vec4 generate_mask(vec2 coords)
{
	switch (mask_type)
	{
		case 1: { 
			float x_phase = coords.x * TWO_THIRD_PI;
			vec3 rgb = 0.5 + 0.5 * cos(x_phase - vec3(0.0, TWO_THIRD_PI, FOUR_THIRD_PI));
			float y_wave = 0.5 + 0.5 * cos(coords.y * PI);
			return vec4(rgb * y_wave, 0.25);
		}
		case 2: { 
			float x_phase = coords.x * PI;
			vec3 grille = mix(vec3(0.0, 1.0, 0.0), vec3(1.0, 0.0, 1.0), 0.5 + 0.5 * cos(x_phase));
			return vec4(grille, 0.5);
		}
		case 3: { 
			float x_phase = coords.x * TWO_THIRD_PI;
			vec3 rgb = clamp(0.5 + 0.8 * cos(x_phase - vec3(0.0, TWO_THIRD_PI, FOUR_THIRD_PI)), 0.0, 1.0);
			return vec4(rgb, 0.25);
		}
		case 4: { 
			float x_phase = coords.x * TWO_THIRD_PI;
			vec3 rgb = 0.5 + 0.5 * cos(x_phase - vec3(0.0, TWO_THIRD_PI, FOUR_THIRD_PI));
			return vec4(rgb, 0.3125);
		}
		case 5: { 
			float x_phase = coords.x * TWO_THIRD_PI;
			vec3 rgb = 0.5 + 0.5 * cos(x_phase - vec3(0.0, TWO_THIRD_PI, FOUR_THIRD_PI));
			float col_idx = floor(coords.x / 1.5);
			float y_phase = (coords.y + mod(col_idx, 2.0) * 0.5) * TAU;
			float slot_y = 0.5 + 0.5 * cos(y_phase);
			return vec4(rgb * slot_y, 0.375);
		}
		case 6: { 
			float line_group = mod(floor(coords.x), 3.0);
			float intensity = (line_group == 0.0) ? 0.6 : 1.0;
			return vec4(vec3(1.0), intensity);
		}
		default:
			return vec4(0.5);
	}
}

vec3 mask(vec3 linear_color, vec2 coords)
{
	vec4 mask = generate_mask(coords);
	
	linear_color *= mix(mask.w, 1.0, v_dyn_pack1.z);

	vec3 target_color = linear_color / mask.w;
	vec3 primary_col = clamp(target_color, 0.0, 1.0);
	
	vec3 highlights = target_color - primary_col;
	highlights /= (1.0 / mask.w) - 1.0;

	primary_col *= mask.rgb;
	primary_col += highlights * (1.0 - mask.rgb);

	return primary_col;
}

void fragment()
{
	vec2 warped_coords = warp(UV, aspect, curve);
	warped_coords.x += v_wobble;

	float glitch_band = step(abs(warped_coords.y - v_glitch_field.x), glitch_size);
	warped_coords.x += glitch_band * v_glitch_field.y;

	vec3 col = sample_image(warped_coords);

	float roll_line = sin(warped_coords.y * roll_size - TIME * roll_speed);
	col += col * smoothstep(0.8, 1.0, roll_line) * v_dyn_pack2.x;

	float noise_val = fract(sin(dot(warped_coords, vec2(12.9898, 78.233)) + v_glitch_field.w) * 43758.5453);
	col += (noise_val - 0.5) * v_dyn_pack2.z;

	vec2 normalized_coords = vec2(1080.0 * (SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x), 1080.0);
	vec2 mask_coords = warped_coords * normalized_coords / max(mask_scale, 0.01);
	col = mask(col, mask_coords);

	vec2 blur_offset = vec2(bloom_blur_radius) / vec2(textureSize(tex, 0));
	vec3 raw_bloom = srgb_to_linear(texture(tex, warped_coords).rgb);
	raw_bloom += srgb_to_linear(texture(tex, warped_coords + vec2(blur_offset.x, 0.0)).rgb);
	raw_bloom += srgb_to_linear(texture(tex, warped_coords + vec2(-blur_offset.x, 0.0)).rgb);
	raw_bloom += srgb_to_linear(texture(tex, warped_coords + vec2(0.0, blur_offset.y)).rgb);
	raw_bloom += srgb_to_linear(texture(tex, warped_coords + vec2(0.0, -blur_offset.y)).rgb);
	raw_bloom *= 0.2; 
	
	col += max(raw_bloom - vec3(bloom_threshold), vec3(0.0)) * v_dyn_pack2.w;

	COLOR.rgb = linear_to_srgb(col);
}