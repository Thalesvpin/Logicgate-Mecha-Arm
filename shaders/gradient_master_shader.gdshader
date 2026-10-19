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

// SUBGROUP: Base Pulsation Effects
group_uniforms Base_Gradient.Pulsation_Effects;
uniform bool enable_pulsation = false;
uniform sampler2D base_pulse_curve : hint_default_black, filter_linear, repeat_disable;
uniform float animation_speed : hint_range(0.0, 10.0) = 1.0;
uniform float pulse_min_offset : hint_range(-2.0, 2.0) = -0.5;
uniform float pulse_max_offset : hint_range(-2.0, 2.0) = 0.5;

// SUBGROUP: Distortion & Turbulence
group_uniforms Base_Gradient.Distortion;
uniform sampler2D noise_texture : repeat_enable, filter_linear;
uniform float distortion_strength : hint_range(0.0, 0.5) = 0.0;
uniform vec2 distortion_speed = vec2(0.1, 0.1);

// =============================================================================
// MAIN GROUP 2: Overlay Settings
// =============================================================================
group_uniforms Overlay_Settings;
uniform bool enable_overlay = false;
uniform int overlay_blend_mode : hint_enum("Normal", "Multiply", "Add", "Screen") = 0;

// SUBGROUP: Overlay Color
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
uniform float overlay_pulse_min_offset : hint_range(-2.0, 2.0) = -0.5;
uniform float overlay_pulse_max_offset : hint_range(-2.0, 2.0) = 0.5;

// SUBGROUP: Overlay Opacity (Spatial Gradient + Anim Curve)
group_uniforms Overlay_Settings.Opacity;
uniform bool enable_overlay_opacity = false;
uniform sampler2D overlay_opacity_texture : hint_default_white, filter_linear, repeat_disable; // REVERTED to standard texture slot for Gradient1D
uniform int overlay_opacity_type : hint_enum("Horizontal", "Vertical", "Radial", "Mirrored") = 2;
uniform float overlay_opacity_rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform float overlay_opacity_scale : hint_range(0.1, 10.0) = 1.0;
uniform float overlay_opacity_smoothing : hint_range(0.0, 5.0) = 0.5;
uniform float overlay_opacity_offset : hint_range(-2.0, 2.0) = 0.0;
uniform bool overlay_opacity_repeat = false;

group_uniforms Overlay_Settings.Opacity_Pulsation;
uniform bool overlay_opacity_enable_pulsation = false;
uniform sampler2D overlay_opacity_pulse_curve : hint_default_black, filter_linear, repeat_disable; // KEEPS Curve control for animation
uniform float overlay_opacity_animation_speed : hint_range(0.0, 10.0) = 1.0;
uniform float overlay_opacity_pulse_min_offset : hint_range(-2.0, 2.0) = -0.5;
uniform float overlay_opacity_pulse_max_offset : hint_range(-2.0, 2.0) = 0.5;

// =============================================================================
// MAIN GROUP 3: Shape & Corners
// =============================================================================
group_uniforms Shape_And_Corners;
uniform float corner_radius : hint_range(0.0, 500.0) = 0.0;

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

// SUBGROUP: Outline Pulsation Settings
group_uniforms Outline_Settings.Pulsation_Effects;
uniform bool outline_enable_pulsation = false;
uniform sampler2D outline_pulse_curve : hint_default_black, filter_linear, repeat_disable;
uniform float outline_animation_speed : hint_range(0.0, 10.0) = 1.0;
uniform float outline_pulse_min_offset : hint_range(-2.0, 2.0) = -0.5;
uniform float outline_pulse_max_offset : hint_range(-2.0, 2.0) = 0.5;

// SUBGROUP: Outline Shine
group_uniforms Outline_Settings.Shine;
uniform bool outline_enable_shine = false;
uniform vec4 outline_shine_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_shine_intensity : hint_range(0.1, 10.0) = 1.0;
uniform sampler2D outline_shine_opacity_curve : hint_default_white, filter_linear, repeat_disable;
uniform float outline_shine_speed : hint_range(0.0, 10.0) = 1.0;
uniform float outline_shine_delay : hint_range(0.0, 10.0) = 2.0; 
uniform float outline_shine_width : hint_range(0.01, 1.0) = 0.15;
uniform float outline_shine_softness : hint_range(0.0, 1.0) = 0.5; 
uniform float outline_shine_angle : hint_range(0.0, 360.0) = 45.0;
uniform bool outline_shine_reverse = false;

// =============================================================================
// MAIN GROUP 5: Polish
// =============================================================================
group_uniforms Polish;
uniform bool enable_dithering = true;

// =============================================================================
// VARYINGS (Pre-calculated optimizations)
// =============================================================================
group_uniforms; 

