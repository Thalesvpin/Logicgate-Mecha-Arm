shader_type canvas_item;

// Top-level Global Controls
uniform vec4 helix_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float depth_contrast : hint_range(0.0, 1.0) = 0.8;

group_uniforms Background;
uniform int background_mode : hint_enum("Solid Color", "Gradient", "Texture") = 0;
uniform vec4 background_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 background_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Gradient Mode Settings
uniform sampler2D background_gradient : source_color, filter_linear, repeat_disable;
uniform int bg_gradient_type : hint_enum("Horizontal", "Vertical", "Radial", "Mirrored") = 0;
uniform float bg_gradient_smoothing : hint_range(0.0, 1.0) = 0.5;

// Texture Mode Settings
uniform sampler2D background_texture : source_color, filter_linear, repeat_enable;

// Shared Transform & Smooth Scroll (Gradient & Texture modes)
uniform vec2 bg_scale = vec2(1.0, 1.0);
uniform vec2 bg_offset = vec2(0.0, 0.0);
uniform float bg_rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform bool bg_enable_scroll = false;
uniform vec2 bg_scroll_speed = vec2(0.1, 0.0);
uniform bool bg_repeat = true;
group_uniforms;

group_uniforms Individual_Colors;
uniform bool use_individual_colors = false;
uniform vec4 row1_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 row2_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D rung_gradient : source_color, hint_default_white, repeat_disable;
group_uniforms;

group_uniforms Helix_Global;
uniform float scale : hint_range(0.5, 20.0) = 5.0;
uniform float angle : hint_range(-3.14159, 3.14159) = 0.3;
uniform float twist_density : hint_range(0.05, 2.0) = 0.4;
uniform float amplitude : hint_range(0.2, 4.0) = 2.0;
uniform float scroll_speed : hint_range(-5.0, 5.0) = 0.5;
uniform float rotation_speed : hint_range(-5.0, 5.0) = 1.0;
group_uniforms;

group_uniforms Shapes;
uniform int row1_shape : hint_enum("Circle", "Square", "Hexagon", "Triangle") = 0;
uniform int row2_shape : hint_enum("Circle", "Square", "Hexagon", "Triangle") = 0;
uniform float row1_base_radius : hint_range(0.02, 0.5) = 0.2;
uniform float row2_base_radius : hint_range(0.02, 0.5) = 0.2;
uniform float node_depth_scale : hint_range(0.0, 0.3) = 0.1;
uniform float rung_thickness : hint_range(0.5, 6.0) = 2.0;
uniform float rung_sharpness : hint_range(0.0, 1.0) = 0.0;
group_uniforms;

group_uniforms Node_Spin;
uniform bool spin_row1_nodes = false;
uniform float row1_spin_speed : hint_range(-10.0, 10.0) = 2.0;
uniform bool spin_row2_nodes = false;
uniform float row2_spin_speed : hint_range(-10.0, 10.0) = 2.0;
group_uniforms;

group_uniforms Shine_1;
uniform bool enable_shine_1 = false;
uniform int shine_1_blend_mode : hint_enum("Add", "Mix", "Screen", "Multiply", "Overlay", "Soft Light", "Subtract") = 0;
uniform vec4 shine_1_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float shine_1_intensity : hint_range(0.0, 5.0) = 1.5;
uniform float shine_1_speed : hint_range(-5.0, 5.0) = 0.6;
uniform float shine_1_width : hint_range(0.05, 5.0) = 1.2;
uniform float shine_1_softness : hint_range(0.0, 1.0) = 0.7;
uniform float shine_1_slant : hint_range(-2.0, 2.0) = 0.35;
uniform float shine_1_interval : hint_range(0.0, 5.0) = 0.5;
uniform bool shine_1_exclude_row1 = false;
uniform bool shine_1_exclude_row2 = false;
uniform bool shine_1_exclude_rung = false;
group_uniforms;

group_uniforms Shine_2;
uniform bool enable_shine_2 = false;
uniform int shine_2_blend_mode : hint_enum("Add", "Mix", "Screen", "Multiply", "Overlay", "Soft Light", "Subtract") = 0;
uniform vec4 shine_2_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float shine_2_intensity : hint_range(0.0, 5.0) = 1.5;
uniform float shine_2_speed : hint_range(-5.0, 5.0) = 0.6;
uniform float shine_2_width : hint_range(0.05, 5.0) = 1.2;
uniform float shine_2_softness : hint_range(0.0, 1.0) = 0.7;
uniform float shine_2_slant : hint_range(-2.0, 2.0) = 0.35;
uniform float shine_2_interval : hint_range(0.0, 5.0) = 0.5;
uniform bool shine_2_exclude_row1 = false;
uniform bool shine_2_exclude_row2 = false;
uniform bool shine_2_exclude_rung = false;
group_uniforms;

