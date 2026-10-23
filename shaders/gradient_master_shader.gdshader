shader_type canvas_item;

// =============================================================================
// MAIN GROUP 1: Base Gradient
// =============================================================================
group_uniforms Base_Gradient;
uniform sampler2D gradient_texture : source_color, filter_linear, repeat_disable;
uniform int gradient_type : hint_enum("Horizontal", "Vertical", "Radial", "Mirrored") = 1;
uniform float gradient_rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform float gradient_scale : hint_range(0.1, 10.0) = 1.0;
uniform float gradient_smoothing : hint_range(0.0, 5.0) = 0.5;
uniform float gradient_offset : hint_range(-2.0, 2.0) = 0.0;
uniform bool repeat_gradient = false;

group_uniforms Base_Gradient.Pulsation_Effects;
uniform bool enable_pulsation = false;
uniform sampler2D base_pulse_curve : hint_default_black, filter_linear, repeat_disable;
uniform float animation_speed : hint_range(0.0, 10.0) = 1.0;
uniform float pulse_spatial_frequency : hint_range(0.0, 20.0) = 0.0;
uniform float pulse_min_offset : hint_range(-2.0, 2.0) = -0.5;
uniform float pulse_max_offset : hint_range(-2.0, 2.0) = 0.5;

group_uniforms Base_Gradient.Distortion;
uniform sampler2D noise_texture : repeat_enable, filter_linear;
uniform float distortion_strength : hint_range(0.0, 0.5) = 0.0;
uniform vec2 distortion_speed = vec2(0.1, 0.1);

group_uniforms Base_Gradient.Color_Grading;
uniform float base_color_steps : hint_range(0.0, 255.0) = 0.0; 
uniform float base_color_brightness : hint_range(-1.0, 1.0) = 0.0; 
uniform float base_color_contrast : hint_range(0.0, 3.0) = 1.0; 
uniform float base_color_saturation : hint_range(0.0, 3.0) = 1.0; 
uniform float base_color_hue_shift_speed : hint_range(-5.0, 5.0) = 0.0; 

// =============================================================================
// MAIN GROUP 2: Overlay Settings
// =============================================================================
group_uniforms Overlay_Settings;
uniform bool enable_overlay = false;
uniform int overlay_blend_mode : hint_enum("Normal", "Multiply", "Add", "Screen") = 0;

group_uniforms Overlay_Settings.Color;
uniform sampler2D overlay_gradient_texture : source_color, filter_linear, repeat_disable;
uniform int overlay_gradient_type : hint_enum("Horizontal", "Vertical", "Radial", "Mirrored") = 2;
uniform float overlay_gradient_rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform float overlay_gradient_scale : hint_range(0.1, 10.0) = 1.0;
uniform float overlay_gradient_smoothing : hint_range(0.0, 5.0) = 0.5;
uniform float overlay_gradient_offset : hint_range(-2.0, 2.0) = 0.0;
uniform bool overlay_repeat_gradient = false;

group_uniforms Overlay_Settings.Color_Pulsation;
uniform bool overlay_enable_pulsation = false;
uniform sampler2D overlay_color_pulse_curve : hint_default_black, filter_linear, repeat_disable;
uniform float overlay_animation_speed : hint_range(0.0, 10.0) = 1.0;
uniform float overlay_pulse_spatial_frequency : hint_range(0.0, 20.0) = 0.0;
uniform float overlay_pulse_min_offset : hint_range(-2.0, 2.0) = -0.5;
uniform float overlay_pulse_max_offset : hint_range(-2.0, 2.0) = 0.5;

group_uniforms Overlay_Settings.Opacity;
uniform bool enable_overlay_opacity = false;
uniform sampler2D overlay_opacity_texture : hint_default_white, filter_linear, repeat_disable; 
uniform int overlay_opacity_type : hint_enum("Horizontal", "Vertical", "Radial", "Mirrored") = 2;
uniform float overlay_opacity_rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform float overlay_opacity_scale : hint_range(0.1, 10.0) = 1.0;
uniform float overlay_opacity_smoothing : hint_range(0.0, 5.0) = 0.5;
uniform float overlay_opacity_offset : hint_range(-2.0, 2.0) = 0.0;
uniform bool overlay_opacity_repeat = false;

