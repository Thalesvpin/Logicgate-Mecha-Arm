shader_type canvas_item;

// =============================================================================
// MATH CONSTANTS
// =============================================================================
#define PI_HALF 1.57079632679489661923
#define PI_TWO 6.28318530717958647692
#define INV_PI_TWO 0.15915494309189533576

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
uniform bool overlay_ignore_base_distortion = true;
uniform bool overlay_ignore_base_color_grading = false;

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
uniform bool outline_ignore_base_distortion = false;
uniform bool outline_ignore_base_color_grading = true;
uniform float outline_width : hint_range(0.0, 100.0) = 2.0;
uniform float outline_blur : hint_range(0.0, 20.0) = 0.0;
uniform float outline_sharpness : hint_range(0.0, 1.0) = 0.5;
uniform float outline_path_seam_offset : hint_range(0.0, 1.0) = 0.0;

uniform sampler2D outline_gradient_texture : source_color, filter_linear, repeat_disable;
uniform int outline_gradient_type : hint_enum("Horizontal", "Vertical", "Radial", "Mirrored") = 1;
uniform float outline_gradient_rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform float outline_gradient_scale : hint_range(0.1, 10.0) = 1.0;
uniform float outline_gradient_smoothing : hint_range(0.0, 5.0) = 0.5;
uniform float outline_gradient_offset : hint_range(-2.0, 2.0) = 0.0;
uniform bool outline_repeat_gradient = false;

group_uniforms Outline_Settings.Path_Mapping_Optimization;
uniform bool use_path_lut = false;
uniform sampler2D path_lut_texture : hint_default_black, filter_linear, repeat_disable;

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
uniform int outline_shine_style : hint_enum("Linear Sweep", "Follow Shape", "Double Follow Shape", "Reverse Follow Shape") = 1; 
uniform bool outline_shine_half_sweep = false;
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
uniform int outline_shine_2_style : hint_enum("Linear Sweep", "Follow Shape", "Double Follow Shape", "Reverse Follow Shape") = 1;
uniform bool outline_shine_2_half_sweep = false;
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
uniform bool enable_scanlines = false;
uniform bool scanline_base_only = false;
uniform int scanline_blend_mode : hint_enum("Multiply", "Add", "Screen", "Normal") = 0;
uniform vec4 scanline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float scanline_density : hint_range(0.0, 200.0) = 0.0; 
uniform float scanline_thickness : hint_range(0.0, 1.0) = 0.5;
uniform float scanline_softness : hint_range(0.001, 1.0) = 1.0;
uniform float scanline_rotation : hint_range(0.0, 360.0) = 0.0;
uniform float scanline_offset : hint_range(0.0, 1.0) = 0.0;
uniform float scanline_speed : hint_range(-10.0, 10.0) = 0.0;
uniform float scanline_curvature : hint_range(-1.0, 1.0) = 0.0;
uniform float scanline_flicker_speed : hint_range(0.0, 60.0) = 0.0;
uniform float scanline_flicker_intensity : hint_range(0.0, 1.0) = 0.0;

group_uniforms Global_Polish_And_FX.Scanlines.Gradient;
uniform bool scanline_use_gradient = false;
uniform sampler2D scanline_gradient_texture : source_color, filter_linear, repeat_disable;
uniform int scanline_gradient_type : hint_enum("Horizontal", "Vertical", "Radial", "Mirrored", "2D Texture") = 0;
uniform float scanline_gradient_rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform float scanline_gradient_scale : hint_range(0.1, 10.0) = 1.0;
uniform float scanline_gradient_smoothing : hint_range(0.0, 5.0) = 0.5;
uniform float scanline_gradient_offset : hint_range(-2.0, 2.0) = 0.0;
uniform bool scanline_repeat_gradient = false;

group_uniforms Global_Polish_And_FX.Scanlines.Opacity;
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.0; 
uniform bool scanline_enable_opacity_map = false;
uniform sampler2D scanline_opacity_texture : hint_default_white, filter_linear, repeat_disable;
uniform int scanline_opacity_type : hint_enum("Horizontal", "Vertical", "Radial", "Mirrored", "2D Texture") = 2;
uniform float scanline_opacity_rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform float scanline_opacity_scale : hint_range(0.1, 10.0) = 1.0;
uniform float scanline_opacity_smoothing : hint_range(0.0, 5.0) = 0.5;
uniform float scanline_opacity_offset : hint_range(-2.0, 2.0) = 0.0;
uniform bool scanline_opacity_repeat = false;

group_uniforms Global_Polish_And_FX.Liquid_Stripes;
uniform bool enable_liquid_stripes = false;
uniform bool liquid_stripes_base_only = false;
uniform int liquid_stripes_blend_mode : hint_enum("Normal", "Multiply", "Add", "Screen") = 0;
uniform vec4 liquid_stripes_color : source_color = vec4(0.59, 0.98, 0.69, 1.0);
uniform vec4 liquid_stripes_bg_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform float liquid_stripes_rotation : hint_range(0.0, 360.0) = 0.0;
uniform float liquid_stripes_speed : hint_range(-10.0, 10.0) = 1.0;
uniform float liquid_stripes_sway : hint_range(0.0, 5.0) = 1.0;
uniform float liquid_stripes_density : hint_range(0.1, 100.0) = 4.82;
uniform float liquid_stripes_thickness : hint_range(0.0, 1.0) = 0.45;
uniform float liquid_stripes_softness : hint_range(0.001, 0.5) = 0.05;
uniform float liquid_stripes_warp : hint_range(0.0, 2.0) = 1.0;
uniform float liquid_stripes_warp_origin : hint_range(-1.0, 1.0) = -0.5;
uniform float liquid_stripes_warp_falloff : hint_range(-2.0, 2.0) = 0.0;
uniform float liquid_stripes_warp_direction : hint_range(0.0, 360.0) = 0.0;
uniform float liquid_stripes_warp_frequency : hint_range(0.0, 50.0) = 15.0;
uniform float liquid_stripes_warp_flow : hint_range(-10.0, 10.0) = 2.0;

