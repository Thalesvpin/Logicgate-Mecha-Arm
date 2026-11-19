shader_type canvas_item;

// Top-level Global Controls
uniform vec4 circuit_color : source_color = vec4(0.15, 0.95, 0.35, 1.0);
// [UNUSED FROM DNA HELIX] Fake-3D depth shading is not used for 2D circuit traces:
// uniform float depth_contrast : hint_range(0.0, 1.0) = 0.8;

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
uniform vec4 line1_color : source_color = vec4(0.15, 0.95, 0.35, 1.0);
uniform vec4 line2_color : source_color = vec4(0.15, 0.95, 0.35, 1.0);
uniform sampler2D trail_gradient : source_color, hint_default_white, repeat_disable;
group_uniforms;

group_uniforms Circuit_Global;
uniform float flow_angle_degrees : hint_range(-180.0, 180.0) = 0.0; // 0 = Left-to-Right, 180 = Right-to-Left, 90 = Bottom-to-Top, -90 = Top-to-Bottom
uniform float trail_fade_power : hint_range(0.25, 4.0) = 1.6;
// [UNUSED FROM DNA HELIX] Helical wave scale/twist/amplitude/3D-spin replaced by controlled side-to-side circuit paths:
// uniform float scale : hint_range(0.5, 20.0) = 5.0;
// uniform float angle : hint_range(-3.14159, 3.14159) = 0.3;
// uniform float twist_density : hint_range(0.05, 2.0) = 0.4;
// uniform float amplitude : hint_range(0.2, 4.0) = 2.0;
// uniform float scroll_speed : hint_range(-5.0, 5.0) = 0.5;
// uniform float rotation_speed : hint_range(-5.0, 5.0) = 1.0;
group_uniforms;

group_uniforms Line_1_Path;
uniform float line1_speed : hint_range(0.0, 5.0) = 0.85;
uniform float line1_y_offset : hint_range(-1.0, 1.0) = 0.3;
uniform float line1_bend_pos : hint_range(-0.8, 0.8) = -0.15;
uniform float line1_bend_shift : hint_range(-1.0, 1.0) = -0.35;
uniform float line1_trail_length : hint_range(0.05, 4.0) = 1.4;
uniform float line1_time_offset : hint_range(0.0, 10.0) = 0.0;
uniform float line1_interval : hint_range(0.0, 5.0) = 0.25;
group_uniforms;

group_uniforms Line_2_Path;
uniform float line2_speed : hint_range(0.0, 5.0) = 0.75;
uniform float line2_y_offset : hint_range(-1.0, 1.0) = -0.35;
uniform float line2_bend_pos : hint_range(-0.8, 0.8) = 0.05;
uniform float line2_bend_shift : hint_range(-1.0, 1.0) = 0.4;
uniform float line2_trail_length : hint_range(0.05, 4.0) = 1.3;
uniform float line2_time_offset : hint_range(0.0, 10.0) = 1.1;
uniform float line2_interval : hint_range(0.0, 5.0) = 0.35;
group_uniforms;

group_uniforms Shapes;
uniform int line1_shape : hint_enum("Circle", "Square", "Hexagon", "Triangle") = 0;
uniform int line2_shape : hint_enum("Circle", "Square", "Hexagon", "Triangle") = 0;
uniform float line1_radius : hint_range(0.005, 0.25) = 0.035;
uniform float line2_radius : hint_range(0.005, 0.25) = 0.035;
uniform float trail_thickness : hint_range(0.5, 12.0) = 2.5;
uniform float trail_sharpness : hint_range(0.0, 1.0) = 0.2;
// [UNUSED FROM DNA HELIX] Fake-3D perspective node scaling:
// uniform float node_depth_scale : hint_range(0.0, 0.3) = 0.1;
group_uniforms;

group_uniforms Node_Spin;
uniform bool spin_line1_node = false;
uniform float line1_spin_speed : hint_range(-10.0, 10.0) = 2.0;
uniform bool spin_line2_node = false;
uniform float line2_spin_speed : hint_range(-10.0, 10.0) = 2.0;
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
uniform bool shine_1_exclude_line1 = false;
uniform bool shine_1_exclude_line2 = false;
uniform bool shine_1_exclude_trail = false;
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
uniform bool shine_2_exclude_line1 = false;
uniform bool shine_2_exclude_line2 = false;
uniform bool shine_2_exclude_trail = false;
group_uniforms;