group_uniforms Shape_And_Geometry;
uniform vec4 corner_radii = vec4(0.0); // TL, TR, BR, BL
uniform bool use_beveled_corners = false;
group_uniforms;

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
group_uniforms;

// Tightly packed interpolators (30 scalar floats total, safely under the 32-float mobile/GLES3 hardware limit)
varying vec2 v_local_pos;
varying flat vec4 v_helix_xform;    // xy = cos/sin(angle), zw = TIME * (scroll_speed, rotation_speed)
varying flat vec4 v_twist_and_base; // xy = cos/sin(twist_density), z = max_node_ext, w = 1.0 - depth_contrast
varying flat vec4 v_node_spins;     // xy = spin1 (cos, sin), zw = spin2 (cos, sin)
varying flat vec4 v_shine_params;   // x = s1_signed_t [-1..1], y = s2_signed_t [-1..1], z = s1_gain, w = s2_gain
varying flat vec4 v_shine_precomp;  // x = s1_inner, y = s2_inner, z = s1_base_pad, w = s2_base_pad
varying flat vec4 v_out_grad;       // xy = sin/cos(outline_grad_rot), z = inv_out_scale, w = exp_double
varying flat vec4 v_bg_xform;       // xy = sin/cos(bg_rot), zw = active_bg_offset
varying flat vec2 v_bg_inv_scale;   // xy = inv_bg_scale

// Returns circumradius bounding multiplier for Circle (0), Square (1), Hexagon (2), or Triangle (3)
float get_shape_extent_mult(int shape, bool is_spinning) {
	if (shape == 0) return 1.0;
	if (shape == 1) return is_spinning ? 1.42 : 1.0;
	if (shape == 2) return 1.16;
	return 1.62;
}

// Returns anti-aliased coverage for Circle (0), Square (1), Hexagon (2), or Triangle (3)
float eval_shape_alpha(vec2 p, float radius, float pixel_size, int shape, bool do_spin, vec2 spin_trig) {
	if (shape == 0) {
		float max_ext = radius + pixel_size;
		if (abs(p.x) >= max_ext || abs(p.y) >= max_ext) {
			return 0.0;
		}
		float r_min = max(radius - pixel_size, 0.0);
		return smoothstep(max_ext * max_ext, r_min * r_min, dot(p, p));
	}

	if (shape == 1) {
		float max_ext = (do_spin ? radius * 1.42 : radius) + pixel_size;
		if (abs(p.x) >= max_ext || abs(p.y) >= max_ext) {
			return 0.0;
		}
		if (do_spin) {
			p = vec2(p.x * spin_trig.x - p.y * spin_trig.y, p.x * spin_trig.y + p.y * spin_trig.x);
		}
		vec2 ap = abs(p);
		return smoothstep(radius + pixel_size, radius - pixel_size, max(ap.x, ap.y));
	}

	if (shape == 2) {
		float max_ext = radius * 1.16 + pixel_size;
		if (abs(p.x) >= max_ext || abs(p.y) >= max_ext) {
			return 0.0;
		}
		if (do_spin) {
			p = vec2(p.x * spin_trig.x - p.y * spin_trig.y, p.x * spin_trig.y + p.y * spin_trig.x);
		}
		vec2 ap = abs(p);
		return smoothstep(radius + pixel_size, radius - pixel_size, max(ap.x * 0.8660254 + ap.y * 0.5, ap.y));
	}

	// Triangle (shape == 3)
	float max_ext = radius * 1.62 + pixel_size;
	if (abs(p.x) >= max_ext || abs(p.y) >= max_ext) {
		return 0.0;
	}
	if (do_spin) {
		p = vec2(p.x * spin_trig.x - p.y * spin_trig.y, p.x * spin_trig.y + p.y * spin_trig.x);
	}
	const float k = 1.7320508;
	const float inv_k = 0.57735027;
	float tri_scale = max(radius * 1.4, 1e-5);
	float inv_tri_scale = 1.0 / tri_scale;
	vec2 tp = p * inv_tri_scale;
	tp.x = abs(tp.x) - 1.0;
	tp.y += inv_k;
	if (tp.x + k * tp.y > 0.0) {
		tp = vec2(tp.x - k * tp.y, -k * tp.x - tp.y) * 0.5;
	}
	tp.x -= clamp(tp.x, -2.0, 0.0);
	float norm_soft = pixel_size * inv_tri_scale;
	float tp_dist_sq = dot(tp, tp);
	if (abs(tp.y) > 0.0 && tp_dist_sq >= norm_soft * norm_soft) {
		return tp.y > 0.0 ? 1.0 : 0.0;
	}
	float signed_d = -sqrt(tp_dist_sq) * sign(tp.y);
	return smoothstep(norm_soft, -norm_soft, signed_d);
}