group_uniforms Global_Polish_And_FX.Liquid_Stripes.Gradient;
uniform bool liquid_stripes_use_gradient = false;
uniform sampler2D liquid_stripes_gradient_texture : source_color, filter_linear, repeat_disable;
uniform int liquid_stripes_gradient_type : hint_enum("Horizontal", "Vertical", "Radial", "Mirrored", "2D Texture") = 0;
uniform float liquid_stripes_gradient_rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform float liquid_stripes_gradient_scale : hint_range(0.1, 10.0) = 1.0;
uniform float liquid_stripes_gradient_smoothing : hint_range(0.0, 5.0) = 0.5;
uniform float liquid_stripes_gradient_offset : hint_range(-2.0, 2.0) = 0.0;
uniform bool liquid_stripes_repeat_gradient = false;

group_uniforms Global_Polish_And_FX.Liquid_Stripes.Opacity;
uniform float liquid_stripes_opacity : hint_range(0.0, 1.0) = 0.5;
uniform bool liquid_stripes_enable_opacity_map = false;
uniform sampler2D liquid_stripes_opacity_texture : hint_default_white, filter_linear, repeat_disable;
uniform int liquid_stripes_opacity_type : hint_enum("Horizontal", "Vertical", "Radial", "Mirrored", "2D Texture") = 2;
uniform float liquid_stripes_opacity_rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform float liquid_stripes_opacity_scale : hint_range(0.1, 10.0) = 1.0;
uniform float liquid_stripes_opacity_smoothing : hint_range(0.0, 5.0) = 0.5;
uniform float liquid_stripes_opacity_offset : hint_range(-2.0, 2.0) = 0.0;
uniform bool liquid_stripes_opacity_repeat = false;

group_uniforms Global_Polish_And_FX.Render;
uniform float gamma_correction : hint_range(0.1, 3.0) = 1.0;  
uniform bool enable_dithering = true;

// =============================================================================
// VARYINGS (Minimal 2-Float Footprint for Low-End & Mobile Compatibility)
// =============================================================================
group_uniforms;

varying vec2 local_pos;

// =============================================================================
// VERTEX SHADER
// =============================================================================
void vertex() {
	float sharp_scale = enable_outline ? max((1.0 - outline_sharpness) * 2.0, 0.001) : 1.0;
	float outer_aa = 1.5 * sharp_scale;
	float exp_pad = max(2.0, outer_aa + 0.5);
	if (enable_outline) exp_pad += outline_width + outline_blur;

	VERTEX += (UV - 0.5) * (exp_pad * 2.0);
	local_pos = VERTEX;
}

// =============================================================================
// HARDWARE-ACCELERATED HELPER FUNCTIONS
// =============================================================================
void get_cg_rows(float bright, float cont, float sat, float hue_speed, out vec4 r0, out vec4 r1, out vec4 r2) {
	mat3 sat_m = mat3(
		vec3(0.299 + 0.701 * sat, 0.299 - 0.299 * sat, 0.299 - 0.299 * sat),
		vec3(0.587 - 0.587 * sat, 0.587 + 0.413 * sat, 0.587 - 0.587 * sat),
		vec3(0.114 - 0.114 * sat, 0.114 - 0.114 * sat, 0.114 + 0.886 * sat)
	);
	
	float a = mod(TIME * hue_speed, PI_TWO);
	float c = cos(a), s = sin(a);
	mat3 hue_m = mat3(
		vec3(0.213 + c * 0.787 - s * 0.213, 0.213 - c * 0.213 + s * 0.143, 0.213 - c * 0.213 - s * 0.787),
		vec3(0.715 - c * 0.715 - s * 0.715, 0.715 + c * 0.285 + s * 0.140, 0.715 - c * 0.715 + s * 0.715),
		vec3(0.072 - c * 0.072 + s * 0.928, 0.072 - c * 0.072 - s * 0.283, 0.072 + c * 0.928 + s * 0.072)
	);
	
	mat3 out_mat = hue_m * sat_m * cont;
	vec3 out_off = hue_m * sat_m * vec3(0.5 - 0.5 * cont + bright);
	r0 = vec4(out_mat[0][0], out_mat[1][0], out_mat[2][0], out_off.x);
	r1 = vec4(out_mat[0][1], out_mat[1][1], out_mat[2][1], out_off.y);
	r2 = vec4(out_mat[0][2], out_mat[1][2], out_mat[2][2], out_off.z);
}

float calculate_smoothed_factor(float factor, float smoothing) {
	if (smoothing == 0.5) return factor;
	if (smoothing < 0.5) return mix(step(0.5, factor), factor, smoothing * 2.0);
	if (smoothing <= 1.0) {
		float s = factor * factor * (3.0 - 2.0 * factor);
		return mix(factor, s, (smoothing - 0.5) * 2.0);
	}
	return mix(pow(max(factor, 0.00001), smoothing), 1.0 - pow(max(1.0 - factor, 0.00001), smoothing), factor);
}