varying vec2 local_pos;
varying flat float v_exp_double;
varying flat vec2 v_trig_grad;
varying flat vec2 v_trig_over_color;
varying flat vec2 v_trig_over_opacity;
varying flat vec2 v_trig_out;
varying flat vec2 v_trig_shine;
varying flat float v_inv_grad_scale;
varying flat float v_inv_over_color_scale;
varying flat float v_inv_over_opacity_scale;
varying flat float v_inv_out_scale;
varying flat float v_shine_cycle;
varying flat float v_shine_start;
varying flat float v_shine_end;
varying flat float v_shine_solid_core;
varying flat float v_outline_mask_edge;
varying flat float v_shape_alpha_edge;
varying flat float v_shape_alpha_edge_blend;

void vertex() {
	float exp = 2.0; 
	if (enable_outline) exp += outline_width + outline_blur;
	v_exp_double = exp * 2.0;
	
	VERTEX += (UV - 0.5) * v_exp_double;
	local_pos = VERTEX; 

	float r_grad = radians(gradient_rotation_degrees);
	v_trig_grad = vec2(sin(r_grad), cos(r_grad));

	float r_over_col = radians(overlay_gradient_rotation_degrees);
	v_trig_over_color = vec2(sin(r_over_col), cos(r_over_col));

	float r_over_op = radians(overlay_opacity_rotation_degrees);
	v_trig_over_opacity = vec2(sin(r_over_op), cos(r_over_op));

	float r_out = radians(outline_gradient_rotation_degrees);
	v_trig_out = vec2(sin(r_out), cos(r_out));

	float r_shine = radians(outline_shine_angle);
	v_trig_shine = vec2(sin(r_shine), cos(r_shine));

	v_inv_grad_scale = 1.0 / max(gradient_scale, 0.001);
	v_inv_over_color_scale = 1.0 / max(overlay_gradient_scale, 0.001);
	v_inv_over_opacity_scale = 1.0 / max(overlay_opacity_scale, 0.001);
	v_inv_out_scale = 1.0 / max(outline_gradient_scale, 0.001);

	v_shine_cycle = 1.0 + (outline_shine_delay * outline_shine_speed);
	float sweep_bound = 0.75 + outline_shine_width;
	
	v_shine_start = outline_shine_reverse ? 0.5 + sweep_bound : 0.5 - sweep_bound;
	v_shine_end = outline_shine_reverse ? 0.5 - sweep_bound : 0.5 + sweep_bound;
	
	v_shine_solid_core = outline_shine_width * (1.0 - outline_shine_softness);
	
	v_outline_mask_edge = 1.0 + outline_blur;
	v_shape_alpha_edge = enable_outline ? outline_width : 0.0;
	v_shape_alpha_edge_blend = v_shape_alpha_edge + 1.5;
}

// --- HARDWARE-ACCELERATED HELPER FUNCTIONS ---

float calculate_smoothed_factor(float factor, float smoothing) {
	if (smoothing < 0.5) {
		return mix(step(0.5, factor), factor, smoothing * 2.0);
	} else if (smoothing <= 1.0) {
		return mix(factor, smoothstep(0.0, 1.0, factor), (smoothing - 0.5) * 2.0);
	} else {
		return mix(pow(factor, smoothing), 1.0 - pow(1.0 - factor, smoothing), factor);
	}
}