group_uniforms Overlay_Settings.Opacity_Pulsation;
uniform bool overlay_opacity_enable_pulsation = false;
uniform sampler2D overlay_opacity_pulse_curve : hint_default_black, filter_linear, repeat_disable;
uniform float overlay_opacity_animation_speed : hint_range(0.0, 10.0) = 1.0;
uniform float overlay_opacity_pulse_spatial_frequency : hint_range(0.0, 20.0) = 0.0;
uniform float overlay_opacity_pulse_min_offset : hint_range(-2.0, 2.0) = -0.5;
uniform float overlay_opacity_pulse_max_offset : hint_range(-2.0, 2.0) = 0.5;

// =============================================================================
// MAIN GROUP 3: Shape & Geometry
// =============================================================================
group_uniforms Shape_And_Geometry;
uniform vec4 corner_radii = vec4(0.0); // TL, TR, BR, BL
uniform bool use_beveled_corners = false; 

// =============================================================================
// MAIN GROUP 4: Outline Settings
// =============================================================================
group_uniforms Outline_Settings;
uniform bool enable_outline = false;
uniform float outline_width : hint_range(0.0, 100.0) = 2.0;
uniform float outline_blur : hint_range(0.0, 20.0) = 0.0;

uniform sampler2D outline_gradient_texture : source_color, filter_linear, repeat_disable;
uniform int outline_gradient_type : hint_enum("Horizontal", "Vertical", "Radial", "Mirrored") = 1;
uniform float outline_gradient_rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform float outline_gradient_scale : hint_range(0.1, 10.0) = 1.0;
uniform float outline_gradient_smoothing : hint_range(0.0, 5.0) = 0.5;
uniform float outline_gradient_offset : hint_range(-2.0, 2.0) = 0.0;
uniform bool outline_repeat_gradient = false;

group_uniforms Outline_Settings.Wobble_And_Dash;
uniform bool enable_wobble = false;
uniform float outline_wobble_amplitude : hint_range(0.0, 50.0) = 0.0; 
uniform float outline_wobble_frequency : hint_range(0.0, 50.0) = 10.0;
uniform float outline_wobble_speed : hint_range(-10.0, 10.0) = 1.0;
uniform bool enable_dash = false;
uniform int outline_dash_style : hint_enum("Radial", "Follow Shape") = 1;
uniform int outline_pattern : hint_enum("Solid / Standard Dash", "Circles", "Squares", "Custom Texture") = 0; 
uniform sampler2D outline_custom_pattern_texture : hint_default_white, filter_linear, repeat_enable; 
uniform float outline_dash_count : hint_range(0.0, 100.0) = 0.0; 
uniform float outline_dash_speed : hint_range(-10.0, 10.0) = 0.0;

group_uniforms Outline_Settings.Fade;
uniform float outline_fade_angle : hint_range(0.0, 360.0) = 0.0; 
uniform float outline_fade_intensity : hint_range(0.0, 1.0) = 0.0;

group_uniforms Outline_Settings.Pulsation_Effects;
uniform bool outline_enable_pulsation = false;
uniform sampler2D outline_pulse_curve : hint_default_black, filter_linear, repeat_disable;
uniform float outline_animation_speed : hint_range(0.0, 10.0) = 1.0;
uniform float outline_pulse_spatial_frequency : hint_range(0.0, 20.0) = 0.0;
uniform float outline_pulse_min_offset : hint_range(-2.0, 2.0) = -0.5;
uniform float outline_pulse_max_offset : hint_range(-2.0, 2.0) = 0.5;