group_uniforms Circuit_Blur;
uniform bool enable_circuit_blur = false;
uniform float circuit_blur_amount : hint_range(0.0, 2.0) = 0.25;
uniform float circuit_blur_energy_retention : hint_range(0.0, 1.0) = 0.75;
uniform bool circuit_blur_affect_nodes = true;
uniform bool circuit_blur_affect_trails = true;
group_uniforms;

group_uniforms Edge_Blur;
uniform bool enable_edge_blur = false;
uniform float edge_blur_amount : hint_range(0.0, 2.0) = 0.45;
uniform float edge_blur_reach : hint_range(1.0, 500.0) = 80.0;
uniform float edge_blur_falloff : hint_range(0.1, 5.0) = 1.5;
uniform float edge_blur_edge_offset : hint_range(0.0, 200.0) = 0.0;
uniform float edge_blur_energy_retention : hint_range(0.0, 1.0) = 0.75;
uniform bool edge_blur_affect_nodes = true;
uniform bool edge_blur_affect_trails = true;
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

// Tightly packed highp interpolators with 48-bit double-single travel values for infinite-runtime precision
varying highp vec2 v_local_pos;
varying flat highp vec2 v_flow_trig;     // xy = cos/sin(flow_angle)
varying flat highp vec4 v_travel_ds;     // xy = 48-bit (hi, lo) travel for line1, zw = 48-bit (hi, lo) travel for line2
varying flat highp vec4 v_node_spins;    // xy = spin1 (cos, sin), zw = spin2 (cos, sin)
varying flat highp vec4 v_shine_params;  // x = shine_1_signed_t [-1..1], y = shine_2_signed_t [-1..1], z = shine_1_gain, w = shine_2_gain
varying flat vec4 v_precomp_1;           // x = s1_inner, y = s2_inner, z = g_node_blur, w = g_trail_blur
varying flat vec4 v_precomp_2;           // x = line1_ext_mult, y = line2_ext_mult, z = line1_spin_active, w = line2_spin_active
varying flat vec4 v_out_grad;            // xy = sin/cos(outline_grad_rot), z = inv_out_scale, w = exp_double
varying flat highp vec4 v_bg_xform;      // xy = sin/cos(bg_rot), zw = bounded active_bg_offset
varying flat vec4 v_bg_misc;             // xy = inv_bg_scale, z = inv_edge_reach, w = outer_limit

// 48-bit Double-Single (hi, lo) arithmetic helpers to prevent mod() precision loss over long runtimes
highp vec2 ds_split(highp float a) {
	highp float c = 4097.0 * a;
	highp float a_hi = c - (c - a);
	highp float a_lo = a - a_hi;
	return vec2(a_hi, a_lo);
}

highp vec2 ds_mul(highp float a, highp float b) {
	highp float p = a * b;
	highp vec2 sa = ds_split(a);
	highp vec2 sb = ds_split(b);
	highp float err = ((sa.x * sb.x - p) + sa.x * sb.y + sa.y * sb.x) + sa.y * sb.y;
	return vec2(p, err);
}

highp vec2 ds_sub(highp vec2 a, highp vec2 b) {
	highp float s = a.x - b.x;
	highp float v = s - a.x;
	highp float err = (a.x - (s - v)) - (b.x + v) + a.y - b.y;
	return vec2(s, err);
}