// Applies selected blend mode (0=Add, 1=Mix, 2=Screen, 3=Multiply, 4=Overlay, 5=Soft Light, 6=Subtract)
vec3 apply_shine_blend(vec3 base, vec3 blend_col, float strength, int mode) {
	if (mode == 0) {
		return base + blend_col * strength;
	}
	if (mode == 6) {
		return max(base - blend_col * strength, vec3(0.0));
	}

	float t = clamp(strength, 0.0, 1.0);
	vec3 b = clamp(base, 0.0, 1.0);
	vec3 res = blend_col;

	if (mode == 2) {
		res = 1.0 - (1.0 - b) * (1.0 - blend_col);
	} else if (mode == 3) {
		res = b * blend_col;
	} else if (mode == 4) {
		vec3 lo = 2.0 * b * blend_col;
		vec3 hi = 1.0 - 2.0 * (1.0 - b) * (1.0 - blend_col);
		res = mix(lo, hi, step(0.5, b));
	} else if (mode == 5) {
		vec3 two_c = 2.0 * blend_col;
		vec3 one_minus_two_c = 1.0 - two_c;
		vec3 lo = b * (two_c + b * one_minus_two_c);
		if (any(greaterThan(blend_col, vec3(0.5)))) {
			vec3 hi = sqrt(b) * (-one_minus_two_c) + b * (2.0 - two_c);
			res = mix(lo, hi, step(0.5, blend_col));
		} else {
			res = lo;
		}
	}
	return mix(base, res, t);
}