group_uniforms Outline_Settings.Shine_1;
uniform bool outline_enable_shine = false;
uniform int outline_shine_style : hint_enum("Linear Sweep", "Follow Shape") = 1; 
uniform vec4 outline_shine_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_shine_intensity : hint_range(0.1, 10.0) = 1.0;
uniform sampler2D outline_shine_opacity_curve : hint_default_white, filter_linear, repeat_disable;
uniform float outline_shine_speed : hint_range(0.0, 10.0) = 1.0;
uniform float outline_shine_delay : hint_range(0.0, 10.0) = 2.0; 
uniform float outline_shine_width : hint_range(0.01, 1.0) = 0.15;
uniform float outline_shine_softness : hint_range(0.0, 1.0) = 0.5; 
uniform float outline_shine_angle : hint_range(0.0, 360.0) = 45.0; 
uniform bool outline_shine_reverse = false;

group_uniforms Outline_Settings.Shine_2;
uniform bool outline_enable_shine_2 = false; 
uniform int outline_shine_2_style : hint_enum("Linear Sweep", "Follow Shape") = 1;
uniform vec4 outline_shine_2_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_shine_2_intensity : hint_range(0.1, 10.0) = 1.0;
uniform sampler2D outline_shine_2_opacity_curve : hint_default_white, filter_linear, repeat_disable;
uniform float outline_shine_2_speed : hint_range(0.0, 10.0) = 1.0;
uniform float outline_shine_2_delay : hint_range(0.0, 10.0) = 2.0; 
uniform float outline_shine_2_width : hint_range(0.01, 1.0) = 0.15;
uniform float outline_shine_2_softness : hint_range(0.0, 1.0) = 0.5; 
uniform float outline_shine_2_angle : hint_range(0.0, 360.0) = 135.0;
uniform bool outline_shine_2_reverse = false;

group_uniforms Outline_Settings.Color_Grading;
uniform float outline_color_steps : hint_range(0.0, 255.0) = 0.0; 
uniform float outline_color_brightness : hint_range(-1.0, 1.0) = 0.0; 
uniform float outline_color_contrast : hint_range(0.0, 3.0) = 1.0; 
uniform float outline_color_saturation : hint_range(0.0, 3.0) = 1.0; 
uniform float outline_color_hue_shift_speed : hint_range(-5.0, 5.0) = 0.0; 

// =============================================================================
// MAIN GROUP 5: Global Polish & FX
// =============================================================================
group_uniforms Global_Polish_And_FX.Scanlines;
uniform bool scanline_base_only = false;
uniform float scanline_rotation : hint_range(0.0, 360.0) = 0.0;
uniform float scanline_speed : hint_range(-10.0, 10.0) = 0.0;
uniform float scanline_density : hint_range(0.0, 200.0) = 0.0; 
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.0; 

group_uniforms Global_Polish_And_FX.Render;
uniform float gamma_correction : hint_range(0.1, 3.0) = 1.0;  
uniform bool enable_dithering = true;

// =============================================================================
// VARYINGS (Packed & Vectorized)
// =============================================================================
group_uniforms; 

varying vec2 local_pos;
varying flat vec4 v_trig_1; 
varying flat vec4 v_trig_2; 
varying flat vec4 v_trig_3; 
varying flat vec4 v_trig_4; // xy: fade, zw: scanlines
varying flat vec4 v_inv_scales; 
varying flat vec4 v_shine_data; 
varying flat vec4 v_shine_2_data; 
varying flat vec4 v_edges; 

// Baked Color Grading
varying flat mat3 v_base_cg_mat;
varying flat vec3 v_base_cg_off;
varying flat mat3 v_out_cg_mat;
varying flat vec3 v_out_cg_off;

