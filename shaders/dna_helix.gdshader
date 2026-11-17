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

group_uniforms Helix_Blur;
uniform bool enable_helix_blur = false;
uniform float helix_blur_amount : hint_range(0.0, 2.0) = 0.25;
uniform float helix_blur_energy_retention : hint_range(0.0, 1.0) = 0.75;
uniform bool helix_blur_affect_nodes = true;
uniform bool helix_blur_affect_rungs = true;
group_uniforms;

group_uniforms Edge_Blur;
uniform bool enable_edge_blur = false;
uniform float edge_blur_amount : hint_range(0.0, 2.0) = 0.45;
uniform float edge_blur_reach : hint_range(1.0, 500.0) = 80.0;
uniform float edge_blur_falloff : hint_range(0.1, 5.0) = 1.5;
uniform float edge_blur_edge_offset : hint_range(0.0, 200.0) = 0.0;
uniform float edge_blur_energy_retention : hint_range(0.0, 1.0) = 0.75;
uniform bool edge_blur_affect_nodes = true;
uniform bool edge_blur_affect_rungs = true;
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

// Tightly packed interpolators (1 smooth vec2 + 8 flat vec4s) to minimize vertex-to-fragment bandwidth
varying vec2 v_local_pos;
varying flat vec4 v_helix_xform;   // xy = cos/sin(angle), zw = TIME * (scroll_speed, rotation_speed)
varying flat vec4 v_node_spins;    // xy = spin1 (cos, sin), zw = spin2 (cos, sin)
varying flat vec4 v_shine_params;  // x = shine_1_signed_t [-1..1], y = shine_2_signed_t [-1..1], z = shine_1_gain, w = shine_2_gain
varying flat vec4 v_precomp_1;     // x = s1_inner, y = s2_inner, z = g_node_blur, w = g_rung_blur
varying flat vec4 v_precomp_2;     // x = row1_ext_mult, y = row2_ext_mult, z = max_node_extent_base, w = base_shade
varying flat vec4 v_out_grad;      // xy = sin/cos(outline_grad_rot), z = inv_out_scale, w = exp_double
varying flat vec4 v_bg_xform;      // xy = sin/cos(bg_rot), zw = active_bg_offset
varying flat vec4 v_bg_misc;       // xy = inv_bg_scale, z = inv_edge_reach, w = outer_limit

// Returns circumradius bounding multiplier for Circle (0), Square (1), Hexagon (2), or Triangle (3)
float get_shape_extent_mult(int shape, bool is_spinning) {
	if (shape == 0) return 1.0;
	if (shape == 1) return is_spinning ? 1.42 : 1.0;
	if (shape == 2) return 1.16;
	return 1.62;
}

// Returns anti-aliased & energy-conserving blurred coverage for Circle (0), Square (1), Hexagon (2), or Triangle (3)
float eval_shape_alpha(vec2 p, float radius, float extent_mult, float pixel_size, float edge_soft, float blur_radius, float blur_85, float energy_retention, int shape, bool do_spin, vec2 spin_trig) {
	// Tight per-shape bounding box check
	float max_extent = radius * extent_mult + edge_soft;
	if (abs(p.x) >= max_extent || abs(p.y) >= max_extent) {
		return 0.0;
	}

	if (shape == 0) {
		if (blur_radius <= 0.0) {
			float r_min = max(radius - pixel_size, 0.0);
			float r_max = radius + pixel_size;
			return smoothstep(r_max * r_max, r_min * r_min, dot(p, p));
		}
		float spread_ratio = radius / max(radius + blur_85, 1e-5);
		float energy_scale = mix(spread_ratio * spread_ratio, 1.0, energy_retention);
		return smoothstep(radius + edge_soft, radius - edge_soft, length(p)) * energy_scale;
	}

	if (do_spin) {
		p = vec2(
			p.x * spin_trig.x - p.y * spin_trig.y,
			p.x * spin_trig.y + p.y * spin_trig.x
		);
	}

	float alpha = 0.0;
	if (shape == 1) {
		vec2 ap = abs(p);
		alpha = smoothstep(radius + edge_soft, radius - edge_soft, max(ap.x, ap.y));
	} else if (shape == 2) {
		vec2 ap = abs(p);
		alpha = smoothstep(radius + edge_soft, radius - edge_soft, max(ap.x * 0.8660254 + ap.y * 0.5, ap.y));
	} else {
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
		float norm_soft = edge_soft * inv_tri_scale;
		float tp_dist_sq = dot(tp, tp);
		// Skip sqrt() when outside the narrow edge anti-aliasing/blur band
		if (abs(tp.y) > 0.0 && tp_dist_sq >= norm_soft * norm_soft) {
			alpha = tp.y > 0.0 ? 1.0 : 0.0;
		} else {
			float signed_d = -sqrt(tp_dist_sq) * sign(tp.y);
			alpha = smoothstep(norm_soft, -norm_soft, signed_d);
		}
	}

	if (blur_radius > 0.0) {
		float spread_ratio = radius / max(radius + blur_85, 1e-5);
		alpha *= mix(spread_ratio * spread_ratio, 1.0, energy_retention);
	}
	return alpha;
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
		// Skip expensive vec3 sqrt() completely when shine color is <= 0.5 (uniform branch)
		if (any(greaterThan(blend_col, vec3(0.5)))) {
			vec3 hi = sqrt(b) * (-one_minus_two_c) + b * (2.0 - two_c);
			res = mix(lo, hi, step(0.5, blend_col));
		} else {
			res = lo;
		}
	}
	return mix(base, res, t);
}