float random(vec2 uv) {
	return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float rounded_box_sdf(vec2 p, vec2 b, float r) {
	vec2 q = abs(p) - b + vec2(r);
	return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

float get_gradient_factor(vec2 uv_cen, vec2 trig, float inv_scale, int type, float final_offset, bool rep, float smooth_val) {
	vec2 uv = vec2(
		uv_cen.x * trig.y - uv_cen.y * trig.x,
		uv_cen.x * trig.x + uv_cen.y * trig.y
	) + 0.5;
	
	float factor = 0.0;
	switch (type) {
		case 0: factor = uv.x * inv_scale; break;
		case 1: factor = uv.y * inv_scale; break;
		case 2: factor = distance(uv, vec2(0.5)) * inv_scale * 2.0; break;
		case 3: factor = abs(uv.y - 0.5) * inv_scale * 2.0; break;
	}

	factor -= final_offset;
	factor = rep ? fract(factor) : clamp(factor, 0.0, 1.0);

	return calculate_smoothed_factor(factor, smooth_val);
}

void fragment() {
	vec2 uv_cen = UV - 0.5;
	vec2 d_local = fwidth(local_pos);
	vec2 d_uv = fwidth(UV);
	vec2 expanded_size = d_local / max(d_uv, vec2(0.00001));

	vec2 rect_size = expanded_size - v_exp_double;
	vec2 pixel_pos = uv_cen * expanded_size;
	vec2 base_uv_cen = pixel_pos / max(rect_size, vec2(0.001));

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
		float pulse_eval = texture(base_pulse_curve, vec2(fract(TIME * animation_speed), 0.0)).r;
		base_offset = mix(pulse_min_offset, pulse_max_offset, pulse_eval);
	}
	
	float base_factor = get_gradient_factor(distorted_uv_cen, v_trig_grad, v_inv_grad_scale, gradient_type, base_offset, repeat_gradient, gradient_smoothing);
	vec4 final_color = texture(gradient_texture, vec2(base_factor, 0.0));

	// ------------------------------------------
	// PASS 2: Overlay Color & Opacity
	// ------------------------------------------
	if (enable_overlay) {
		// Overlay Color
		float over_col_offset = overlay_gradient_offset;
		if (overlay_enable_pulsation) {
			float pulse_eval = texture(overlay_color_pulse_curve, vec2(fract(TIME * overlay_animation_speed), 0.0)).r;
			over_col_offset = mix(overlay_pulse_min_offset, overlay_pulse_max_offset, pulse_eval);
		}
		
		float over_col_factor = get_gradient_factor(base_uv_cen, v_trig_over_color, v_inv_over_color_scale, overlay_gradient_type, over_col_offset, overlay_repeat_gradient, overlay_gradient_smoothing);
		vec4 over_layer = texture(overlay_gradient_texture, vec2(over_col_factor, 0.0));
		
		// Overlay Opacity
		if (enable_overlay_opacity) {
			float over_op_offset = overlay_opacity_offset;
			if (overlay_opacity_enable_pulsation) {
				float op_pulse_eval = texture(overlay_opacity_pulse_curve, vec2(fract(TIME * overlay_opacity_animation_speed), 0.0)).r;
				over_op_offset = mix(overlay_opacity_pulse_min_offset, overlay_opacity_pulse_max_offset, op_pulse_eval);
			}
			
			float over_op_factor = get_gradient_factor(base_uv_cen, v_trig_over_opacity, v_inv_over_opacity_scale, overlay_opacity_type, over_op_offset, overlay_opacity_repeat, overlay_opacity_smoothing);
			
			// Evaluate the spatial opacity Gradient1D (reads the Red/Grayscale channel to act as an alpha mask)
			float mask_val = texture(overlay_opacity_texture, vec2(over_op_factor, 0.0)).r;
			over_layer.a *= mask_val;
		}

		// Apply Blend Mode
		switch (overlay_blend_mode) {
			case 0: final_color.rgb = mix(final_color.rgb, over_layer.rgb, over_layer.a); break;
			case 1: final_color.rgb = mix(final_color.rgb, final_color.rgb * over_layer.rgb, over_layer.a); break;
			case 2: final_color.rgb += (over_layer.rgb * over_layer.a); break;
			case 3: final_color.rgb = 1.0 - (1.0 - final_color.rgb) * (1.0 - (over_layer.rgb * over_layer.a)); break;
		}
	}

	// ------------------------------------------
	// PASS 3: Shape & Outline Gradient
	// ------------------------------------------
	vec2 half_size = rect_size * 0.5;
	float d = rounded_box_sdf(pixel_pos, half_size, min(corner_radius, min(half_size.x, half_size.y)));
	
	if (enable_outline) {
		float out_offset = outline_gradient_offset;
		if (outline_enable_pulsation) {
			float out_pulse_eval = texture(outline_pulse_curve, vec2(fract(TIME * outline_animation_speed), 0.0)).r;
			out_offset = mix(outline_pulse_min_offset, outline_pulse_max_offset, out_pulse_eval);
		}
		
		float out_factor = get_gradient_factor(distorted_uv_cen, v_trig_out, v_inv_out_scale, outline_gradient_type, out_offset, outline_repeat_gradient, outline_gradient_smoothing);
		vec4 out_color = texture(outline_gradient_texture, vec2(out_factor, 0.0));

		if (outline_enable_shine) {
			vec2 shine_uv = vec2(
				base_uv_cen.x * v_trig_shine.y - base_uv_cen.y * v_trig_shine.x,
				base_uv_cen.x * v_trig_shine.x + base_uv_cen.y * v_trig_shine.y
			) + 0.5;
			
			float sweep_time = mod(TIME * outline_shine_speed, v_shine_cycle);
			
			float current_shine_pos = sweep_time <= 1.0 ? mix(v_shine_start, v_shine_end, sweep_time) : -10.0;
			float shine_power = 1.0 - smoothstep(v_shine_solid_core, outline_shine_width, abs(shine_uv.x - current_shine_pos));
			
			float current_shine_opacity = texture(outline_shine_opacity_curve, vec2(clamp(sweep_time, 0.0, 1.0), 0.0)).r;
			float added_shine_alpha = shine_power * outline_shine_color.a * current_shine_opacity;
			
			out_color.rgb += outline_shine_color.rgb * added_shine_alpha * outline_shine_intensity;
			out_color.a = clamp(out_color.a + added_shine_alpha, 0.0, 1.0);
		}

		float outline_mask = smoothstep(0.0, v_outline_mask_edge, d);
		final_color.rgb = mix(final_color.rgb, out_color.rgb, outline_mask * out_color.a);
		final_color.a = max(final_color.a, outline_mask * out_color.a);
	}

	final_color.a *= 1.0 - smoothstep(v_shape_alpha_edge, v_shape_alpha_edge_blend, d);

	// ------------------------------------------
	// ANTI-BANDING (Dithering)
	// ------------------------------------------
	if (enable_dithering) {
		final_color.rgb += (vec3(random(FRAGCOORD.xy)) * 0.015) - 0.0075;
	}

	COLOR = final_color;
}