// Evaluates a single helix column using precomputed sin_raw / cos_raw and composites into accum_rgb / accum_a
void eval_helix_cell(
	float sin_raw, float cos_raw, float dx, float uv_y, float safe_amp,
	float col_y_pad, float pixel_size, float half_rung_w, float inner_rung_w,
	vec4 col1, vec4 col2, bool spin1_active, bool spin2_active,
	float s1_r1, float s2_r1, float s1_r2, float s2_r2, float s1_rg, float s2_rg,
	inout vec3 accum_rgb, inout float accum_a
) {
	float sin_dna = sin_raw * safe_amp;
	float cut_up = abs(sin_dna);

	// Per-column vertical early-out: skip pixels in empty wave troughs before evaluating nodes or rungs
	float abs_uv_y = abs(uv_y);
	if (abs_uv_y >= cut_up + col_y_pad) {
		return;
	}

	// Branchless analytical depth & shading
	float depth1 = 0.5 * (1.0 - cos_raw);
	float depth2 = 1.0 - depth1;
	float shade1 = depth1 * depth_contrast + v_twist_and_base.w;
	float shade2 = depth2 * depth_contrast + v_twist_and_base.w;

	// Evaluate Row 1 (+1.0) and Row 2 (-1.0) node coverages
	float radius1 = row1_base_radius + depth1 * node_depth_scale;
	float radius2 = row2_base_radius + depth2 * node_depth_scale;
	float node1_a = eval_shape_alpha(vec2(dx, uv_y - sin_dna), radius1, pixel_size, row1_shape, spin1_active, v_node_spins.xy);
	float node2_a = eval_shape_alpha(vec2(dx, uv_y + sin_dna), radius2, pixel_size, row2_shape, spin2_active, v_node_spins.zw);

	// Rung line SDF with single symmetric vertical cap mask
	float abs_dx = abs(dx);
	if (abs_dx < half_rung_w && abs_uv_y < cut_up + pixel_size) {
		float line = smoothstep(half_rung_w, inner_rung_w, abs_dx);
		float cap_mask = smoothstep(cut_up + pixel_size, cut_up - pixel_size, abs_uv_y);
		float line_cov = line * cap_mask;

		if (line_cov > 0.0) {
			float grad_t = clamp(uv_y / max(2.0 * cut_up, 1e-5) + 0.5, 0.0, 1.0);
			grad_t = sin_raw > 0.0 ? (1.0 - grad_t) : grad_t;
			float line_shade = mix(shade1, shade2, grad_t);

			vec4 col_rung = use_individual_colors
				? textureLod(rung_gradient, vec2(grad_t, 0.5), 0.0)
				: helix_color;

			vec3 rung_rgb = col_rung.rgb * line_shade;
			if (s1_rg > 0.0) {
				rung_rgb = apply_shine_blend(rung_rgb, shine_1_color.rgb, s1_rg, shine_1_blend_mode);
			}
			if (s2_rg > 0.0) {
				rung_rgb = apply_shine_blend(rung_rgb, shine_2_color.rgb, s2_rg, shine_2_blend_mode);
			}

			float rung_a = line_cov * col_rung.a;
			float rem_a = 1.0 - rung_a;
			accum_rgb = accum_rgb * rem_a + rung_rgb * rung_a;
			accum_a = accum_a * rem_a + rung_a;
		}
	}

	// Skip node color & shine math completely if neither node covers this pixel
	if (node1_a <= 0.0 && node2_a <= 0.0) {
		return;
	}

	vec3 row1_rgb = vec3(0.0);
	if (node1_a > 0.0) {
		row1_rgb = col1.rgb * shade1;
		if (s1_r1 > 0.0) {
			row1_rgb = apply_shine_blend(row1_rgb, shine_1_color.rgb, s1_r1, shine_1_blend_mode);
		}
		if (s2_r1 > 0.0) {
			row1_rgb = apply_shine_blend(row1_rgb, shine_2_color.rgb, s2_r1, shine_2_blend_mode);
		}
	}

	vec3 row2_rgb = vec3(0.0);
	if (node2_a > 0.0) {
		row2_rgb = col2.rgb * shade2;
		if (s1_r2 > 0.0) {
			row2_rgb = apply_shine_blend(row2_rgb, shine_1_color.rgb, s1_r2, shine_1_blend_mode);
		}
		if (s2_r2 > 0.0) {
			row2_rgb = apply_shine_blend(row2_rgb, shine_2_color.rgb, s2_r2, shine_2_blend_mode);
		}
	}

	// Branchless back-to-front depth sorting: rung sits behind both node faces
	bool n1_in_front = shade1 > shade2;
	float back_cov = n1_in_front ? node2_a : node1_a;
	vec3 back_rgb = n1_in_front ? row2_rgb : row1_rgb;
	float back_col_a = n1_in_front ? col2.a : col1.a;

	float front_cov = n1_in_front ? node1_a : node2_a;
	vec3 front_rgb = n1_in_front ? row1_rgb : row2_rgb;
	float front_col_a = n1_in_front ? col1.a : col2.a;

	float back_a = back_cov * back_col_a;
	if (back_a > 0.0) {
		float rem_a = 1.0 - back_a;
		accum_rgb = accum_rgb * rem_a + back_rgb * back_a;
		accum_a = accum_a * rem_a + back_a;
	}

	float front_a = front_cov * front_col_a;
	if (front_a > 0.0) {
		float rem_a = 1.0 - front_a;
		accum_rgb = accum_rgb * rem_a + front_rgb * front_a;
		accum_a = accum_a * rem_a + front_a;
	}
}

// Outline gradient smoothing & mapping helpers
float calculate_smoothed_factor(float factor, float smoothing) {
	if (smoothing == 0.5) return factor;
	if (smoothing < 0.5) return mix(step(0.5, factor), factor, smoothing * 2.0);
	if (smoothing <= 1.0) return mix(factor, smoothstep(0.0, 1.0, factor), (smoothing - 0.5) * 2.0);
	return mix(pow(max(factor, 0.00001), smoothing), 1.0 - pow(max(1.0 - factor, 0.00001), smoothing), factor);
}

float get_gradient_factor(vec2 normalized_uv, vec2 trig, float inv_scale, int type, float final_offset, bool rep, float smooth_val) {
	float factor = 0.0;
	if (type == 0) {
		factor = dot(normalized_uv, vec2(trig.y, -trig.x));
	} else if (type == 1) {
		factor = dot(normalized_uv, trig);
	} else if (type == 2) {
		vec2 uv = vec2(dot(normalized_uv, vec2(trig.y, -trig.x)), dot(normalized_uv, trig));
		factor = length(uv - 0.5) * 2.0;
	} else {
		factor = abs(dot(normalized_uv, trig) - 0.5) * 2.0;
	}

	factor = (factor * inv_scale) - final_offset;
	factor = rep ? fract(factor) : clamp(factor, 0.0, 1.0);
	return calculate_smoothed_factor(factor, smooth_val);
}