void get_cg_params(float bright, float cont, float sat, float hue_speed, out mat3 out_mat, out vec3 out_off) {
	mat3 sat_m = mat3(
		vec3(0.299 + 0.701*sat, 0.299 - 0.299*sat, 0.299 - 0.299*sat),
		vec3(0.587 - 0.587*sat, 0.587 + 0.413*sat, 0.587 - 0.587*sat),
		vec3(0.114 - 0.114*sat, 0.114 - 0.114*sat, 0.114 + 0.886*sat)
	);
	
	float a = TIME * hue_speed;
	float c = cos(a), s = sin(a);
	mat3 hue_m = mat3(
		vec3(0.213 + c*0.787 - s*0.213, 0.213 - c*0.213 + s*0.143, 0.213 - c*0.213 - s*0.787),
		vec3(0.715 - c*0.715 - s*0.715, 0.715 + c*0.285 + s*0.140, 0.715 - c*0.715 + s*0.715),
		vec3(0.072 - c*0.072 + s*0.928, 0.072 - c*0.072 - s*0.283, 0.072 + c*0.928 + s*0.072)
	);
	
	out_mat = hue_m * sat_m * cont;
	out_off = hue_m * sat_m * vec3(0.5 - 0.5 * cont + bright);
}

void vertex() {
	float exp = 2.0; 
	if (enable_outline) exp += outline_width + outline_blur;
	float exp_double = exp * 2.0;
	
	VERTEX += (UV - 0.5) * exp_double;
	local_pos = VERTEX; 

	v_trig_1 = vec4(sin(radians(gradient_rotation_degrees)), cos(radians(gradient_rotation_degrees)), 
					sin(radians(overlay_gradient_rotation_degrees)), cos(radians(overlay_gradient_rotation_degrees)));
	v_trig_2 = vec4(sin(radians(overlay_opacity_rotation_degrees)), cos(radians(overlay_opacity_rotation_degrees)), 
					sin(radians(outline_gradient_rotation_degrees)), cos(radians(outline_gradient_rotation_degrees)));
	v_trig_3 = vec4(sin(radians(outline_shine_angle)), cos(radians(outline_shine_angle)), 
					sin(radians(outline_shine_2_angle)), cos(radians(outline_shine_2_angle)));
	
	v_trig_4 = vec4(sin(radians(outline_fade_angle)), cos(radians(outline_fade_angle)),
					sin(radians(scanline_rotation)), cos(radians(scanline_rotation)));

	v_inv_scales = 1.0 / max(vec4(gradient_scale, overlay_gradient_scale, overlay_opacity_scale, outline_gradient_scale), 0.001);

	float s1_bound = outline_shine_style == 0 ? 0.75 + outline_shine_width : 0.0;
	float s1_s = outline_shine_style == 0 ? 0.5 - s1_bound : 0.0;
	float s1_e = outline_shine_style == 0 ? 0.5 + s1_bound : 1.0;
	if (outline_shine_reverse) { float t = s1_s; s1_s = s1_e; s1_e = t; }
	v_shine_data = vec4(1.0 + (outline_shine_delay * outline_shine_speed), s1_s, s1_e, outline_shine_width * (1.0 - outline_shine_softness));
	
	float s2_bound = outline_shine_2_style == 0 ? 0.75 + outline_shine_2_width : 0.0;
	float s2_s = outline_shine_2_style == 0 ? 0.5 - s2_bound : 0.0;
	float s2_e = outline_shine_2_style == 0 ? 0.5 + s2_bound : 1.0;
	if (outline_shine_2_reverse) { float t = s2_s; s2_s = s2_e; s2_e = t; }
	v_shine_2_data = vec4(1.0 + (outline_shine_2_delay * outline_shine_2_speed), s2_s, s2_e, outline_shine_2_width * (1.0 - outline_shine_2_softness));
	
	float alpha_edge = enable_outline ? outline_width : 0.0;
	v_edges = vec4(1.0 + outline_blur, alpha_edge, alpha_edge + 1.5, exp_double);

	mat3 t_base_mat; vec3 t_base_off;
	get_cg_params(base_color_brightness, base_color_contrast, base_color_saturation, base_color_hue_shift_speed, t_base_mat, t_base_off);
	v_base_cg_mat = t_base_mat;
	v_base_cg_off = t_base_off;
	
	mat3 t_out_mat; vec3 t_out_off;
	get_cg_params(outline_color_brightness, outline_color_contrast, outline_color_saturation, outline_color_hue_shift_speed, t_out_mat, t_out_off);
	v_out_cg_mat = t_out_mat;
	v_out_cg_off = t_out_off;
}