// Evaluates a single helix column (cell_index) at local offset dx and composites into accum_rgb / accum_a
void eval_helix_cell(
	float cell_index, float dx, float uv_y, float col_y_pad, float pixel_size,
	float blur_half_w, float inner_rung_w, float rung_cap_soft, float rung_blur_atten,
	float node_edge_soft, float node_blur, float node_blur_85, float node_retention,
	float s1_str, float s2_str, inout vec3 accum_rgb, inout float accum_a
) {
	float dna_phase = cell_index * twist_density + v_helix_xform.w;
	float sin_raw = sin(dna_phase);
	float cos_raw = cos(dna_phase);
	float sin_dna = sin_raw * amplitude;
	float cut_up = abs(sin_dna);

	// Per-column vertical early-out: skip pixels in empty wave troughs before evaluating nodes or rungs
	if (abs(uv_y) >= cut_up + col_y_pad) {
		return;
	}

	// Branchless analytical depth & shading
	float depth1 = 0.5 * (1.0 - cos_raw);
	float depth2 = 1.0 - depth1;
	float shade1 = depth1 * depth_contrast + v_precomp_2.w;
	float shade2 = depth2 * depth_contrast + v_precomp_2.w;

	// Evaluate Row 1 (+1.0) and Row 2 (-1.0) node coverages
	float radius1 = row1_base_radius + depth1 * node_depth_scale;
	float radius2 = row2_base_radius + depth2 * node_depth_scale;
	bool spin1_active = spin_row1_nodes && row1_spin_speed != 0.0;
	bool spin2_active = spin_row2_nodes && row2_spin_speed != 0.0;

	float node1_a = eval_shape_alpha(vec2(dx, uv_y - sin_dna), radius1, v_precomp_2.x, pixel_size, node_edge_soft, node_blur, node_blur_85, node_retention, row1_shape, spin1_active, v_node_spins.xy);
	float node2_a = eval_shape_alpha(vec2(dx, uv_y + sin_dna), radius2, v_precomp_2.y, pixel_size, node_edge_soft, node_blur, node_blur_85, node_retention, row2_shape, spin2_active, v_node_spins.zw);

	// Rung line SDF (skip vertical caps, gradient lookup, and shine math when outside rung bounds)
	float abs_dx = abs(dx);
	if (abs_dx < blur_half_w && abs(uv_y) < cut_up + rung_cap_soft) {
		float line = smoothstep(blur_half_w, inner_rung_w, abs_dx);
		float mask_up = smoothstep(cut_up + rung_cap_soft, cut_up - rung_cap_soft, uv_y);
		float mask_down = smoothstep(-cut_up - rung_cap_soft, -cut_up + rung_cap_soft, uv_y);
		float line_cov = line * mask_up * mask_down * rung_blur_atten;

		if (line_cov > 0.0) {
			float grad_t = clamp(uv_y / max(2.0 * cut_up, 1e-5) + 0.5, 0.0, 1.0);
			grad_t = sin_raw > 0.0 ? (1.0 - grad_t) : grad_t;
			float line_shade = mix(shade1, shade2, grad_t);

			vec4 col_rung = use_individual_colors
				? textureLod(rung_gradient, vec2(grad_t, 0.5), 0.0)
				: helix_color;

			vec3 rung_rgb = col_rung.rgb * line_shade;
			if (s1_str > 0.0 && !shine_1_exclude_rung) {
				rung_rgb = apply_shine_blend(rung_rgb, shine_1_color.rgb, s1_str, shine_1_blend_mode);
			}
			if (s2_str > 0.0 && !shine_2_exclude_rung) {
				rung_rgb = apply_shine_blend(rung_rgb, shine_2_color.rgb, s2_str, shine_2_blend_mode);
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

	vec4 col1 = helix_color;
	vec4 col2 = helix_color;
	if (use_individual_colors) {
		col1 = row1_color;
		col2 = row2_color;
	}

	vec3 row1_rgb = vec3(0.0);
	if (node1_a > 0.0) {
		row1_rgb = col1.rgb * shade1;
		if (s1_str > 0.0 && !shine_1_exclude_row1) {
			row1_rgb = apply_shine_blend(row1_rgb, shine_1_color.rgb, s1_str, shine_1_blend_mode);
		}
		if (s2_str > 0.0 && !shine_2_exclude_row1) {
			row1_rgb = apply_shine_blend(row1_rgb, shine_2_color.rgb, s2_str, shine_2_blend_mode);
		}
	}

	vec3 row2_rgb = vec3(0.0);
	if (node2_a > 0.0) {
		row2_rgb = col2.rgb * shade2;
		if (s1_str > 0.0 && !shine_1_exclude_row2) {
			row2_rgb = apply_shine_blend(row2_rgb, shine_1_color.rgb, s1_str, shine_1_blend_mode);
		}
		if (s2_str > 0.0 && !shine_2_exclude_row2) {
			row2_rgb = apply_shine_blend(row2_rgb, shine_2_color.rgb, s2_str, shine_2_blend_mode);
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
	return smoothstep(0.5 - half_w, 0.5 + half_w, t);
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
			factor = dot(centered, rot_x) * v_bg_misc.x + 0.5;
		} else if (bg_gradient_type == 1) {
			factor = dot(centered, trig) * v_bg_misc.x + 0.5;
		} else if (bg_gradient_type == 2) {
			vec2 rot_uv = vec2(dot(centered, rot_x), dot(centered, trig));
			factor = length(rot_uv * v_bg_misc.xy) * 2.0;
		} else {
			factor = abs(dot(centered, trig) * v_bg_misc.x) * 2.0;
		}

		factor -= scroll_off.x;
		factor = bg_repeat ? fract(factor) : clamp(factor, 0.0, 1.0);
		factor = smooth_bg_gradient(factor, bg_gradient_smoothing);
		return textureLod(background_gradient, vec2(factor, 0.5), 0.0) * background_tint;
	}

	// Texture mode (2): centered rotation, 2D scale, offset, optional smooth 2D scroll, and seam-free mip derivatives
	vec2 rot_uv = vec2(dot(centered, rot_x), dot(centered, trig));
	vec2 tex_uv = rot_uv * v_bg_misc.xy + 0.5 - scroll_off;
	tex_uv = bg_repeat ? fract(tex_uv) : clamp(tex_uv, 0.0, 1.0);
	vec2 grad_x = vec2(dot(bg_uv_dx, rot_x), dot(bg_uv_dx, trig)) * v_bg_misc.xy;
	vec2 grad_y = vec2(dot(bg_uv_dy, rot_x), dot(bg_uv_dy, trig)) * v_bg_misc.xy;
	return textureGrad(background_texture, tex_uv, grad_x, grad_y) * background_tint;
}

void vertex() {
	// Expand mesh bounds in local space only when an active outline is drawn
	bool outline_active = enable_outline && outline_width > 0.0;
	float exp_pad = outline_active ? (2.0 + outline_width + outline_blur) : 2.0;
	float exp_double = exp_pad * 2.0;
	VERTEX += (UV - 0.5) * exp_double;
	v_local_pos = VERTEX;

	if (outline_active) {
		float out_rad = radians(outline_gradient_rotation_degrees);
		v_out_grad = vec4(sin(out_rad), cos(out_rad), 1.0 / max(outline_gradient_scale, 0.001), exp_double);
	} else {
		v_out_grad = vec4(0.0, 1.0, 1.0, exp_double);
	}

	vec2 active_offset = vec2(0.0);
	vec2 bg_inv_scale = vec2(1.0);
	if (background_mode != 0) {
		float bg_rad = radians(bg_rotation_degrees);
		v_bg_xform = vec4(sin(bg_rad), cos(bg_rad), bg_enable_scroll ? (bg_offset + TIME * bg_scroll_speed) : bg_offset);
		bg_inv_scale = 1.0 / max(abs(bg_scale), vec2(1e-4)) * sign(bg_scale + vec2(1e-7));
	} else {
		v_bg_xform = vec4(0.0, 1.0, 0.0, 0.0);
	}
	float inv_edge_reach = 1.0 / max(edge_blur_reach, 1e-4);
	float outer_limit = outline_active ? (outline_width + outline_blur + 1.5) : 1.5;
	v_bg_misc = vec4(bg_inv_scale, inv_edge_reach, outer_limit);

	// Precompute helix trig and time products once per vertex
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

	// Encode shine progress into signed [-1..1] space (-2.0 = inactive) for single-op range check & center multiply
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

	// Precompute frame-constant shine soft edges and global blur values
	float s1_inner = max(shine_1_width * (1.0 - shine_1_softness) - 1e-5, 0.0);
	float s2_inner = max(shine_2_width * (1.0 - shine_2_softness) - 1e-5, 0.0);
	float g_blur = (enable_helix_blur && helix_blur_amount > 0.0) ? (helix_blur_amount * 0.35) : 0.0;
	float g_node_blur = helix_blur_affect_nodes ? g_blur : 0.0;
	float g_rung_blur = helix_blur_affect_rungs ? g_blur : 0.0;
	v_precomp_1 = vec4(s1_inner, s2_inner, g_node_blur, g_rung_blur);

	// Precompute shape extent multipliers, max node reach, and base depth shade
	float r1_ext = get_shape_extent_mult(row1_shape, do_spin1);
	float r2_ext = get_shape_extent_mult(row2_shape, do_spin2);
	float max_node_ext = max(
		(row1_base_radius + node_depth_scale) * r1_ext,
		(row2_base_radius + node_depth_scale) * r2_ext
	);
	v_precomp_2 = vec4(r1_ext, r2_ext, max_node_ext, 1.0 - depth_contrast);
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

	// Rounded / Beveled Rect Signed Distance Field in local node space (d = 0 at original ColorRect edge)
	vec2 half_size = rect_size * 0.5;
	float r = 0.0;
	if (dot(corner_radii, corner_radii) > 0.0) {
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
	float d = (use_beveled_corners && r > 0.0)
		? max(max_q, (max_q_vec.x + max_q_vec.y) * 0.70710678) + dist_inner
		: length(max_q_vec) + dist_inner;

	if (d > v_bg_misc.w) {
		COLOR = vec4(0.0);
	} else {
		// Interior mask (d <= 0) keeps background & helix strictly inside the ColorRect
		float inner_mask = 1.0 - smoothstep(-0.75, 0.75, d);
		vec2 rect_uv = pixel_pos * inv_rect_size + 0.5;

		vec3 inner_rgb = vec3(0.0);
		float inner_a = 0.0;

		if (inner_mask > 0.0) {
			vec3 accum_rgb = vec3(0.0);
			float accum_a = 0.0;

			// Skip all helix math when global helix color is fully transparent
			if (use_individual_colors || helix_color.a > 0.0) {
				float uv_scale = (2.0 * scale) * inv_rect_size.y;
				float pixel_size = local_fwidth.y * uv_scale;
				vec2 uv = pixel_pos * vec2(uv_scale, -uv_scale);

				// Rotate into helix-aligned space (preserved un-scrolled for end-to-end shine sweeps)
				vec2 rot = v_helix_xform.xy;
				vec2 helix_uv = vec2(
					uv.x * rot.x + uv.y * rot.y,
					uv.y * rot.x - uv.x * rot.y
				);
				uv = vec2(helix_uv.x - v_helix_xform.z, helix_uv.y);

				// Combine precomputed Global Helix Blur + Edge-to-Center Border Blur (outline untouched)
				float g_node = v_precomp_1.z;
				float g_rung = v_precomp_1.w;
				float e_blur = 0.0;
				if (enable_edge_blur && edge_blur_amount > 0.0) {
					float inward_dist = max(-d - edge_blur_edge_offset, 0.0);
					if (inward_dist < edge_blur_reach) {
						float edge_t = 1.0 - (inward_dist * v_bg_misc.z);
						edge_t = smoothstep(0.0, 1.0, edge_t);
						if (edge_blur_falloff != 1.0) {
							edge_t = pow(edge_t, edge_blur_falloff);
						}
						e_blur = edge_t * edge_blur_amount * 0.35;
					}
				}

				float e_node = edge_blur_affect_nodes ? e_blur : 0.0;
				float node_blur = g_node + e_node;
				float node_retention = (e_node > 0.0)
					? (g_node * helix_blur_energy_retention + e_node * edge_blur_energy_retention) / node_blur
					: helix_blur_energy_retention;

				float e_rung = edge_blur_affect_rungs ? e_blur : 0.0;
				float rung_blur = g_rung + e_rung;
				float rung_retention = (e_rung > 0.0)
					? (g_rung * helix_blur_energy_retention + e_rung * edge_blur_energy_retention) / rung_blur
					: helix_blur_energy_retention;

				float max_blur = max(node_blur, rung_blur);
				float max_bound = amplitude + v_precomp_2.z + max_blur + pixel_size;

				// Skip all helix math for pixels outside the diagonal band
				if (abs(uv.y) <= max_bound) {
					float base_span = (half_size.x * abs(rot.x) + half_size.y * abs(rot.y)) * uv_scale;

					// Evaluate Shine 1 & Shine 2 once per pixel using signed [-1..1] progress
					float s1_str = 0.0;
					if (abs(v_shine_params.x) <= 1.0) {
						float s1_half_span = base_span + shine_1_width + abs(shine_1_slant) * max_bound;
						float s1_center = s1_half_span * v_shine_params.x;
						float s1_dist = abs((helix_uv.x + helix_uv.y * shine_1_slant) - s1_center);
						if (s1_dist < shine_1_width) {
							s1_str = smoothstep(shine_1_width, v_precomp_1.x, s1_dist) * v_shine_params.z;
						}
					}

					float s2_str = 0.0;
					if (abs(v_shine_params.y) <= 1.0) {
						float s2_half_span = base_span + shine_2_width + abs(shine_2_slant) * max_bound;
						float s2_center = s2_half_span * v_shine_params.y;
						float s2_dist = abs((helix_uv.x + helix_uv.y * shine_2_slant) - s2_center);
						if (s2_dist < shine_2_width) {
							s2_str = smoothstep(shine_2_width, v_precomp_1.y, s2_dist) * v_shine_params.w;
						}
					}

					// Precompute per-pixel node & rung parameters once across both cell passes
					float line_index = floor(uv.x);
					float dx = fract(uv.x) - 0.5;
					float half_rung_w = pixel_size * rung_thickness;
					float blur_half_w = half_rung_w + rung_blur;
					float raw_inner_rung_w = max(half_rung_w - pixel_size * 0.5, 0.0) * rung_sharpness;
					float inner_rung_w = raw_inner_rung_w * (1.0 - clamp(rung_blur * 4.0, 0.0, 1.0)) - rung_blur;
					float rung_cap_soft = pixel_size + rung_blur;
					float rung_blur_atten = (rung_blur > 0.0)
						? mix(half_rung_w / max(blur_half_w, 1e-5), 1.0, rung_retention)
						: 1.0;

					float node_edge_soft = pixel_size + node_blur;
					float node_blur_85 = node_blur * 0.85;
					float col_y_pad = max(v_precomp_2.z + node_edge_soft, rung_cap_soft);

					// Only evaluate the nearest adjacent column on pixels where spillover physically reaches
					float max_cell_reach = max(v_precomp_2.z + node_blur, blur_half_w) + pixel_size;
					if (abs(dx) + max_cell_reach > 1.0) {
						float neighbor_dir = dx < 0.0 ? -1.0 : 1.0;
						eval_helix_cell(
							line_index + neighbor_dir, dx - neighbor_dir, uv.y, col_y_pad, pixel_size,
							blur_half_w, inner_rung_w, rung_cap_soft, rung_blur_atten,
							node_edge_soft, node_blur, node_blur_85, node_retention,
							s1_str, s2_str, accum_rgb, accum_a
						);
					}

					eval_helix_cell(
						line_index, dx, uv.y, col_y_pad, pixel_size,
						blur_half_w, inner_rung_w, rung_cap_soft, rung_blur_atten,
						node_edge_soft, node_blur, node_blur_85, node_retention,
						s1_str, s2_str, accum_rgb, accum_a
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

		// Composite outer outline ring around d = 0..outline_width (completely unaffected by helix/edge blur)
		if (enable_outline && outline_width > 0.0 && d > -0.75) {
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