// Trig-free Interleaved Gradient Noise (FP16-safe on mobile GPUs)
float ign_dither(vec2 frag_xy) {
	return fract(52.9829189 * fract(dot(frag_xy, vec2(0.06711056, 0.00583715))));
}

float get_path_t(vec2 p, vec2 h, float r, float offset) {
	vec2 inner = h - vec2(r);
	float inner_x2 = inner.x * 2.0;
	float inner_y2 = inner.y * 2.0;
	float arc_quarter = PI_HALF * r;
	float total_len = 2.0 * (inner_x2 + inner_y2) + (arc_quarter * 4.0);
	
	vec2 q = abs(p) - inner;
	float path_pos = 0.0;
	
	if (r > 0.0 && q.x > 0.0 && q.y > 0.0) {
		float corner_ang = ((p.x > 0.0) == (p.y < 0.0)) ? atan(q.x, q.y) : atan(q.y, q.x);
		if (p.x > 0.0 && p.y < 0.0) {
			path_pos = inner.x + corner_ang * r;
		} else if (p.x > 0.0 && p.y > 0.0) {
			path_pos = inner.x + arc_quarter + inner_y2 + corner_ang * r;
		} else if (p.x < 0.0 && p.y > 0.0) {
			path_pos = inner.x + (arc_quarter * 2.0) + inner_y2 + inner_x2 + corner_ang * r;
		} else {
			path_pos = inner.x + (arc_quarter * 3.0) + (inner_y2 * 2.0) + inner_x2 + corner_ang * r;
		}
	} else {
		if (p.y <= -inner.y) {
			path_pos = (p.x >= 0.0) ? p.x : total_len + p.x;
		} else if (p.x >= inner.x) {
			path_pos = inner.x + arc_quarter + (p.y + inner.y);
		} else if (p.y >= inner.y) {
			path_pos = inner.x + (arc_quarter * 2.0) + inner_y2 + (inner.x - p.x);
		} else if (p.x <= -inner.x) {
			path_pos = inner.x + (arc_quarter * 3.0) + inner_x2 + inner_y2 + (inner.y - p.y);
		}
	}
	return fract((path_pos / max(total_len, 0.0001)) + offset);
}

float get_gradient_factor(vec2 normalized_uv, vec2 trig, float inv_scale, int type, float final_offset, bool rep, float smooth_val, float steps) {
	float factor = 0.0;
	if (type == 0) {
		factor = dot(normalized_uv, vec2(trig.y, -trig.x) * inv_scale) - final_offset;
	} else if (type == 1) {
		factor = dot(normalized_uv, trig * inv_scale) - final_offset;
	} else if (type == 2) {
		vec2 uv = vec2(dot(normalized_uv, vec2(trig.y, -trig.x)), dot(normalized_uv, trig));
		factor = (distance(uv, vec2(0.5)) * 2.0 * inv_scale) - final_offset;
	} else {
		factor = (abs(dot(normalized_uv, trig) - 0.5) * 2.0 * inv_scale) - final_offset;
	}

	factor = rep ? fract(factor) : clamp(factor, 0.0, 1.0);
	factor = calculate_smoothed_factor(factor, smooth_val);
	return steps > 0.0 ? floor(factor * steps) / steps : factor;
}

vec4 sample_mapped_texture(sampler2D tex, vec2 normalized_uv, vec2 trig, float inv_scale, int type, float final_offset, bool rep, float smooth_val) {
	if (type == 4) {
		vec2 uv_c = normalized_uv - 0.5;
		vec2 uv = vec2(dot(uv_c, vec2(trig.y, -trig.x)), dot(uv_c, trig)) * inv_scale + 0.5 - final_offset;
		uv = rep ? fract(uv) : clamp(uv, 0.0, 1.0);
		return textureLod(tex, uv, 0.0);
	}
	float factor = get_gradient_factor(normalized_uv, trig, inv_scale, type, final_offset, rep, smooth_val, 0.0);
	return textureLod(tex, vec2(factor, 0.0), 0.0);
}

float get_pulse_offset(bool enable, float time_speed, float spatial_freq, float uv_len, sampler2D curve, float min_off, float max_off) {
	if (!enable) return 0.0;
	float e_time = fract(TIME * time_speed) - (uv_len * spatial_freq);
	return mix(min_off, max_off, textureLod(curve, vec2(fract(e_time), 0.0), 0.0).r);
}

float get_shine_alpha(
	int style, bool half_sweep,
	float path_t, vec2 normalized_uv, vec2 trig,
	float delay, float width, float soft_w,
	float current_shine_pos, float time_norm, sampler2D opacity_curve
) {
	float dist = 10.0;

	if (style == 0) {
		float shine_uv_x = dot(normalized_uv, vec2(trig.y, -trig.x));
		if (!half_sweep || shine_uv_x <= 0.5) {
			dist = abs(shine_uv_x - current_shine_pos);
		}
	} else if (style == 1) {
		if (!half_sweep || path_t <= 0.5) {
			dist = abs(path_t - current_shine_pos);
			if (delay == 0.0) dist = min(dist, 1.0 - dist);
		}
	} else if (style == 2) {
		float pd1 = abs(path_t - current_shine_pos);
		float pd2 = abs(path_t - (1.0 - current_shine_pos));
		if (delay == 0.0) { pd1 = min(pd1, 1.0 - pd1); pd2 = min(pd2, 1.0 - pd2); }
		dist = half_sweep ? ((path_t <= 0.5) ? pd1 : pd2) : min(pd1, pd2);
	} else if (style == 3) {
		float rev_path_t = fract(-path_t);
		if (!half_sweep || rev_path_t <= 0.5) {
			dist = abs(rev_path_t - current_shine_pos);
			if (delay == 0.0) dist = min(dist, 1.0 - dist);
		}
	}

	if (dist >= width) return 0.0;

	float shine_power = 1.0 - smoothstep(soft_w, width, dist);
	return shine_power * textureLod(opacity_curve, vec2(time_norm, 0.0), 0.0).r;
}