// --- HARDWARE-ACCELERATED HELPER FUNCTIONS ---

float calculate_smoothed_factor(float factor, float smoothing) {
	if (smoothing < 0.5) return mix(step(0.5, factor), factor, smoothing * 2.0);
	else if (smoothing <= 1.0) return mix(factor, smoothstep(0.0, 1.0, factor), (smoothing - 0.5) * 2.0);
	else return mix(pow(factor, smoothing), 1.0 - pow(1.0 - factor, smoothing), factor);
}

float random(vec2 uv) {
	return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// STABLE ARC-LENGTH PATH MAPPING
float get_path_t(vec2 p, vec2 h, float r) {
	r = min(r, min(h.x, h.y));
	vec2 inner = h - vec2(r);
	float total_len = 4.0 * (inner.x + inner.y) + 2.0 * 3.14159265359 * r;
	
	vec2 q = abs(p) - inner;
	float path_pos = 0.0;
	
	if (q.x > 0.0 && q.y > 0.0) {
		vec2 rel = p - (sign(p) * inner);
		float angle = 0.0;
		if (p.x > 0.0 && p.y < 0.0) {
			angle = atan(rel.x, -rel.y);
			path_pos = inner.x + angle * r;
		} else if (p.x > 0.0 && p.y > 0.0) {
			angle = atan(rel.y, rel.x);
			path_pos = inner.x + (1.57079632679 * r) + (inner.y * 2.0) + angle * r;
		} else if (p.x < 0.0 && p.y > 0.0) {
			angle = atan(-rel.x, rel.y);
			path_pos = inner.x + (3.14159265359 * r) + (inner.y * 2.0) + (inner.x * 2.0) + angle * r;
		} else {
			angle = atan(-rel.y, -rel.x);
			path_pos = inner.x + (4.71238898038 * r) + (inner.y * 4.0) + (inner.x * 2.0) + angle * r;
		}
	} else {
		if (p.y <= -inner.y) {
			if (p.x >= 0.0) path_pos = p.x;
			else path_pos = total_len + p.x;
		} else if (p.x >= inner.x) {
			path_pos = inner.x + (1.57079632679 * r) + (p.y + inner.y);
		} else if (p.y >= inner.y) {
			path_pos = inner.x + (3.14159265359 * r) + (inner.y * 2.0) + (inner.x - p.x);
		} else if (p.x <= -inner.x) {
			path_pos = inner.x + (4.71238898038 * r) + (inner.x * 2.0) + (inner.y * 2.0) + (inner.y - p.y);
		}
	}
	
	return fract(path_pos / max(total_len, 0.0001));
}

float get_gradient_factor(vec2 uv_cen, vec2 trig, float inv_scale, int type, float final_offset, bool rep, float smooth_val, float steps) {
	vec2 uv = vec2(dot(uv_cen, vec2(trig.y, -trig.x)), dot(uv_cen, trig)) + 0.5;
	
	float factor = 0.0;
	if (type == 0) factor = uv.x;
	else if (type == 1) factor = uv.y;
	else if (type == 2) factor = distance(uv, vec2(0.5)) * 2.0;
	else factor = abs(uv.y - 0.5) * 2.0;

	factor = (factor * inv_scale) - final_offset;
	factor = rep ? fract(factor) : clamp(factor, 0.0, 1.0);
	factor = calculate_smoothed_factor(factor, smooth_val);
	
	return steps > 0.0 ? floor(factor * steps) / max(steps, 0.001) : factor;
}

void fragment() {
	vec2 uv_cen = UV - 0.5;
	vec2 expanded_size = fwidth(local_pos) * (1.0 / max(fwidth(UV), vec2(0.00001)));
	vec2 rect_size = expanded_size - v_edges.w;
	vec2 pixel_pos = uv_cen * expanded_size;
	vec2 base_uv_cen = pixel_pos * (1.0 / max(rect_size, vec2(0.001)));

	// ------------------------------------------
	// DISTORTION
	// ------------------------------------------
	vec2 distorted_uv_cen = base_uv_cen;
	if (distortion_strength > 0.0) {
		vec2 noise_uv = UV + (TIME * distortion_speed);
		distorted_uv_cen += vec2(texture(noise_texture, noise_uv).r - 0.5) * distortion_strength;
	}

	// ------------------------------------------
	// PASS 1: Base Multi-Color Gradient
	// ------------------------------------------
	float base_offset = gradient_offset;
	if (enable_pulsation) {
		float e_time = TIME * animation_speed - (pulse_spatial_frequency > 0.0 ? length(base_uv_cen) * pulse_spatial_frequency : 0.0);
		base_offset = mix(pulse_min_offset, pulse_max_offset, textureLod(base_pulse_curve, vec2(fract(e_time), 0.0), 0.0).r);
	}
	
	float base_factor = get_gradient_factor(distorted_uv_cen, v_trig_1.xy, v_inv_scales.x, gradient_type, base_offset, repeat_gradient, gradient_smoothing, base_color_steps);
	vec4 final_color = textureLod(gradient_texture, vec2(base_factor, 0.0), 0.0);

	// ------------------------------------------
	// PASS 2: Overlay Color & Opacity
	// ------------------------------------------
	if (enable_overlay) {
		float over_col_offset = overlay_gradient_offset;
		if (overlay_enable_pulsation) {
			float e_time = TIME * overlay_animation_speed - (overlay_pulse_spatial_frequency > 0.0 ? length(base_uv_cen) * overlay_pulse_spatial_frequency : 0.0);
			over_col_offset = mix(overlay_pulse_min_offset, overlay_pulse_max_offset, textureLod(overlay_color_pulse_curve, vec2(fract(e_time), 0.0), 0.0).r);
		}
		
		float over_col_factor = get_gradient_factor(base_uv_cen, v_trig_1.zw, v_inv_scales.y, overlay_gradient_type, over_col_offset, overlay_repeat_gradient, overlay_gradient_smoothing, base_color_steps);
		vec4 over_layer = textureLod(overlay_gradient_texture, vec2(over_col_factor, 0.0), 0.0);
		
		if (enable_overlay_opacity) {
			float over_op_offset = overlay_opacity_offset;
			if (overlay_opacity_enable_pulsation) {
				float e_time = TIME * overlay_opacity_animation_speed - (overlay_opacity_pulse_spatial_frequency > 0.0 ? length(base_uv_cen) * overlay_opacity_pulse_spatial_frequency : 0.0);
				over_op_offset = mix(overlay_opacity_pulse_min_offset, overlay_opacity_pulse_max_offset, textureLod(overlay_opacity_pulse_curve, vec2(fract(e_time), 0.0), 0.0).r);
			}
			float over_op_factor = get_gradient_factor(base_uv_cen, v_trig_2.xy, v_inv_scales.z, overlay_opacity_type, over_op_offset, overlay_opacity_repeat, overlay_opacity_smoothing, base_color_steps);
			over_layer.a *= textureLod(overlay_opacity_texture, vec2(over_op_factor, 0.0), 0.0).r;
		}

		switch (overlay_blend_mode) {
			case 0: final_color.rgb = mix(final_color.rgb, over_layer.rgb, over_layer.a); break;
			case 1: final_color.rgb = mix(final_color.rgb, final_color.rgb * over_layer.rgb, over_layer.a); break;
			case 2: final_color.rgb += (over_layer.rgb * over_layer.a); break;
			case 3: final_color.rgb = 1.0 - (1.0 - final_color.rgb) * (1.0 - (over_layer.rgb * over_layer.a)); break;
		}
	}
	
	final_color.rgb = v_base_cg_mat * final_color.rgb + v_base_cg_off;
	
	float scan_multiplier = 1.0;
	if (scanline_opacity > 0.0) {
		float scan_y = dot(uv_cen, vec2(-v_trig_4.w, v_trig_4.z)); 
		float scan_val = sin(scan_y * scanline_density + TIME * scanline_speed) * 0.5 + 0.5;
		scan_multiplier = mix(1.0, scan_val, scanline_opacity);
	}
	if (scanline_base_only && scanline_opacity > 0.0) final_color.rgb *= scan_multiplier;

	// ------------------------------------------
	// PASS 3: Shape & Outline Gradient
	// ------------------------------------------
	vec2 half_size = rect_size * 0.5;
	vec2 q_sign = step(0.0, uv_cen); 
	float r = mix(mix(corner_radii.w, corner_radii.z, q_sign.x), mix(corner_radii.x, corner_radii.y, q_sign.x), q_sign.y);
	r = min(r, min(half_size.x, half_size.y));

	vec2 q_box = abs(pixel_pos) - half_size + vec2(r);
	float d_rounded = length(max(q_box, 0.0)) + min(max(q_box.x, q_box.y), 0.0) - r;
	float d_beveled = max(max(q_box.x, q_box.y), (max(q_box.x, 0.0) + max(q_box.y, 0.0)) * 0.70710678) + min(max(q_box.x, q_box.y), 0.0) - r;
	float d = use_beveled_corners ? d_beveled : d_rounded;
	
	if (enable_outline) {
		float out_offset = outline_gradient_offset;
		if (outline_enable_pulsation) {
			float e_time = TIME * outline_animation_speed - (outline_pulse_spatial_frequency > 0.0 ? length(base_uv_cen) * outline_pulse_spatial_frequency : 0.0);
			out_offset = mix(outline_pulse_min_offset, outline_pulse_max_offset, textureLod(outline_pulse_curve, vec2(fract(e_time), 0.0), 0.0).r);
		}
		
		float out_factor = get_gradient_factor(distorted_uv_cen, v_trig_2.zw, v_inv_scales.w, outline_gradient_type, out_offset, outline_repeat_gradient, outline_gradient_smoothing, outline_color_steps);
		vec4 out_color = textureLod(outline_gradient_texture, vec2(out_factor, 0.0), 0.0);

		float path_t = (outline_shine_style == 1 || outline_shine_2_style == 1 || (enable_dash && outline_dash_style == 1)) ? get_path_t(pixel_pos, half_size, r) : 0.0;

		if (outline_enable_shine) {
			float s1_dist;
			float sweep_time = mod(TIME * outline_shine_speed, v_shine_data.x);
			float current_shine_pos = sweep_time <= 1.0 ? mix(v_shine_data.y, v_shine_data.z, sweep_time) : -10.0;

			if (outline_shine_style == 0) {
				vec2 shine_uv = vec2(dot(base_uv_cen, vec2(v_trig_3.y, -v_trig_3.x)), dot(base_uv_cen, v_trig_3.xy)) + 0.5;
				s1_dist = abs(shine_uv.x - current_shine_pos);
			} else {
				float pd = abs(path_t - current_shine_pos);
				s1_dist = sweep_time <= 1.0 ? min(pd, 1.0 - pd) : 10.0;
			}

			float shine_power = 1.0 - smoothstep(v_shine_data.w, outline_shine_width, s1_dist);
			float added_shine_alpha = shine_power * outline_shine_color.a * textureLod(outline_shine_opacity_curve, vec2(clamp(sweep_time, 0.0, 1.0), 0.0), 0.0).r;
			
			out_color.rgb += outline_shine_color.rgb * added_shine_alpha * outline_shine_intensity;
			out_color.a = clamp(out_color.a + added_shine_alpha, 0.0, 1.0);
		}
		
		if (outline_enable_shine_2) {
			float s2_dist;
			float sweep_time = mod(TIME * outline_shine_2_speed, v_shine_2_data.x);
			float current_shine_pos = sweep_time <= 1.0 ? mix(v_shine_2_data.y, v_shine_2_data.z, sweep_time) : -10.0;

			if (outline_shine_2_style == 0) { 
				vec2 shine_2_uv = vec2(dot(base_uv_cen, vec2(v_trig_3.w, -v_trig_3.z)), dot(base_uv_cen, v_trig_3.zw)) + 0.5;
				s2_dist = abs(shine_2_uv.x - current_shine_pos);
			} else { 
				float pd = abs(path_t - current_shine_pos);
				s2_dist = sweep_time <= 1.0 ? min(pd, 1.0 - pd) : 10.0; 
			}

			float shine_power = 1.0 - smoothstep(v_shine_2_data.w, outline_shine_2_width, s2_dist);
			float added_shine_alpha = shine_power * outline_shine_2_color.a * textureLod(outline_shine_2_opacity_curve, vec2(clamp(sweep_time, 0.0, 1.0), 0.0), 0.0).r;
			
			out_color.rgb += outline_shine_2_color.rgb * added_shine_alpha * outline_shine_2_intensity;
			out_color.a = clamp(out_color.a + added_shine_alpha, 0.0, 1.0);
		}

		out_color.rgb = v_out_cg_mat * out_color.rgb + v_out_cg_off;

		float out_d = d;
		if (enable_wobble && outline_wobble_amplitude > 0.0) {
			out_d += sin(atan(pixel_pos.y, pixel_pos.x) * outline_wobble_frequency + TIME * outline_wobble_speed) * outline_wobble_amplitude;
		}

		float outline_mask = smoothstep(0.0, v_edges.x, out_d);
		
		if (enable_dash && outline_dash_count > 0.0) {
			float dash_t = (outline_dash_style == 1) ? path_t : (atan(pixel_pos.y, pixel_pos.x) / (3.14159265359 * 2.0));
			float actual_dash_count = (outline_dash_style == 1) ? max(round(outline_dash_count), 1.0) : outline_dash_count;
			float dash_val = dash_t * actual_dash_count + TIME * outline_dash_speed;
			
			if (outline_pattern == 0) {
				outline_mask *= step(0.5, sin(dash_val * 3.14159265359 * 2.0) * 0.5 + 0.5);
			} else {
				vec2 pat_uv;
				float perimeter = 4.0 * (half_size.x + half_size.y);
				pat_uv.x = (fract(dash_val) - 0.5) * (perimeter / actual_dash_count) / max(outline_width, 0.001);
				pat_uv.y = (d - outline_width * 0.5) / max(outline_width, 0.001); 
				
				float pat_d = 1.0;
				if (outline_pattern == 1) pat_d = length(pat_uv) * 2.0; 
				else if (outline_pattern == 2) pat_d = max(abs(pat_uv.x), abs(pat_uv.y)) * 2.0; 
				else pat_d = 1.0 - textureLod(outline_custom_pattern_texture, pat_uv + 0.5, 0.0).a; 
				
				outline_mask *= 1.0 - smoothstep(0.9, 1.1, pat_d);
			}
		}
		
		if (outline_fade_intensity > 0.0) {
			outline_mask *= mix(1.0, clamp(dot(base_uv_cen, vec2(v_trig_4.y, -v_trig_4.x)) + 0.5, 0.0, 1.0), outline_fade_intensity);
		}

		final_color.rgb = mix(final_color.rgb, out_color.rgb, outline_mask * out_color.a);
		final_color.a = max(final_color.a, outline_mask * out_color.a);
	}

	final_color.a *= 1.0 - smoothstep(v_edges.y, v_edges.z, d);

	// ------------------------------------------
	// GLOBAL POLISH & FX
	// ------------------------------------------
	if (!scanline_base_only && scanline_opacity > 0.0) final_color.rgb *= scan_multiplier;
	
	if (gamma_correction != 1.0) {
		final_color.rgb = pow(max(final_color.rgb, 0.0), vec3(1.0 / gamma_correction));
	}
	
	if (enable_dithering) {
		final_color.rgb += random(FRAGCOORD.xy) * 0.015 - 0.0075;
	}

	COLOR = final_color;
}