// Continuous background gradient curve (0.0 = crisp anti-aliased transition, 0.5 = linear, 1.0 = smooth quintic S-curve)
float smooth_bg_gradient(float t, float smoothing) {
	if (abs(smoothing - 0.5) < 1e-4) {
		return t;
	}
	if (smoothing > 0.5) {
		float t2 = t * t;
		float quintic = t2 * t * (t * (t * 6.0 - 15.0) + 10.0);
		return mix(t, quintic, (smoothing - 0.5) * 2.0);
	}
	float half_w = max(smoothing, 1e-4);
	float step_curve = smoothstep(0.5 - half_w, 0.5 + half_w, t);
	float blend_to_linear = smoothing * 2.0;
	return mix(step_curve, t, blend_to_linear * blend_to_linear);
}

// Evaluates Solid Color (0), Gradient (1), or Texture (2) background centered at (0.5, 0.5)
vec4 eval_background(vec2 rect_uv, vec2 bg_uv_dx, vec2 bg_uv_dy) {
	if (background_mode == 0) {
		return background_color;
	}

	vec2 trig = v_bg_xform.xy;
	vec2 scroll_off = v_bg_xform.zw;
	vec2 rot_x = vec2(trig.y, -trig.x);
	vec2 centered = rect_uv - 0.5;

	if (background_mode == 1) {
		float factor = 0.0;
		if (bg_gradient_type == 0) {
			factor = dot(centered, rot_x) * v_bg_inv_scale.x + 0.5;
		} else if (bg_gradient_type == 1) {
			factor = dot(centered, trig) * v_bg_inv_scale.x + 0.5;
		} else if (bg_gradient_type == 2) {
			vec2 rot_uv = vec2(dot(centered, rot_x), dot(centered, trig));
			factor = length(rot_uv * v_bg_inv_scale) * 2.0;
		} else {
			factor = abs(dot(centered, trig) * v_bg_inv_scale.x) * 2.0;
		}

		factor -= scroll_off.x;
		factor = bg_repeat ? fract(factor) : clamp(factor, 0.0, 1.0);
		factor = smooth_bg_gradient(factor, bg_gradient_smoothing);
		return textureLod(background_gradient, vec2(factor, 0.5), 0.0) * background_tint;
	}

	// Texture mode (2): centered rotation, 2D scale, offset, optional smooth 2D scroll, and seam-free mip derivatives
	vec2 rot_uv = vec2(dot(centered, rot_x), dot(centered, trig));
	vec2 tex_uv = rot_uv * v_bg_inv_scale + 0.5 - scroll_off;
	tex_uv = bg_repeat ? fract(tex_uv) : clamp(tex_uv, 0.0, 1.0);
	vec2 grad_x = vec2(dot(bg_uv_dx, rot_x), dot(bg_uv_dx, trig)) * v_bg_inv_scale;
	vec2 grad_y = vec2(dot(bg_uv_dy, rot_x), dot(bg_uv_dy, trig)) * v_bg_inv_scale;
	return textureGrad(background_texture, tex_uv, grad_x, grad_y) * background_tint;
}