highp float ds_mod(highp vec2 x, highp float y) {
	highp float x_val = x.x + x.y;
	highp float q = floor(x_val / y);
	highp vec2 rem = ds_sub(x, ds_mul(q, y));
	highp float r = rem.x + rem.y;
	if (r < 0.0) {
		r += y;
	} else if (r >= y) {
		r -= y;
	}
	return r;
}

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

	// Sub-pixel area energy preservation prevents tiny zoomed-out shapes from bloating to 1px minimum width
	float sub_ratio = min(radius / max(pixel_size * 0.5, 1e-5), 1.0);
	float sub_energy = sub_ratio * sub_ratio;

	if (shape == 0) {
		if (blur_radius <= 0.0) {
			float r_min = max(radius - pixel_size * 0.5, 0.0);
			float r_max = radius + pixel_size * 0.5;
			return smoothstep(r_max * r_max, r_min * r_min, dot(p, p)) * sub_energy;
		}
		float spread_ratio = radius / max(radius + blur_85, 1e-5);
		float energy_scale = mix(spread_ratio * spread_ratio, 1.0, energy_retention) * sub_energy;
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

	alpha *= sub_energy;
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

// Evaluates a single moving PCB circuit line (3-segment 45-degree routed path + fading trail + leading node)
void eval_circuit_line(
	vec2 p, float span_u, float span_v,
	highp vec2 travel_ds,
	float y_norm, float bend_norm, float shift_norm, float trail_len, float interval_pause,
	float node_radius, float node_ext_mult, int node_shape, bool do_spin, vec2 spin_trig,
	vec4 base_node_col, bool exclude_node_s1, bool exclude_node_s2,
	float pixel_size, float blur_half_w, float inner_trail_w, float trail_blur_atten,
	float node_edge_soft, float node_blur, float node_blur_85, float node_retention,
	float s1_str, float s2_str, inout vec3 accum_rgb, inout float accum_a
) {
	// Map normalized [-1..1] lane & bend controls into aspect-aware flow space
	float y_start = y_norm * span_v;
	float dy = shift_norm * span_v;
	float dx_diag = abs(dy);

	// Pure zoom-independent entry/exit padding so path cycle length never shifts with camera zoom
	float entry_pad = node_radius * node_ext_mult + node_blur + 0.02;
	float u_min = -span_u - entry_pad;
	float u_max = span_u + entry_pad;

	float u_b1 = clamp(bend_norm * span_u, u_min, max(u_max - dx_diag, u_min));
	float u_b2 = min(u_b1 + dx_diag, u_max);
	float actual_dx = u_b2 - u_b1;
	float actual_dy = (actual_dx < dx_diag && dx_diag > 1e-5) ? (dy * (actual_dx / dx_diag)) : dy;
	float y_end = y_start + actual_dy;

	// Exact polyline segment lengths (L2 is true Euclidean 45-degree length for uniform node velocity)
	float l1 = max(u_b1 - u_min, 0.0);
	float l2 = sqrt(actual_dx * actual_dx + actual_dy * actual_dy);
	float l3 = max(u_max - u_b2, 0.0);
	float l_total = l1 + l2 + l3;

	highp float full_span = l_total + trail_len;
	highp float cycle_len = full_span + interval_pause;
	if (cycle_len <= 1e-5) {
		return;
	}

	// 48-bit double-single modular reduction prevents precision drift even after days of uptime
	highp float s_head = ds_mod(travel_ds, cycle_len);
	if (s_head > full_span) {
		// Line is currently in its off-screen interval pause
		return;
	}

	// Quick vertical band rejection before projecting onto the 3 PCB segments
	float band_pad = max(node_radius * node_ext_mult + node_edge_soft, blur_half_w);
	float y_lo = min(y_start, y_end) - band_pad;
	float y_hi = max(y_start, y_end) + band_pad;
	if (p.y < y_lo || p.y > y_hi) {
		return;
	}

	// Compute exact leading Node position along the 3-segment PCB polyline
	vec2 head_pos = vec2(u_min, y_start);
	if (s_head <= l1) {
		head_pos = vec2(u_min + s_head, y_start);
	} else if (s_head <= l1 + l2 && l2 > 1e-5) {
		float f = (s_head - l1) / l2;
		head_pos = vec2(u_b1 + actual_dx * f, y_start + actual_dy * f);
	} else {
		head_pos = vec2(u_b2 + (s_head - l1 - l2), y_end);
	}

	// Evaluate leading Node coverage
	float node_a = eval_shape_alpha(
		p - head_pos, node_radius, node_ext_mult, pixel_size,
		node_edge_soft, node_blur, node_blur_85, node_retention,
		node_shape, do_spin, spin_trig
	);

	// Project pixel onto the 3 PCB segments (Entry Straight -> 45-deg Diagonal -> Exit Straight)
	highp float best_dist_sq = 1e9;
	float best_s = 0.0;

	// Segment 1: Horizontal entry run (u_min..u_b1, y_start)
	if (l1 > 1e-5) {
		float x1 = clamp(p.x, u_min, u_b1);
		float dx1 = p.x - x1;
		float dy1 = p.y - y_start;
		best_dist_sq = dx1 * dx1 + dy1 * dy1;
		best_s = x1 - u_min;
	}

	// Segment 2: 45-degree PCB bend ((u_b1, y_start) -> (u_b2, y_end))
	if (l2 > 1e-5) {
		vec2 pa2 = p - vec2(u_b1, y_start);
		vec2 ba2 = vec2(actual_dx, actual_dy);
		float h2 = clamp(dot(pa2, ba2) / dot(ba2, ba2), 0.0, 1.0);
		vec2 diff2 = pa2 - ba2 * h2;
		float d2_sq = dot(diff2, diff2);
		if (d2_sq < best_dist_sq) {
			best_dist_sq = d2_sq;
			best_s = l1 + h2 * l2;
		}
	}

	// Segment 3: Horizontal exit run (u_b2..u_max, y_end)
	if (l3 > 1e-5) {
		float x3 = clamp(p.x, u_b2, u_max);
		float dx3 = p.x - x3;
		float dy3 = p.y - y_end;
		float d3_sq = dx3 * dx3 + dy3 * dy3;
		if (d3_sq < best_dist_sq) {
			best_dist_sq = d3_sq;
			best_s = l1 + l2 + (x3 - u_b2);
		}
	}

	// Evaluate Trail width SDF and arc-length fade behind the moving head node (never poking ahead of s_head)
	float behind = s_head - best_s;
	if (best_dist_sq < blur_half_w * blur_half_w && behind > 0.0 && behind < trail_len) {
		float trail_dist = sqrt(best_dist_sq);
		float line_profile = smoothstep(blur_half_w, inner_trail_w, trail_dist) * trail_blur_atten;
		float clip_soft = min(pixel_size, max(node_radius * 0.5, 1e-4));
		float head_clip = smoothstep(0.0, clip_soft, behind);
		float trail_t = clamp(behind / max(trail_len, 1e-4), 0.0, 1.0);
		float tail_fade = pow(max(1.0 - trail_t, 0.0), trail_fade_power);
		float trail_cov = line_profile * head_clip * tail_fade;

		if (trail_cov > 0.0) {
			vec4 col_trail = base_node_col;
			if (use_individual_colors) {
				vec4 grad_col = textureLod(trail_gradient, vec2(trail_t, 0.5), 0.0);
				col_trail = vec4(base_node_col.rgb * grad_col.rgb, base_node_col.a * grad_col.a);
			}

			vec3 trail_rgb = col_trail.rgb;
			if (s1_str > 0.0 && !shine_1_exclude_trail) {
				trail_rgb = apply_shine_blend(trail_rgb, shine_1_color.rgb, s1_str, shine_1_blend_mode);
			}
			if (s2_str > 0.0 && !shine_2_exclude_trail) {
				trail_rgb = apply_shine_blend(trail_rgb, shine_2_color.rgb, s2_str, shine_2_blend_mode);
			}

			float trail_a = trail_cov * col_trail.a;
			float rem_a = 1.0 - trail_a;
			accum_rgb = accum_rgb * rem_a + trail_rgb * trail_a;
			accum_a = accum_a * rem_a + trail_a;
		}
	}

	// Composite leading Node cleanly on top of its own trail
	float final_node_a = node_a * base_node_col.a;
	if (final_node_a > 0.0) {
		vec3 node_rgb = base_node_col.rgb;
		if (s1_str > 0.0 && !exclude_node_s1) {
			node_rgb = apply_shine_blend(node_rgb, shine_1_color.rgb, s1_str, shine_1_blend_mode);
		}
		if (s2_str > 0.0 && !exclude_node_s2) {
			node_rgb = apply_shine_blend(node_rgb, shine_2_color.rgb, s2_str, shine_2_blend_mode);
		}

		float rem_a = 1.0 - final_node_a;
		accum_rgb = accum_rgb * rem_a + node_rgb * final_node_a;
		accum_a = accum_a * rem_a + final_node_a;
	}
}

// [UNUSED FROM DNA HELIX] Periodic dual-row helical column evaluator:
// void eval_helix_cell(
// 	float cell_index, float dx, float uv_y, float col_y_pad, float pixel_size,
// 	float blur_half_w, float inner_rung_w, float rung_cap_soft, float rung_blur_atten,
// 	float node_edge_soft, float node_blur, float node_blur_85, float node_retention,
// 	float s1_str, float s2_str, inout vec3 accum_rgb, inout float accum_a
// ) { ... }

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
	const highp float TAU_VAL = 6.28318530718;

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

	vec2 bg_inv_scale = vec2(1.0);
	if (background_mode != 0) {
		float bg_rad = radians(bg_rotation_degrees);
		highp vec2 active_offset = bg_offset;
		if (bg_enable_scroll) {
			if (bg_repeat) {
				highp float sx = ds_mod(ds_mul(TIME, bg_scroll_speed.x), 1.0);
				highp float sy = ds_mod(ds_mul(TIME, bg_scroll_speed.y), 1.0);
				active_offset = fract(bg_offset + vec2(sx, sy));
			} else {
				active_offset = bg_offset + clamp(TIME * bg_scroll_speed, vec2(-100.0), vec2(100.0));
			}
		}
		v_bg_xform = vec4(sin(bg_rad), cos(bg_rad), active_offset);
		bg_inv_scale = 1.0 / max(abs(bg_scale), vec2(1e-4)) * sign(bg_scale + vec2(1e-7));
	} else {
		v_bg_xform = vec4(0.0, 1.0, 0.0, 0.0);
	}
	float inv_edge_reach = 1.0 / max(edge_blur_reach, 1e-4);
	float outer_limit = outline_active ? (outline_width + outline_blur + 1.5) : 1.5;
	v_bg_misc = vec4(bg_inv_scale, inv_edge_reach, outer_limit);

	// Compute 48-bit double-single travel distances in vertex() so fragment() modulo never drifts
	highp float flow_rad = radians(flow_angle_degrees);
	v_flow_trig = vec2(cos(flow_rad), sin(flow_rad));
	highp vec2 travel1_ds = ds_mul(TIME + line1_time_offset, line1_speed);
	highp vec2 travel2_ds = ds_mul(TIME + line2_time_offset, line2_speed);
	v_travel_ds = vec4(travel1_ds, travel2_ds);

	// Wrap spin angles via 48-bit ds_mod(..., TAU) so sin/cos stay smooth indefinitely
	bool do_spin1 = spin_line1_node && line1_shape != 0 && line1_spin_speed != 0.0;
	vec2 spin1 = vec2(1.0, 0.0);
	if (do_spin1) {
		highp float spin1_angle = ds_mod(ds_mul(TIME, line1_spin_speed), TAU_VAL);
		spin1 = vec2(cos(spin1_angle), sin(spin1_angle));
	}

	bool do_spin2 = spin_line2_node && line2_shape != 0 && line2_spin_speed != 0.0;
	vec2 spin2 = vec2(1.0, 0.0);
	if (do_spin2) {
		highp float spin2_angle = ds_mod(ds_mul(TIME, line2_spin_speed), TAU_VAL);
		spin2 = vec2(cos(spin2_angle), sin(spin2_angle));
	}
	v_node_spins = vec4(spin1, spin2);

	// Encode shine progress into signed [-1..1] space (-2.0 = inactive) using 48-bit ds_mod
	highp float s1_signed_t = -2.0;
	float s1_gain = 0.0;
	if (enable_shine_1 && shine_1_intensity > 0.0 && shine_1_color.a > 0.0) {
		highp float cycle1 = 1.0 + shine_1_interval;
		highp float m1 = ds_mod(ds_mul(TIME, abs(shine_1_speed)), cycle1);
		highp float t1 = m1 * 2.0 - 1.0;
		s1_signed_t = (shine_1_speed >= 0.0) ? t1 : -t1;
		s1_gain = shine_1_intensity * shine_1_color.a;
	}

	highp float s2_signed_t = -2.0;
	float s2_gain = 0.0;
	if (enable_shine_2 && shine_2_intensity > 0.0 && shine_2_color.a > 0.0) {
		highp float cycle2 = 1.0 + shine_2_interval;
		highp float m2 = ds_mod(ds_mul(TIME, abs(shine_2_speed)), cycle2);
		highp float t2 = m2 * 2.0 - 1.0;
		s2_signed_t = (shine_2_speed >= 0.0) ? t2 : -t2;
		s2_gain = shine_2_intensity * shine_2_color.a;
	}
	v_shine_params = vec4(s1_signed_t, s2_signed_t, s1_gain, s2_gain);

	// Precompute frame-constant shine soft edges and global blur values
	float s1_inner = max(shine_1_width * (1.0 - shine_1_softness) - 1e-5, 0.0);
	float s2_inner = max(shine_2_width * (1.0 - shine_2_softness) - 1e-5, 0.0);
	float g_blur = (enable_circuit_blur && circuit_blur_amount > 0.0) ? (circuit_blur_amount * 0.12) : 0.0;
	float g_node_blur = circuit_blur_affect_nodes ? g_blur : 0.0;
	float g_trail_blur = circuit_blur_affect_trails ? g_blur : 0.0;
	v_precomp_1 = vec4(s1_inner, s2_inner, g_node_blur, g_trail_blur);

	// Precompute shape extent multipliers and active spin flags
	float r1_ext = get_shape_extent_mult(line1_shape, do_spin1);
	float r2_ext = get_shape_extent_mult(line2_shape, do_spin2);
	v_precomp_2 = vec4(r1_ext, r2_ext, do_spin1 ? 1.0 : 0.0, do_spin2 ? 1.0 : 0.0);
}