// Unified blend modes: 0 = Normal, 1 = Multiply, 2 = Add, 3 = Screen
vec3 apply_fx_blend(vec3 base_rgb, vec4 fx_rgba, int blend_mode) {
	if (fx_rgba.a <= 0.0) return base_rgb;
	switch (blend_mode) {
		case 0: return mix(base_rgb, fx_rgba.rgb, fx_rgba.a);
		case 1: return base_rgb * mix(vec3(1.0), fx_rgba.rgb, fx_rgba.a);
		case 2: return base_rgb + fx_rgba.rgb * fx_rgba.a;
		default: return mix(base_rgb, vec3(1.0), fx_rgba.rgb * fx_rgba.a);
	}
}

vec4 evaluate_scanlines(vec2 uv_cen, vec2 normalized_uv, vec2 trig, float flicker, float scan_phase) {
	float scan_y = dot(uv_cen, vec2(-trig.y, trig.x));
	if (scanline_curvature != 0.0) {
		float scan_x = dot(uv_cen, trig);
		scan_y += (scan_x * scan_x) * scanline_curvature;
	}
	float raw_wave = sin(scan_y * scanline_density + scan_phase) * 0.5 + 0.5;
	float edge_low = (1.0 - scanline_thickness) - scanline_softness * 0.5;
	float edge_high = edge_low + scanline_softness;
	if (raw_wave >= edge_high) return vec4(0.0);

	float line_mask = 1.0 - smoothstep(edge_low, edge_high, raw_wave);

	vec4 sc_col = scanline_color;
	if (scanline_use_gradient) {
		float grad_rad = radians(scanline_gradient_rotation_degrees);
		vec2 grad_trig = vec2(sin(grad_rad), cos(grad_rad));
		float inv_grad_scale = 1.0 / max(scanline_gradient_scale, 0.001);
		sc_col = sample_mapped_texture(scanline_gradient_texture, normalized_uv, grad_trig, inv_grad_scale, scanline_gradient_type, scanline_gradient_offset, scanline_repeat_gradient, scanline_gradient_smoothing);
	}

	float op_map = 1.0;
	if (scanline_enable_opacity_map) {
		float op_rad = radians(scanline_opacity_rotation_degrees);
		vec2 op_trig = vec2(sin(op_rad), cos(op_rad));
		float inv_op_scale = 1.0 / max(scanline_opacity_scale, 0.001);
		vec4 op_tex = sample_mapped_texture(scanline_opacity_texture, normalized_uv, op_trig, inv_op_scale, scanline_opacity_type, scanline_opacity_offset, scanline_opacity_repeat, scanline_opacity_smoothing);
		op_map = op_tex.r * op_tex.a;
	}

	sc_col.a *= line_mask * scanline_opacity * flicker * op_map;
	return sc_col;
}

vec4 evaluate_liquid_stripes(vec2 uv_cen, vec2 normalized_uv, vec2 ls_trig, float ls_time, float warp_amp) {
	float rot_y = dot(uv_cen, vec2(-ls_trig.x, ls_trig.y));

	if (warp_amp != 0.0) {
		float rot_x = dot(uv_cen, vec2(ls_trig.y, ls_trig.x));
		float dist_from_origin = rot_x - liquid_stripes_warp_origin;
		float abs_dist = abs(dist_from_origin);
		
		float amp_falloff = 1.0;
		if (liquid_stripes_warp_falloff > 1.0) {
			amp_falloff = pow(max(abs_dist * 2.0, 0.00001), liquid_stripes_warp_falloff);
		} else if (liquid_stripes_warp_falloff > 0.0) {
			amp_falloff = mix(1.0, abs_dist * 2.0, liquid_stripes_warp_falloff);
		} else if (liquid_stripes_warp_falloff < 0.0) {
			amp_falloff = pow(max(1.0 - abs_dist, 0.00001), -liquid_stripes_warp_falloff * 2.0);
		}

		float osc = sin(rot_x * dist_from_origin * liquid_stripes_warp_frequency) * (warp_amp * amp_falloff);
		rot_y += osc * sin(ls_time + dist_from_origin * liquid_stripes_warp_flow);
	}

	float warped_y = fract(rot_y * liquid_stripes_density);
	float mask = 0.0;
	if (warped_y > 0.5) {
		float th = liquid_stripes_thickness * 0.5;
		float edge_end = 0.5 + liquid_stripes_softness;
		mask = smoothstep(0.5, edge_end, warped_y) - smoothstep(0.5 + th, edge_end + th, warped_y);
	}
	
	if (mask <= 0.0 && liquid_stripes_bg_color.a <= 0.0) return vec4(0.0);

	vec4 tint = liquid_stripes_bg_color;
	if (mask > 0.0) {
		vec4 stripe_col = liquid_stripes_color;
		if (liquid_stripes_use_gradient) {
			float grad_rad = radians(liquid_stripes_gradient_rotation_degrees);
			vec2 grad_trig = vec2(sin(grad_rad), cos(grad_rad));
			float inv_grad_scale = 1.0 / max(liquid_stripes_gradient_scale, 0.001);
			stripe_col = sample_mapped_texture(liquid_stripes_gradient_texture, normalized_uv, grad_trig, inv_grad_scale, liquid_stripes_gradient_type, liquid_stripes_gradient_offset, liquid_stripes_repeat_gradient, liquid_stripes_gradient_smoothing);
		}
		tint = (mask >= 1.0) ? stripe_col : mix(liquid_stripes_bg_color, stripe_col, mask);
	}

	float op_map = 1.0;
	if (liquid_stripes_enable_opacity_map) {
		float op_rad = radians(liquid_stripes_opacity_rotation_degrees);
		vec2 op_trig = vec2(sin(op_rad), cos(op_rad));
		float inv_op_scale = 1.0 / max(liquid_stripes_opacity_scale, 0.001);
		vec4 op_tex = sample_mapped_texture(liquid_stripes_opacity_texture, normalized_uv, op_trig, inv_op_scale, liquid_stripes_opacity_type, liquid_stripes_opacity_offset, liquid_stripes_opacity_repeat, liquid_stripes_opacity_smoothing);
		op_map = op_tex.r * op_tex.a;
	}

	tint.a *= liquid_stripes_opacity * op_map;
	return tint;
}