void vertex() {
	// Expand mesh bounds only when an active outline or rounded/beveled corners need feathering
	bool outline_active = enable_outline && outline_width > 0.0;
	bool has_corners = dot(corner_radii, corner_radii) > 0.0;
	float exp_pad = outline_active ? (2.0 + outline_width + outline_blur) : (has_corners ? 1.0 : 0.0);
	float exp_double = exp_pad * 2.0;
	if (exp_double > 0.0) {
		VERTEX += (UV - 0.5) * exp_double;
	}
	v_local_pos = VERTEX;

	if (outline_active) {
		float out_rad = radians(outline_gradient_rotation_degrees);
		v_out_grad = vec4(sin(out_rad), cos(out_rad), 1.0 / max(outline_gradient_scale, 0.001), exp_double);
	} else {
		v_out_grad = vec4(0.0, 1.0, 1.0, exp_double);
	}

	if (background_mode != 0) {
		float bg_rad = radians(bg_rotation_degrees);
		v_bg_xform = vec4(sin(bg_rad), cos(bg_rad), bg_enable_scroll ? (bg_offset + TIME * bg_scroll_speed) : bg_offset);
		v_bg_inv_scale = 1.0 / max(abs(bg_scale), vec2(1e-4)) * sign(bg_scale + vec2(1e-7));
	} else {
		v_bg_xform = vec4(0.0, 1.0, 0.0, 0.0);
		v_bg_inv_scale = vec2(1.0);
	}

	// Precompute helix trig, twist step trig (for neighbor angle-addition), and time products once per vertex
	v_helix_xform = vec4(cos(angle), sin(angle), TIME * scroll_speed, TIME * rotation_speed);

	bool do_spin1 = spin_row1_nodes && row1_shape != 0 && row1_spin_speed != 0.0;
	vec2 spin1 = vec2(1.0, 0.0);
	if (do_spin1) {
		float spin1_angle = TIME * row1_spin_speed;
		spin1 = vec2(cos(spin1_angle), sin(spin1_angle));
	}

	bool do_spin2 = spin_row2_nodes && row2_shape != 0 && row2_spin_speed != 0.0;
	vec2 spin2 = vec2(1.0, 0.0);
	if (do_spin2) {
		float spin2_angle = TIME * row2_spin_speed;
		spin2 = vec2(cos(spin2_angle), sin(spin2_angle));
	}
	v_node_spins = vec4(spin1, spin2);

	float r1_ext = get_shape_extent_mult(row1_shape, do_spin1);
	float r2_ext = get_shape_extent_mult(row2_shape, do_spin2);
	float max_node_ext = max(
		(row1_base_radius + node_depth_scale) * r1_ext,
		(row2_base_radius + node_depth_scale) * r2_ext
	);
	v_twist_and_base = vec4(cos(twist_density), sin(twist_density), max_node_ext, 1.0 - depth_contrast);

	// Encode shine progress into signed [-1..1] space (-2.0 = inactive)
	float s1_signed_t = -2.0;
	float s1_gain = 0.0;
	if (enable_shine_1 && shine_1_intensity > 0.0 && shine_1_color.a > 0.0) {
		float cycle1 = 1.0 + shine_1_interval;
		float m1 = mod(TIME * abs(shine_1_speed), cycle1);
		float t1 = m1 * 2.0 - 1.0;
		s1_signed_t = (shine_1_speed >= 0.0) ? t1 : -t1;
		s1_gain = shine_1_intensity * shine_1_color.a;
	}

	float s2_signed_t = -2.0;
	float s2_gain = 0.0;
	if (enable_shine_2 && shine_2_intensity > 0.0 && shine_2_color.a > 0.0) {
		float cycle2 = 1.0 + shine_2_interval;
		float m2 = mod(TIME * abs(shine_2_speed), cycle2);
		float t2 = m2 * 2.0 - 1.0;
		s2_signed_t = (shine_2_speed >= 0.0) ? t2 : -t2;
		s2_gain = shine_2_intensity * shine_2_color.a;
	}
	v_shine_params = vec4(s1_signed_t, s2_signed_t, s1_gain, s2_gain);

	// Precompute frame-constant shine soft edges and base vertical slant padding
	float safe_amp = abs(amplitude);
	float base_height = safe_amp + max_node_ext;
	float s1_inner = max(shine_1_width * (1.0 - shine_1_softness) - 1e-5, 0.0);
	float s2_inner = max(shine_2_width * (1.0 - shine_2_softness) - 1e-5, 0.0);
	float s1_base_pad = shine_1_width + abs(shine_1_slant) * base_height;
	float s2_base_pad = shine_2_width + abs(shine_2_slant) * base_height;
	v_shine_precomp = vec4(s1_inner, s2_inner, s1_base_pad, s2_base_pad);
}