void fragment() {
	highp vec2 uv_cen = UV - 0.5;

	// Rotation-invariant Euclidean gradients cancel out node canvas position while preserving exact rect_size
	highp vec2 uv_grad = vec2(
		length(vec2(dFdx(UV.x), dFdy(UV.x))),
		length(vec2(dFdx(UV.y), dFdy(UV.y)))
	);
	highp vec2 pos_grad = vec2(
		length(vec2(dFdx(v_local_pos.x), dFdy(v_local_pos.x))),
		length(vec2(dFdx(v_local_pos.y), dFdy(v_local_pos.y)))
	);
	highp vec2 expanded_size = pos_grad / max(uv_grad, vec2(1e-7));
	highp vec2 raw_rect_size = max(expanded_size - v_out_grad.w, vec2(0.001));
	// Snap sub-half-pixel 2x2 derivative noise so every pixel shares the exact same constant rect_size across all zooms
	highp vec2 rect_size = max(round(raw_rect_size * 2.0) * 0.5, vec2(0.5));
	highp vec2 inv_rect_size = 1.0 / rect_size;
	highp vec2 pixel_pos = uv_cen * (rect_size + v_out_grad.w);

	// Compute background texture derivatives in uniform control flow only when Texture mode is active
	vec2 bg_uv_dx = vec2(0.0);
	vec2 bg_uv_dy = vec2(0.0);
	if (background_mode == 2) {
		vec2 uv_to_rect = (rect_size + v_out_grad.w) * inv_rect_size;
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
		// Interior mask (d <= 0) keeps background & circuit lines strictly inside the ColorRect
		float inner_mask = 1.0 - smoothstep(-0.75, 0.75, d);
		vec2 rect_uv = pixel_pos * inv_rect_size + 0.5;

		vec3 inner_rgb = vec3(0.0);
		float inner_a = 0.0;

		if (inner_mask > 0.0) {
			vec3 accum_rgb = vec3(0.0);
			float accum_a = 0.0;

			// Skip all circuit math when global circuit color is fully transparent
			if (use_individual_colors || circuit_color.a > 0.0) {
				float uv_scale = 2.0 * inv_rect_size.y;
				float pixel_size = uv_grad.y * (rect_size.y + v_out_grad.w) * uv_scale;
				vec2 uv = pixel_pos * vec2(uv_scale, -uv_scale);

				// Rotate into circuit flow space (u = travel direction, v = lateral offset)
				vec2 rot = v_flow_trig;
				vec2 flow_uv = vec2(
					uv.x * rot.x + uv.y * rot.y,
					uv.y * rot.x - uv.x * rot.y
				);

				// Exact half-extents of the ColorRect projected onto the rotated flow axes
				vec2 box_half = half_size * uv_scale;
				float span_u = box_half.x * abs(rot.x) + box_half.y * abs(rot.y);
				float span_v = box_half.x * abs(rot.y) + box_half.y * abs(rot.x);

				// Combine precomputed Global Circuit Blur + Edge-to-Center Border Blur (outline untouched)
				float g_node = v_precomp_1.z;
				float g_trail = v_precomp_1.w;
				float e_blur = 0.0;
				if (enable_edge_blur && edge_blur_amount > 0.0) {
					float inward_dist = max(-d - edge_blur_edge_offset, 0.0);
					if (inward_dist < edge_blur_reach) {
						float edge_t = 1.0 - (inward_dist * v_bg_misc.z);
						edge_t = smoothstep(0.0, 1.0, edge_t);
						if (edge_blur_falloff != 1.0) {
							edge_t = pow(edge_t, edge_blur_falloff);
						}
						e_blur = edge_t * edge_blur_amount * 0.12;
					}
				}

				float e_node = edge_blur_affect_nodes ? e_blur : 0.0;
				float node_blur = g_node + e_node;
				float node_retention = (e_node > 0.0)
					? (g_node * circuit_blur_energy_retention + e_node * edge_blur_energy_retention) / node_blur
					: circuit_blur_energy_retention;

				float e_trail = edge_blur_affect_trails ? e_blur : 0.0;
				float trail_blur = g_trail + e_trail;
				float trail_retention = (e_trail > 0.0)
					? (g_trail * circuit_blur_energy_retention + e_trail * edge_blur_energy_retention) / trail_blur
					: circuit_blur_energy_retention;

				// Evaluate Shine 1 & Shine 2 once per pixel across the flow space
				float s1_str = 0.0;
				if (abs(v_shine_params.x) <= 1.0) {
					float s1_half_span = span_u + shine_1_width + abs(shine_1_slant) * span_v;
					float s1_center = s1_half_span * v_shine_params.x;
					float s1_dist = abs((flow_uv.x + flow_uv.y * shine_1_slant) - s1_center);
					if (s1_dist < shine_1_width) {
						s1_str = smoothstep(shine_1_width, v_precomp_1.x, s1_dist) * v_shine_params.z;
					}
				}

				float s2_str = 0.0;
				if (abs(v_shine_params.y) <= 1.0) {
					float s2_half_span = span_u + shine_2_width + abs(shine_2_slant) * span_v;
					float s2_center = s2_half_span * v_shine_params.y;
					float s2_dist = abs((flow_uv.x + flow_uv.y * shine_2_slant) - s2_center);
					if (s2_dist < shine_2_width) {
						s2_str = smoothstep(shine_2_width, v_precomp_1.y, s2_dist) * v_shine_params.w;
					}
				}

				// Scale trail width in local UV space (consistent across zooms) with sub-pixel AA coverage preservation
				float geom_half_w = trail_thickness * 0.004;
				float half_trail_w = max(geom_half_w, pixel_size * 0.5);
				float subpixel_trail_atten = geom_half_w / half_trail_w;

				float blur_half_w = half_trail_w + trail_blur;
				float raw_inner_trail_w = max(half_trail_w - pixel_size * 0.5, 0.0) * trail_sharpness;
				float inner_trail_w = raw_inner_trail_w * (1.0 - clamp(trail_blur * 10.0, 0.0, 1.0)) - trail_blur;
				float trail_blur_atten = subpixel_trail_atten * ((trail_blur > 0.0)
					? mix(half_trail_w / max(blur_half_w, 1e-5), 1.0, trail_retention)
					: 1.0);

				float node_edge_soft = pixel_size * 0.5 + node_blur;
				float node_blur_85 = node_blur * 0.85;

				vec4 col1 = use_individual_colors ? line1_color : circuit_color;
				vec4 col2 = use_individual_colors ? line2_color : circuit_color;

				// Circuit Line 1 (Node + 45-degree routed fading Trail)
				eval_circuit_line(
					flow_uv, span_u, span_v,
					v_travel_ds.xy,
					line1_y_offset, line1_bend_pos, line1_bend_shift, line1_trail_length, line1_interval,
					line1_radius, v_precomp_2.x, line1_shape, v_precomp_2.z > 0.5, v_node_spins.xy,
					col1, shine_1_exclude_line1, shine_2_exclude_line1,
					pixel_size, blur_half_w, inner_trail_w, trail_blur_atten,
					node_edge_soft, node_blur, node_blur_85, node_retention,
					s1_str, s2_str, accum_rgb, accum_a
				);

				// Circuit Line 2 (Node + 45-degree routed fading Trail)
				eval_circuit_line(
					flow_uv, span_u, span_v,
					v_travel_ds.zw,
					line2_y_offset, line2_bend_pos, line2_bend_shift, line2_trail_length, line2_interval,
					line2_radius, v_precomp_2.y, line2_shape, v_precomp_2.w > 0.5, v_node_spins.zw,
					col2, shine_1_exclude_line2, shine_2_exclude_line2,
					pixel_size, blur_half_w, inner_trail_w, trail_blur_atten,
					node_edge_soft, node_blur, node_blur_85, node_retention,
					s1_str, s2_str, accum_rgb, accum_a
				);
			}

			// Skip background evaluation completely on pixels already 100% covered by opaque circuit geometry
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

		// Composite outer outline ring around d = 0..outline_width (completely unaffected by circuit/edge blur)
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