// =============================================================================
// FRAGMENT SHADER
// =============================================================================
void fragment() {
	float sharp_scale = enable_outline ? max((1.0 - outline_sharpness) * 2.0, 0.001) : 1.0;
	float outer_aa = 1.5 * sharp_scale;
	float exp_pad = max(2.0, outer_aa + 0.5);
	if (enable_outline) exp_pad += outline_width + outline_blur;
	float exp_double = exp_pad * 2.0;

	vec2 uv_cen = UV - 0.5;
	vec2 expanded_size = fwidth(local_pos) / max(fwidth(UV), vec2(0.00001));
	vec2 rect_size = expanded_size - exp_double;
	vec2 half_size = rect_size * 0.5;
	vec2 pixel_pos = uv_cen * expanded_size;

	// Fast SDF path for sharp rectangles; full corner SDF only when rounded/beveled
	float r = 0.0;
	float d = 0.0;
	if (corner_radii == vec4(0.0) && !use_beveled_corners) {
		vec2 q_box = abs(pixel_pos) - half_size;
		d = length(max(q_box, 0.0)) + min(max(q_box.x, q_box.y), 0.0);
	} else {
		vec2 q_sign = step(0.0, uv_cen);
		r = mix(mix(corner_radii.w, corner_radii.z, q_sign.x), mix(corner_radii.x, corner_radii.y, q_sign.x), q_sign.y);
		r = min(r, min(half_size.x, half_size.y));

		vec2 q_box = abs(pixel_pos) - half_size + vec2(r);
		vec2 max_q_vec = max(q_box, 0.0);
		float max_q = max(q_box.x, q_box.y);
		float dist_inner = min(max_q, 0.0) - r;
		d = use_beveled_corners ? max(max_q, (max_q_vec.x + max_q_vec.y) * 0.70710678) + dist_inner : length(max_q_vec) + dist_inner;
	}

	float alpha_edge = enable_outline ? outline_width : 0.0;
	float shape_alpha = 1.0 - smoothstep(alpha_edge, alpha_edge + outer_aa, d);

	if (shape_alpha <= 0.0) {
		COLOR = vec4(0.0);
	} else {
		// Compute normalized radial distance without per-pixel vector division
		float base_uv_len = 0.0;
		if (enable_pulsation || (enable_overlay && overlay_enable_pulsation) || (enable_outline && outline_enable_pulsation)) {
			vec2 uv_to_rect = expanded_size / max(rect_size, vec2(0.001));
			base_uv_len = length(uv_cen * uv_to_rect);
		}

		vec2 distorted_norm_uv = UV;
		if (distortion_strength > 0.0) {
			vec2 noise_uv = UV + fract(TIME * distortion_speed);
			distorted_norm_uv += vec2(texture(noise_texture, noise_uv).r - 0.5) * distortion_strength;
		}

		// PASS 1: Base Multi-Color Gradient
		float base_rad = radians(gradient_rotation_degrees);
		vec2 base_trig = vec2(sin(base_rad), cos(base_rad));
		float inv_base_scale = 1.0 / max(gradient_scale, 0.001);
		float base_offset = gradient_offset + get_pulse_offset(enable_pulsation, animation_speed, pulse_spatial_frequency, base_uv_len, base_pulse_curve, pulse_min_offset, pulse_max_offset);
		float base_factor = get_gradient_factor(distorted_norm_uv, base_trig, inv_base_scale, gradient_type, base_offset, repeat_gradient, gradient_smoothing, base_color_steps);
		vec4 final_color = textureLod(gradient_texture, vec2(base_factor, 0.0), 0.0);

		bool has_base_cg = (base_color_brightness != 0.0) || (base_color_contrast != 1.0) || (base_color_saturation != 1.0) || (base_color_hue_shift_speed != 0.0);
		vec4 base_cg_0 = vec4(1.0, 0.0, 0.0, 0.0);
		vec4 base_cg_1 = vec4(0.0, 1.0, 0.0, 0.0);
		vec4 base_cg_2 = vec4(0.0, 0.0, 1.0, 0.0);
		if (has_base_cg) {
			get_cg_rows(base_color_brightness, base_color_contrast, base_color_saturation, base_color_hue_shift_speed, base_cg_0, base_cg_1, base_cg_2);
		}

		// Apply Base Color Grading BEFORE Overlay when Overlay ignores Base Color Grading
		if (has_base_cg && overlay_ignore_base_color_grading) {
			vec4 base_rgb1 = vec4(final_color.rgb, 1.0);
			final_color.rgb = vec3(dot(base_cg_0, base_rgb1), dot(base_cg_1, base_rgb1), dot(base_cg_2, base_rgb1));
		}

		// PASS 2: Overlay Color & Opacity
		if (enable_overlay) {
			vec2 overlay_uv = overlay_ignore_base_distortion ? UV : distorted_norm_uv;
			float over_steps = overlay_ignore_base_color_grading ? 0.0 : base_color_steps;
			float over_rad = radians(overlay_gradient_rotation_degrees);
			vec2 over_trig = vec2(sin(over_rad), cos(over_rad));
			float inv_over_scale = 1.0 / max(overlay_gradient_scale, 0.001);
			float over_col_offset = overlay_gradient_offset + get_pulse_offset(overlay_enable_pulsation, overlay_animation_speed, overlay_pulse_spatial_frequency, base_uv_len, overlay_color_pulse_curve, overlay_pulse_min_offset, overlay_pulse_max_offset);
			float over_col_factor = get_gradient_factor(overlay_uv, over_trig, inv_over_scale, overlay_gradient_type, over_col_offset, overlay_repeat_gradient, overlay_gradient_smoothing, over_steps);
			vec4 over_layer = textureLod(overlay_gradient_texture, vec2(over_col_factor, 0.0), 0.0);
			
			if (over_layer.a > 0.0) {
				if (enable_overlay_opacity) {
					float over_op_rad = radians(overlay_opacity_rotation_degrees);
					vec2 over_op_trig = vec2(sin(over_op_rad), cos(over_op_rad));
					float inv_over_op_scale = 1.0 / max(overlay_opacity_scale, 0.001);
					float over_op_offset = overlay_opacity_offset + get_pulse_offset(overlay_opacity_enable_pulsation, overlay_opacity_animation_speed, overlay_opacity_pulse_spatial_frequency, base_uv_len, overlay_opacity_pulse_curve, overlay_opacity_pulse_min_offset, overlay_opacity_pulse_max_offset);
					float over_op_factor = get_gradient_factor(overlay_uv, over_op_trig, inv_over_op_scale, overlay_opacity_type, over_op_offset, overlay_opacity_repeat, overlay_opacity_smoothing, over_steps);
					over_layer.a *= textureLod(overlay_opacity_texture, vec2(over_op_factor, 0.0), 0.0).r;
				}
				final_color.rgb = apply_fx_blend(final_color.rgb, over_layer, overlay_blend_mode);
			}
		}
		
		// Apply Base Color Grading AFTER Overlay when Overlay does NOT ignore Base Color Grading
		if (has_base_cg && !overlay_ignore_base_color_grading) {
			vec4 base_rgb1 = vec4(final_color.rgb, 1.0);
			final_color.rgb = vec3(dot(base_cg_0, base_rgb1), dot(base_cg_1, base_rgb1), dot(base_cg_2, base_rgb1));
		}

		// PASS 3: Outline Gradient & FX (evaluated before base-only FX so opaque outline pixels skip base-only FX)
		vec4 out_color = vec4(0.0);
		float out_blend = 0.0;
		bool has_outline_geometry = enable_outline && (outline_width > 0.0 || outline_blur > 0.0 || (enable_wobble && outline_wobble_amplitude > 0.0));
		if (has_outline_geometry) {
			float out_d = d;
			float pixel_angle = 0.0;
			bool has_pixel_angle = false;
			if (enable_wobble && outline_wobble_amplitude > 0.0) {
				pixel_angle = atan(pixel_pos.y, pixel_pos.x);
				has_pixel_angle = true;
				float wobble_phase = mod(TIME * outline_wobble_speed, PI_TWO);
				out_d += sin(pixel_angle * outline_wobble_frequency + wobble_phase) * outline_wobble_amplitude;
			}

			if (out_d > 0.0) {
				float inner_aa = sharp_scale + outline_blur;
				float outline_mask = smoothstep(0.0, inner_aa, out_d);

				float path_t = 0.0;
				bool need_path_t = (outline_enable_shine && outline_shine_style != 0)
								|| (outline_enable_shine_2 && outline_shine_2_style != 0)
								|| (enable_dash && outline_dash_count > 0.0 && outline_dash_style == 1);
				if (need_path_t) {
					path_t = use_path_lut ? fract(textureLod(path_lut_texture, UV, 0.0).r + outline_path_seam_offset) : get_path_t(pixel_pos, half_size, r, outline_path_seam_offset);
				}

				if (enable_dash && outline_dash_count > 0.0) {
					float dash_t = 0.0;
					if (outline_dash_style == 1) {
						dash_t = path_t;
					} else {
						if (!has_pixel_angle) pixel_angle = atan(pixel_pos.y, pixel_pos.x);
						dash_t = pixel_angle * INV_PI_TWO;
					}
					float actual_dash_count = (outline_dash_style == 1) ? max(round(outline_dash_count), 1.0) : outline_dash_count;
					float dash_val = dash_t * actual_dash_count + fract(TIME * outline_dash_speed);
					
					if (outline_pattern == 0) {
						outline_mask *= step(fract(dash_val), 0.5); 
					} else {
						vec2 pat_uv;
						// True rounded-rectangle perimeter (fixes pattern stretching on rounded corners)
						float perimeter = 4.0 * (half_size.x + half_size.y) + (PI_TWO - 8.0) * r;
						float inv_out_w = 1.0 / max(outline_width, 0.001);
						pat_uv.x = (fract(dash_val) - 0.5) * (perimeter / actual_dash_count) * inv_out_w;
						pat_uv.y = (d - outline_width * 0.5) * inv_out_w; 
						
						float pat_d = 1.0;
						if (outline_pattern == 1) pat_d = length(pat_uv) * 2.0; 
						else if (outline_pattern == 2) pat_d = max(abs(pat_uv.x), abs(pat_uv.y)) * 2.0; 
						else pat_d = 1.0 - textureLod(outline_custom_pattern_texture, pat_uv + 0.5, 0.0).a; 
						
						outline_mask *= 1.0 - smoothstep(0.9, 1.1, pat_d);
					}
				}
				
				if (outline_fade_intensity > 0.0) {
					float fade_rad = radians(outline_fade_angle);
					vec2 fade_trig = vec2(sin(fade_rad), cos(fade_rad));
					outline_mask *= mix(1.0, clamp(dot(UV, vec2(fade_trig.y, -fade_trig.x)), 0.0, 1.0), outline_fade_intensity);
				}

				if (outline_mask > 0.0) {
					vec2 outline_uv = outline_ignore_base_distortion ? UV : distorted_norm_uv;
					float out_rad = radians(outline_gradient_rotation_degrees);
					vec2 out_trig = vec2(sin(out_rad), cos(out_rad));
					float inv_out_scale = 1.0 / max(outline_gradient_scale, 0.001);
					float out_offset = outline_gradient_offset + get_pulse_offset(outline_enable_pulsation, outline_animation_speed, outline_pulse_spatial_frequency, base_uv_len, outline_pulse_curve, outline_pulse_min_offset, outline_pulse_max_offset);
					float out_factor = get_gradient_factor(outline_uv, out_trig, inv_out_scale, outline_gradient_type, out_offset, outline_repeat_gradient, outline_gradient_smoothing, outline_color_steps);
					out_color = textureLod(outline_gradient_texture, vec2(out_factor, 0.0), 0.0);

					// SHINE 1 RENDER (uniform sweep phase skipped entirely during delay pause)
					if (outline_enable_shine) {
						float s1_D = 1.0;
						float s1_s = 0.0;
						bool s1_cont = outline_shine_delay == 0.0;
						float sweep_dist_1 = outline_shine_half_sweep ? 0.5 : 1.0;
						if (outline_shine_style == 0) {
							float sweep_dist_lin = outline_shine_half_sweep ? 0.5 : 1.5;
							s1_s = -0.25 - outline_shine_width;
							s1_D = sweep_dist_lin + outline_shine_width * 2.0;
						} else {
							s1_s = s1_cont ? 0.0 : -outline_shine_width;
							s1_D = s1_cont ? sweep_dist_1 : sweep_dist_1 + outline_shine_width * 2.0;
						}
						float s1_origin = outline_shine_reverse ? (s1_s + s1_D) : s1_s;
						float s1_cycle = s1_D + outline_shine_delay * outline_shine_speed;
						float s1_sweep_time = mod(TIME * outline_shine_speed, s1_cycle);
						float s1_time_norm = s1_sweep_time / max(s1_D, 0.001);

						if (s1_time_norm <= 1.0) {
							float s1_rad = radians(outline_shine_angle);
							vec2 s1_trig = vec2(sin(s1_rad), cos(s1_rad));
							float s1_pos = s1_origin + (outline_shine_reverse ? -s1_sweep_time : s1_sweep_time);
							float s1_soft_w = outline_shine_width * (1.0 - outline_shine_softness);
							float added_shine_alpha = outline_shine_color.a * get_shine_alpha(
								outline_shine_style, outline_shine_half_sweep,
								path_t, UV, s1_trig, outline_shine_delay, outline_shine_width,
								s1_soft_w, s1_pos, s1_time_norm, outline_shine_opacity_curve
							);
							out_color.rgb += outline_shine_color.rgb * added_shine_alpha * outline_shine_intensity;
							out_color.a = clamp(out_color.a + added_shine_alpha, 0.0, 1.0);
						}
					}
					
					// SHINE 2 RENDER (uniform sweep phase skipped entirely during delay pause)
					if (outline_enable_shine_2) {
						float s2_D = 1.0;
						float s2_s = 0.0;
						bool s2_cont = outline_shine_2_delay == 0.0;
						float sweep_dist_2 = outline_shine_2_half_sweep ? 0.5 : 1.0;
						if (outline_shine_2_style == 0) {
							float sweep_dist_lin = outline_shine_2_half_sweep ? 0.5 : 1.5;
							s2_s = -0.25 - outline_shine_2_width;
							s2_D = sweep_dist_lin + outline_shine_2_width * 2.0;
						} else {
							s2_s = s2_cont ? 0.0 : -outline_shine_2_width;
							s2_D = s2_cont ? sweep_dist_2 : sweep_dist_2 + outline_shine_2_width * 2.0;
						}
						float s2_origin = outline_shine_2_reverse ? (s2_s + s2_D) : s2_s;
						float s2_cycle = s2_D + outline_shine_2_delay * outline_shine_2_speed;
						float s2_sweep_time = mod(TIME * outline_shine_2_speed, s2_cycle);
						float s2_time_norm = s2_sweep_time / max(s2_D, 0.001);

						if (s2_time_norm <= 1.0) {
							float s2_rad = radians(outline_shine_2_angle);
							vec2 s2_trig = vec2(sin(s2_rad), cos(s2_rad));
							float s2_pos = s2_origin + (outline_shine_2_reverse ? -s2_sweep_time : s2_sweep_time);
							float s2_soft_w = outline_shine_2_width * (1.0 - outline_shine_2_softness);
							float added_shine_alpha = outline_shine_2_color.a * get_shine_alpha(
								outline_shine_2_style, outline_shine_2_half_sweep,
								path_t, UV, s2_trig, outline_shine_2_delay, outline_shine_2_width,
								s2_soft_w, s2_pos, s2_time_norm, outline_shine_2_opacity_curve
							);
							out_color.rgb += outline_shine_2_color.rgb * added_shine_alpha * outline_shine_2_intensity;
							out_color.a = clamp(out_color.a + added_shine_alpha, 0.0, 1.0);
						}
					}

					bool has_out_cg = (outline_color_brightness != 0.0) || (outline_color_contrast != 1.0) || (outline_color_saturation != 1.0) || (outline_color_hue_shift_speed != 0.0);
					if (has_out_cg) {
						vec4 out_cg_0, out_cg_1, out_cg_2;
						get_cg_rows(outline_color_brightness, outline_color_contrast, outline_color_saturation, outline_color_hue_shift_speed, out_cg_0, out_cg_1, out_cg_2);
						vec4 out_rgb1 = vec4(out_color.rgb, 1.0);
						out_color.rgb = vec3(dot(out_cg_0, out_rgb1), dot(out_cg_1, out_rgb1), dot(out_cg_2, out_rgb1));
					}

					if (has_base_cg && !outline_ignore_base_color_grading) {
						vec4 out_base_rgb1 = vec4(out_color.rgb, 1.0);
						out_color.rgb = vec3(dot(base_cg_0, out_base_rgb1), dot(base_cg_1, out_base_rgb1), dot(base_cg_2, out_base_rgb1));
					}

					out_blend = outline_mask * out_color.a;
				}
			}
		}

		// GLOBAL POLISH & FX (base-only FX skipped under opaque outline pixels)
		float scan_flicker = (scanline_flicker_intensity > 0.0)
			? (1.0 - (sin(mod(TIME * scanline_flicker_speed, PI_TWO)) * 0.5 + 0.5) * scanline_flicker_intensity)
			: 1.0;
		bool active_scanlines = enable_scanlines && scanline_opacity > 0.0 && scan_flicker > 0.0 && (scanline_use_gradient || scanline_color.a > 0.0);
		vec4 scan_tint = vec4(0.0);
		int scan_unified_blend = 0;
		if (active_scanlines && (!scanline_base_only || out_blend < 1.0)) {
			scan_unified_blend = (scanline_blend_mode + 1) & 3;
			float scan_phase = mod(TIME * scanline_speed, PI_TWO) + scanline_offset * PI_TWO;
			float scan_rad = radians(scanline_rotation);
			vec2 scan_trig = vec2(sin(scan_rad), cos(scan_rad));
			scan_tint = evaluate_scanlines(uv_cen, UV, scan_trig, scan_flicker, scan_phase);
			if (scanline_base_only) {
				final_color.rgb = apply_fx_blend(final_color.rgb, scan_tint, scan_unified_blend);
			}
		}

		bool active_liquid_stripes = enable_liquid_stripes && liquid_stripes_opacity > 0.0 && (liquid_stripes_thickness > 0.0 || liquid_stripes_bg_color.a > 0.0);
		vec4 ls_tint = vec4(0.0);
		if (active_liquid_stripes && (!liquid_stripes_base_only || out_blend < 1.0)) {
			float ls_time = mod(TIME * liquid_stripes_speed, PI_TWO);
			float ls_angle = radians(liquid_stripes_rotation) - 0.2 + sin(ls_time) * (0.05 * liquid_stripes_sway);
			vec2 ls_trig = vec2(sin(ls_angle), cos(ls_angle));
			float ls_warp_amp = cos(radians(liquid_stripes_warp_direction)) * (0.2 * liquid_stripes_warp);
			ls_tint = evaluate_liquid_stripes(uv_cen, UV, ls_trig, ls_time, ls_warp_amp);
			if (liquid_stripes_base_only) {
				final_color.rgb = apply_fx_blend(final_color.rgb, ls_tint, liquid_stripes_blend_mode);
			}
		}

		// Composite Outline onto Base + Base-Only FX
		if (out_blend > 0.0) {
			final_color.rgb = mix(final_color.rgb, out_color.rgb, out_blend);
			final_color.a = max(final_color.a, out_blend);
		}

		final_color.a *= shape_alpha;

		// Global (Full-Shape) Scanlines & Liquid Stripes
		if (active_scanlines && !scanline_base_only) {
			final_color.rgb = apply_fx_blend(final_color.rgb, scan_tint, scan_unified_blend);
		}
		if (active_liquid_stripes && !liquid_stripes_base_only) {
			final_color.rgb = apply_fx_blend(final_color.rgb, ls_tint, liquid_stripes_blend_mode);
		}
		if (gamma_correction != 1.0) final_color.rgb = pow(max(final_color.rgb, 0.0), vec3(1.0 / max(gamma_correction, 0.0001)));
		if (enable_dithering) final_color.rgb += ign_dither(FRAGCOORD.xy) * 0.015 - 0.0075;

		COLOR = final_color;
	}
}