void fragment() {
	vec2 uv_cen = UV - 0.5;
	vec2 uv_deriv = max(fwidth(UV), vec2(1e-6));
	vec2 local_fwidth = fwidth(v_local_pos);

	// Zoom-invariant local ColorRect size
	vec2 expanded_size = local_fwidth / uv_deriv;
	vec2 rect_size = max(expanded_size - v_out_grad.w, vec2(0.001));
	vec2 inv_rect_size = 1.0 / rect_size;
	vec2 pixel_pos = uv_cen * expanded_size;

	// Compute background texture derivatives in uniform control flow only when Texture mode is active
	vec2 bg_uv_dx = vec2(0.0);
	vec2 bg_uv_dy = vec2(0.0);
	if (background_mode == 2) {
		vec2 uv_to_rect = expanded_size * inv_rect_size;
		bg_uv_dx = dFdx(UV) * uv_to_rect;
		bg_uv_dy = dFdy(UV) * uv_to_rect;
	}

	bool outline_active = enable_outline && outline_width > 0.0;
	bool has_corners = dot(corner_radii, corner_radii) > 0.0;

	// Skip the rounded-rect SDF completely when using a standard unrounded ColorRect without an outline
	float d = -10.0;
	float inner_mask = 1.0;
	vec2 rect_uv = UV;
	bool is_outside = false;

	if (outline_active || has_corners) {
		vec2 half_size = rect_size * 0.5;
		float r = 0.0;
		if (has_corners) {
			vec2 q_sign = step(0.0, pixel_pos);
			r = mix(
				mix(corner_radii.w, corner_radii.z, q_sign.x),
				mix(corner_radii.x, corner_radii.y, q_sign.x),
				q_sign.y
			);
			r = min(r, min(half_size.x, half_size.y));
		}

		vec2 q_box = abs(pixel_pos) - half_size + vec2(r);
		vec2 max_q_vec = max(q_box, 0.0);
		float max_q = max(q_box.x, q_box.y);
		float dist_inner = min(max_q, 0.0) - r;
		d = (use_beveled_corners && r > 0.0)
			? max(max_q, (max_q_vec.x + max_q_vec.y) * 0.70710678) + dist_inner
			: length(max_q_vec) + dist_inner;

		float outer_limit = max(v_out_grad.w * 0.5 - 0.5, 1.5);
		if (d > outer_limit) {
			is_outside = true;
		} else {
			inner_mask = 1.0 - smoothstep(-0.75, 0.75, d);
			rect_uv = pixel_pos * inv_rect_size + 0.5;
		}
	}

	if (is_outside) {
		COLOR = vec4(0.0);
	} else {
		vec3 inner_rgb = vec3(0.0);
		float inner_a = 0.0;

		if (inner_mask > 0.0) {
			vec3 accum_rgb = vec3(0.0);
			float accum_a = 0.0;

			// Skip all helix math when global helix color is fully transparent
			if (use_individual_colors || helix_color.a > 0.0) {
				float safe_scale = max(abs(scale), 1e-4);
				float safe_amp = abs(amplitude);
				float uv_scale = (2.0 * safe_scale) * inv_rect_size.y;
				float pixel_size = local_fwidth.y * uv_scale;
				vec2 uv = pixel_pos * vec2(uv_scale, -uv_scale);

				// Rotate into helix-aligned space (preserved un-scrolled for end-to-end shine sweeps)
				vec2 rot = v_helix_xform.xy;
				vec2 helix_uv = vec2(
					uv.x * rot.x + uv.y * rot.y,
					uv.y * rot.x - uv.x * rot.y
				);
				uv = vec2(helix_uv.x - v_helix_xform.z, helix_uv.y);

				float max_bound = safe_amp + v_twist_and_base.z + pixel_size;

				// Skip all helix math for pixels outside the diagonal band
				if (abs(uv.y) <= max_bound) {
					// Hoist rect-constant shine centers, rung dimensions, and element flags out of cell evaluation
					float base_span = 0.5 * (rect_size.x * abs(rot.x) + rect_size.y * abs(rot.y)) * uv_scale;

					float s1_str = 0.0;
					if (abs(v_shine_params.x) <= 1.0) {
						float s1_half_span = base_span + v_shine_precomp.z + abs(shine_1_slant) * pixel_size;
						float s1_center = s1_half_span * v_shine_params.x;
						float s1_dist = abs((helix_uv.x + helix_uv.y * shine_1_slant) - s1_center);
						if (s1_dist < shine_1_width) {
							s1_str = smoothstep(shine_1_width, v_shine_precomp.x, s1_dist) * v_shine_params.z;
						}
					}

					float s2_str = 0.0;
					if (abs(v_shine_params.y) <= 1.0) {
						float s2_half_span = base_span + v_shine_precomp.w + abs(shine_2_slant) * pixel_size;
						float s2_center = s2_half_span * v_shine_params.y;
						float s2_dist = abs((helix_uv.x + helix_uv.y * shine_2_slant) - s2_center);
						if (s2_dist < shine_2_width) {
							s2_str = smoothstep(shine_2_width, v_shine_precomp.y, s2_dist) * v_shine_params.w;
						}
					}

					// Pre-resolve per-element colors, spin flags, and shine strengths
					vec4 col1 = helix_color;
					vec4 col2 = helix_color;
					if (use_individual_colors) {
						col1 = row1_color;
						col2 = row2_color;
					}
					bool spin1_active = spin_row1_nodes && row1_spin_speed != 0.0;
					bool spin2_active = spin_row2_nodes && row2_spin_speed != 0.0;
					float s1_r1 = shine_1_exclude_row1 ? 0.0 : s1_str;
					float s2_r1 = shine_2_exclude_row1 ? 0.0 : s2_str;
					float s1_r2 = shine_1_exclude_row2 ? 0.0 : s1_str;
					float s2_r2 = shine_2_exclude_row2 ? 0.0 : s2_str;
					float s1_rg = shine_1_exclude_rung ? 0.0 : s1_str;
					float s2_rg = shine_2_exclude_rung ? 0.0 : s2_str;

					float line_index = floor(uv.x);
					float dx = fract(uv.x) - 0.5;
					float half_rung_w = pixel_size * rung_thickness;
					float inner_rung_w = max(half_rung_w - pixel_size * 0.5, 0.0) * rung_sharpness;
					float col_y_pad = v_twist_and_base.z + pixel_size;
					float max_cell_reach = max(v_twist_and_base.z, half_rung_w) + pixel_size;

					// Compute primary column trig once; derive adjacent columns via angle-addition identities
					float dna_phase = line_index * twist_density + v_helix_xform.w;
					float sin_raw = sin(dna_phase);
					float cos_raw = cos(dna_phase);
					float ct = v_twist_and_base.x;
					float st = v_twist_and_base.y;

					if (max_cell_reach - dx > 1.0) {
						float sin_n = sin_raw * ct - cos_raw * st;
						float cos_n = cos_raw * ct + sin_raw * st;
						eval_helix_cell(
							sin_n, cos_n, dx + 1.0, uv.y, safe_amp,
							col_y_pad, pixel_size, half_rung_w, inner_rung_w,
							col1, col2, spin1_active, spin2_active,
							s1_r1, s2_r1, s1_r2, s2_r2, s1_rg, s2_rg,
							accum_rgb, accum_a
						);
					}

					if (max_cell_reach + dx > 1.0) {
						float sin_n = sin_raw * ct + cos_raw * st;
						float cos_n = cos_raw * ct - sin_raw * st;
						eval_helix_cell(
							sin_n, cos_n, dx - 1.0, uv.y, safe_amp,
							col_y_pad, pixel_size, half_rung_w, inner_rung_w,
							col1, col2, spin1_active, spin2_active,
							s1_r1, s2_r1, s1_r2, s2_r2, s1_rg, s2_rg,
							accum_rgb, accum_a
						);
					}

					eval_helix_cell(
						sin_raw, cos_raw, dx, uv.y, safe_amp,
						col_y_pad, pixel_size, half_rung_w, inner_rung_w,
						col1, col2, spin1_active, spin2_active,
						s1_r1, s2_r1, s1_r2, s2_r2, s1_rg, s2_rg,
						accum_rgb, accum_a
					);
				}
			}

			// Skip background evaluation completely on pixels already 100% covered by opaque helix geometry
			if (accum_a < 1.0) {
				vec4 bg_col = eval_background(rect_uv, bg_uv_dx, bg_uv_dy);
				float bg_rem_a = bg_col.a * (1.0 - accum_a);
				float combined_inner_a = accum_a + bg_rem_a;
				if (combined_inner_a > 0.0) {
					inner_rgb = (accum_rgb + bg_col.rgb * bg_rem_a) / combined_inner_a;
				}
				inner_a = combined_inner_a * inner_mask;
			} else {
				inner_rgb = accum_rgb;
				inner_a = inner_mask;
			}
		}

		vec3 final_rgb = inner_rgb;
		float final_a = inner_a;

		// Composite outer outline ring around d = 0..outline_width
		if (outline_active && d > -0.75) {
			float out_inner = smoothstep(-0.75, 0.75 + outline_blur, d);
			float out_outer = 1.0 - smoothstep(outline_width - 0.75, outline_width + 0.75 + outline_blur, d);
			float outline_mask = out_inner * out_outer;

			if (outline_mask > 0.0) {
				float out_factor = get_gradient_factor(
					clamp(rect_uv, 0.0, 1.0), v_out_grad.xy, v_out_grad.z,
					outline_gradient_type, outline_gradient_offset,
					outline_repeat_gradient, outline_gradient_smoothing
				);
				vec4 out_color = textureLod(outline_gradient_texture, vec2(out_factor, 0.0), 0.0);
				float out_a = outline_mask * out_color.a;
				float rem_a = final_a * (1.0 - out_a);
				float combined_a = out_a + rem_a;
				if (combined_a > 0.0) {
					final_rgb = (out_color.rgb * out_a + final_rgb * rem_a) / combined_a;
				}
				final_a = combined_a;
			}
		}

		COLOR = vec4(final_rgb, final_a);
	}
}