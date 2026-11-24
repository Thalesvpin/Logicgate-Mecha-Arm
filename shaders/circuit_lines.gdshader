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
uniform int line1_bend_count : hint_range(0, 8) = 1;
uniform bool line1_random_bends = false;
uniform int line1_min_bends : hint_range(0, 8) = 1;
uniform int line1_max_bends : hint_range(0, 8) = 3;
uniform float line1_trail_length : hint_range(0.05, 4.0) = 1.4;
uniform float line1_time_offset : hint_range(0.0, 10.0) = 0.0;
uniform float line1_interval : hint_range(0.0, 5.0) = 0.25;
group_uniforms;

group_uniforms Line_2_Path;
uniform float line2_speed : hint_range(0.0, 5.0) = 0.75;
uniform float line2_y_offset : hint_range(-1.0, 1.0) = -0.35;
uniform float line2_bend_pos : hint_range(-0.8, 0.8) = 0.05;
uniform float line2_bend_shift : hint_range(-1.0, 1.0) = 0.4;
uniform int line2_bend_count : hint_range(0, 8) = 1;
uniform bool line2_random_bends = false;
uniform int line2_min_bends : hint_range(0, 8) = 1;
uniform int line2_max_bends : hint_range(0, 8) = 3;
uniform float line2_trail_length : hint_range(0.05, 4.0) = 1.3;
uniform float line2_time_offset : hint_range(0.0, 10.0) = 1.1;
uniform float line2_interval : hint_range(0.0, 5.0) = 0.35;
group_uniforms;

group_uniforms Shapes;
uniform int line1_shape : hint_enum("Circle", "Square", "Hexagon", "Triangle") = 0;
uniform float line1_radius : hint_range(0.005, 0.25) = 0.035;
uniform float line1_trail_thickness : hint_range(0.5, 12.0) = 2.5;
uniform float line1_trail_sharpness : hint_range(0.0, 1.0) = 0.2;
uniform int line2_shape : hint_enum("Circle", "Square", "Hexagon", "Triangle") = 0;
uniform float line2_radius : hint_range(0.005, 0.25) = 0.035;
uniform float line2_trail_thickness : hint_range(0.5, 12.0) = 2.5;
uniform float line2_trail_sharpness : hint_range(0.0, 1.0) = 0.2;
// [UNUSED FROM DNA HELIX] Fake-3D perspective node scaling:
// uniform float node_depth_scale : hint_range(0.0, 0.3) = 0.1;
group_uniforms;

group_uniforms Node_Spin;
uniform bool spin_line1_node = false;
uniform float line1_spin_speed : hint_range(-10.0, 10.0) = 2.0;
uniform bool spin_line2_node = false;
uniform float line2_spin_speed : hint_range(-10.0, 10.0) = 2.0;
group_uniforms;

group_uniforms Procedural_Bus_1;
uniform bool enable_bus_1 = false;
uniform int bus1_line_count : hint_range(1, 16) = 6;
uniform float bus1_seed : hint_range(0.0, 100.0) = 1.0;
uniform bool bus1_use_custom_color = false;
uniform vec4 bus1_color : source_color = vec4(0.15, 0.95, 0.35, 0.85);
uniform vec2 bus1_y_range = vec2(-0.8, 0.8);
uniform vec2 bus1_speed_range = vec2(0.45, 1.15);
uniform vec2 bus1_bend_shift_range = vec2(-0.35, 0.35);
uniform int bus1_min_bends : hint_range(0, 8) = 1;
uniform int bus1_max_bends : hint_range(0, 8) = 3;
uniform vec2 bus1_trail_length_range = vec2(0.8, 1.6);
uniform vec2 bus1_interval_range = vec2(0.2, 1.2);
uniform float bus1_trail_thickness : hint_range(0.5, 12.0) = 2.5;
uniform float bus1_trail_sharpness : hint_range(0.0, 1.0) = 0.2;
uniform int bus1_shape_mode : hint_enum("Circle", "Square", "Hexagon", "Triangle", "Random Mix") = 0;
uniform vec2 bus1_radius_range = vec2(0.02, 0.035);
uniform bool bus1_spin_nodes = false;
uniform float bus1_spin_speed : hint_range(-10.0, 10.0) = 2.0;
uniform bool bus1_exclude_shine_1 = false;
uniform bool bus1_exclude_shine_2 = false;
group_uniforms;

group_uniforms Procedural_Bus_2;
uniform bool enable_bus_2 = false;
uniform int bus2_line_count : hint_range(1, 16) = 6;
uniform float bus2_seed : hint_range(0.0, 100.0) = 2.0;
uniform bool bus2_use_custom_color = false;
uniform vec4 bus2_color : source_color = vec4(0.15, 0.95, 0.35, 0.85);
uniform vec2 bus2_y_range = vec2(-0.8, 0.8);
uniform vec2 bus2_speed_range = vec2(0.45, 1.15);
uniform vec2 bus2_bend_shift_range = vec2(-0.35, 0.35);
uniform int bus2_min_bends : hint_range(0, 8) = 1;
uniform int bus2_max_bends : hint_range(0, 8) = 3;
uniform vec2 bus2_trail_length_range = vec2(0.8, 1.6);
uniform vec2 bus2_interval_range = vec2(0.2, 1.2);
uniform float bus2_trail_thickness : hint_range(0.5, 12.0) = 2.5;
uniform float bus2_trail_sharpness : hint_range(0.0, 1.0) = 0.2;
uniform int bus2_shape_mode : hint_enum("Circle", "Square", "Hexagon", "Triangle", "Random Mix") = 0;
uniform vec2 bus2_radius_range = vec2(0.02, 0.035);
uniform bool bus2_spin_nodes = false;
uniform float bus2_spin_speed : hint_range(-10.0, 10.0) = 2.0;
uniform bool bus2_exclude_shine_1 = false;
uniform bool bus2_exclude_shine_2 = false;
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

const int MAX_CIRCUIT_BENDS = 8;
const int MAX_BUS_LINES = 16;
const int MAX_TOTAL_LINES = 2 + MAX_BUS_LINES * 2;

// Tightly packed highp interpolators (11 slots total, well within mobile/integrated GPU limits)
varying highp vec2 v_local_pos;
varying flat highp vec3 v_flow_time;     // xy = cos/sin(flow_angle), z = TIME
varying flat highp vec4 v_travel_ds;     // xy = 48-bit (hi, lo) travel for line1, zw = 48-bit (hi, lo) travel for line2
varying flat highp vec4 v_node_spins;    // xy = spin1 (cos, sin), zw = spin2 (cos, sin)
varying flat vec4 v_bus_spins;           // xy = bus1 spin (cos, sin), zw = bus2 spin (cos, sin)
varying flat highp vec4 v_shine_params;  // x = shine_1_signed_t [-1..1], y = shine_2_signed_t [-1..1], z = shine_1_gain, w = shine_2_gain
varying flat vec4 v_precomp_1;           // x = s1_inner, y = s2_inner, z = g_node_blur, w = g_trail_blur
varying flat vec4 v_precomp_2;           // x = line1_ext_mult, y = line2_ext_mult, z = line1_spin_active, w = line2_spin_active
varying flat vec4 v_out_grad;            // xy = sin/cos(outline_grad_rot), z = inv_out_scale, w = exp_double
varying flat highp vec4 v_bg_xform;      // xy = sin/cos(bg_rot), zw = bounded active_bg_offset
varying flat vec4 v_bg_misc;             // xy = inv_bg_scale, z = inv_edge_reach, w = outer_limit

// 48-bit Double-Single (hi, lo) arithmetic helpers used in vertex() for long-uptime precision
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

// Fast zero-sin() integer ALU hash in [0.0, 1.0)
float hash_alu(uint x, uint y) {
	uint h = x * 374761393u + y * 668265263u;
	h = (h ^ (h >> 13u)) * 1274126177u;
	h ^= (h >> 16u);
	return float(h & 0x00FFFFFFu) * (1.0 / 16777216.0);
}

// Single-exit circumradius bounding multiplier for Circle (0), Square (1), Hexagon (2), or Triangle (3)
float get_shape_extent_mult(int shape, bool is_spinning) {
	float mult = 1.62;
	if (shape == 0) {
		mult = 1.0;
	} else if (shape == 1) {
		mult = is_spinning ? 1.42 : 1.0;
	} else if (shape == 2) {
		mult = 1.16;
	}
	return mult;
}

// Computes zoom-consistent trail width & blur attenuation for a given thickness & sharpness
void calc_trail_params(
	float thickness, float sharpness, float pixel_size, float trail_blur, float trail_retention,
	out float blur_half_w, out float inner_trail_w, out float trail_blur_atten
) {
	float geom_half_w = thickness * 0.004;
	float half_trail_w = max(geom_half_w, pixel_size * 0.5);
	float subpixel_trail_atten = geom_half_w / half_trail_w;

	blur_half_w = half_trail_w + trail_blur;
	float raw_inner_trail_w = max(half_trail_w - pixel_size * 0.5, 0.0) * sharpness;
	inner_trail_w = raw_inner_trail_w * (1.0 - clamp(trail_blur * 10.0, 0.0, 1.0)) - trail_blur;
	trail_blur_atten = subpixel_trail_atten * ((trail_blur > 0.0)
		? mix(half_trail_w / max(blur_half_w, 1e-5), 1.0, trail_retention)
		: 1.0);
}

// Single-exit shape coverage evaluator (no early returns so D3D12 DXIL CFG stays flat)
float eval_shape_alpha(vec2 p, float radius, float extent_mult, float pixel_size, float edge_soft, float blur_radius, float blur_85, float energy_retention, int shape, bool do_spin, vec2 spin_trig) {
	float alpha = 0.0;
	float max_extent = radius * extent_mult + edge_soft;
	if (abs(p.x) < max_extent && abs(p.y) < max_extent) {
		float sub_ratio = min(radius / max(pixel_size * 0.5, 1e-5), 1.0);
		float sub_energy = sub_ratio * sub_ratio;

		if (shape == 0) {
			if (blur_radius <= 0.0) {
				float r_min = max(radius - pixel_size * 0.5, 0.0);
				float r_max = radius + pixel_size * 0.5;
				alpha = smoothstep(r_max * r_max, r_min * r_min, dot(p, p)) * sub_energy;
			} else {
				float spread_ratio = radius / max(radius + blur_85, 1e-5);
				float energy_scale = mix(spread_ratio * spread_ratio, 1.0, energy_retention) * sub_energy;
				alpha = smoothstep(radius + edge_soft, radius - edge_soft, length(p)) * energy_scale;
			}
		} else {
			vec2 sp = p;
			if (do_spin) {
				sp = vec2(
					p.x * spin_trig.x - p.y * spin_trig.y,
					p.x * spin_trig.y + p.y * spin_trig.x
				);
			}

			if (shape == 1) {
				vec2 ap = abs(sp);
				alpha = smoothstep(radius + edge_soft, radius - edge_soft, max(ap.x, ap.y));
			} else if (shape == 2) {
				vec2 ap = abs(sp);
				alpha = smoothstep(radius + edge_soft, radius - edge_soft, max(ap.x * 0.8660254 + ap.y * 0.5, ap.y));
			} else {
				const float k = 1.7320508;
				const float inv_k = 0.57735027;
				float tri_scale = max(radius * 1.4, 1e-5);
				float inv_tri_scale = 1.0 / tri_scale;
				vec2 tp = sp * inv_tri_scale;
				tp.x = abs(tp.x) - 1.0;
				tp.y += inv_k;
				if (tp.x + k * tp.y > 0.0) {
					tp = vec2(tp.x - k * tp.y, -k * tp.x - tp.y) * 0.5;
				}
				tp.x -= clamp(tp.x, -2.0, 0.0);
				float norm_soft = edge_soft * inv_tri_scale;
				float tp_dist_sq = dot(tp, tp);
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
		}
	}
	return alpha;
}

// Single-exit shine blend mode evaluator (0=Add, 1=Mix, 2=Screen, 3=Multiply, 4=Overlay, 5=Soft Light, 6=Subtract)
vec3 apply_shine_blend(vec3 base, vec3 blend_col, float strength, int mode) {
	vec3 out_rgb = base;
	if (mode == 0) {
		out_rgb = base + blend_col * strength;
	} else if (mode == 6) {
		out_rgb = max(base - blend_col * strength, vec3(0.0));
	} else {
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
		out_rgb = mix(base, res, t);
	}
	return out_rgb;
}

// D3D12-safe single-exit circuit line evaluator (zero early returns, zero nested breaks)
void eval_circuit_line(
	vec2 p, float span_u, float span_v,
	highp vec2 travel_ds, uint line_seed_u,
	float y_norm, float bend_norm, float shift_norm,
	int bend_count_manual, bool use_random_bends, int min_bends_in, int max_bends_in,
	float trail_len, float interval_pause,
	float node_radius, float node_ext_mult, int node_shape, bool do_spin, vec2 spin_trig,
	vec4 base_node_col, bool exclude_node_s1, bool exclude_node_s2,
	float pixel_size, float blur_half_w, float inner_trail_w, float trail_blur_atten,
	float node_edge_soft, float node_blur, float node_blur_85, float node_retention,
	float s1_str, float s2_str, inout vec3 accum_rgb, inout float accum_a
) {
	// 1. Vertical band check before any cycle division, hash, or segment math
	float y_start = y_norm * span_v;
	float raw_dy = shift_norm * span_v;
	float y_clamped = clamp(y_start, -span_v * 0.96, span_v * 0.96);
	float node_reach = node_radius * node_ext_mult + node_edge_soft;
	float band_pad = max(node_reach, blur_half_w);
	float y_bound_lo = min(min(y_start, y_start + raw_dy), y_clamped) - band_pad;
	float y_bound_hi = max(max(y_start, y_start + raw_dy), y_clamped) + band_pad;

	if (p.y >= y_bound_lo && p.y <= y_bound_hi) {
		float entry_pad = node_radius * node_ext_mult + node_blur + 0.02;
		float u_min = -span_u - entry_pad;
		float u_max = span_u + entry_pad;
		float total_u = max(u_max - u_min, 1e-4);

		int b_lo = clamp(bend_count_manual, 0, MAX_CIRCUIT_BENDS);
		int b_hi = b_lo;
		if (use_random_bends) {
			int r_min = clamp(min_bends_in, 0, MAX_CIRCUIT_BENDS);
			int r_max = clamp(max_bends_in, 0, MAX_CIRCUIT_BENDS);
			b_lo = min(r_min, r_max);
			b_hi = max(r_min, r_max);
		}

		float max_dx_diag = abs(raw_dy);
		if (b_hi > 0 && float(b_hi) * max_dx_diag > total_u * 0.85) {
			max_dx_diag = (total_u * 0.85) / float(b_hi);
		}
		highp float max_l_total = total_u + float(b_hi) * 0.41421356 * max_dx_diag;
		highp float slot_cycle_len = max_l_total + trail_len + interval_pause;

		if (slot_cycle_len > 1e-5) {
			highp float sweep_idx = floor((travel_ds.x + travel_ds.y) / slot_cycle_len);
			highp float s_head = (travel_ds.x - sweep_idx * slot_cycle_len) + travel_ds.y;
			if (s_head < 0.0) {
				s_head += slot_cycle_len;
				sweep_idx -= 1.0;
			}

			// 2. Active cycle & horizontal head-to-tail bounds check before walking bend segments
			float x_bound_hi = u_min + s_head + band_pad;
			float x_bound_lo = u_min + max(s_head - trail_len, 0.0) * 0.70710678 - band_pad;

			if (s_head <= max_l_total + trail_len && p.x <= x_bound_hi && p.x >= x_bound_lo) {
				int active_bends = b_lo;
				if (use_random_bends && b_hi > b_lo) {
					float h = hash_alu(uint(max(sweep_idx, 0.0)), line_seed_u);
					active_bends = clamp(b_lo + int(floor(h * float(b_hi - b_lo + 1))), b_lo, b_hi);
				}

				float step_dy = raw_dy;
				if (active_bends > 0 && float(active_bends) * abs(step_dy) > total_u * 0.85) {
					step_dy *= (total_u * 0.85) / (float(active_bends) * abs(step_dy));
				}

				float curr_u = u_min;
				float curr_y = y_start;
				float s_acc = 0.0;
				vec2 head_pos = vec2(u_min, y_start);
				bool head_found = false;

				highp float best_dist_sq = 1e9;
				float best_s = 0.0;

				float min_gap = (active_bends > 1) ? min(0.02, (total_u * 0.12) / float(active_bends)) : 0.0;
				float offset_scale = (active_bends > 0) ? (span_u / float(active_bends)) : 0.0;

				// Bounded loop without internal 'break' for trivial D3D12 DXIL structurization
				for (int i = 0; i < MAX_CIRCUIT_BENDS; i++) {
					if (i < active_bends) {
						float dir_sign = ((i & 1) == 0) ? 1.0 : -1.0;
						float target_y = y_start + ((dir_sign > 0.0) ? step_dy : 0.0);
						if (active_bends > 1) {
							target_y = clamp(target_y, -span_v * 0.96, span_v * 0.96);
						}
						float actual_dy = target_y - curr_y;
						float dx_diag = abs(actual_dy);

						float frac_pos = float(i + 1) / float(active_bends + 1);
						float anchor_u = (-1.0 + 2.0 * frac_pos) * span_u + bend_norm * offset_scale;

						int rem_bends_after = active_bends - 1 - i;
						float rem_diag_budget = float(rem_bends_after) * (dx_diag + min_gap);
						float min_u_b1 = (i == 0) ? u_min : (curr_u + min_gap);
						float max_u_b1 = max(u_max - dx_diag - rem_diag_budget, min_u_b1);

						float u_b1 = clamp(anchor_u, min_u_b1, max_u_b1);
						float u_b2 = min(u_b1 + dx_diag, u_max);
						float actual_dx = u_b2 - u_b1;
						if (actual_dx < dx_diag && dx_diag > 1e-5) {
							actual_dy *= (actual_dx / dx_diag);
						}
						float next_y = curr_y + actual_dy;

						// 1. Horizontal straight segment leading into bend i
						float l_h = max(u_b1 - curr_u, 0.0);
						if (l_h > 1e-5) {
							if (!head_found && s_head <= s_acc + l_h) {
								head_pos = vec2(curr_u + (s_head - s_acc), curr_y);
								head_found = true;
							}
							float xh = clamp(p.x, curr_u, u_b1);
							float dxh = p.x - xh;
							float dyh = p.y - curr_y;
							float dh_sq = dxh * dxh + dyh * dyh;
							if (dh_sq < best_dist_sq) {
								best_dist_sq = dh_sq;
								best_s = s_acc + (xh - curr_u);
							}
							s_acc += l_h;
						}

						// 2. 45-degree diagonal bend segment i
						float l_d = sqrt(actual_dx * actual_dx + actual_dy * actual_dy);
						if (l_d > 1e-5) {
							if (!head_found && s_head <= s_acc + l_d) {
								float f = (s_head - s_acc) / l_d;
								head_pos = vec2(u_b1 + actual_dx * f, curr_y + actual_dy * f);
								head_found = true;
							}
							vec2 pa = p - vec2(u_b1, curr_y);
							vec2 ba = vec2(actual_dx, actual_dy);
							float h_proj = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
							vec2 diff_d = pa - ba * h_proj;
							float dd_sq = dot(diff_d, diff_d);
							if (dd_sq < best_dist_sq) {
								best_dist_sq = dd_sq;
								best_s = s_acc + h_proj * l_d;
							}
							s_acc += l_d;
						}

						curr_u = u_b2;
						curr_y = next_y;
					}
				}

				// 3. Final horizontal exit run
				float l_exit = max(u_max - curr_u, 0.0);
				if (l_exit > 1e-5) {
					if (!head_found && s_head <= s_acc + l_exit) {
						head_pos = vec2(curr_u + (s_head - s_acc), curr_y);
						head_found = true;
					}
					float xe = clamp(p.x, curr_u, u_max);
					float dxe = p.x - xe;
					float dye = p.y - curr_y;
					float de_sq = dxe * dxe + dye * dye;
					if (de_sq < best_dist_sq) {
						best_dist_sq = de_sq;
						best_s = s_acc + (xe - curr_u);
					}
					s_acc += l_exit;
				}

				highp float full_span = s_acc + trail_len;
				if (s_head <= full_span) {
					if (!head_found) {
						head_pos = vec2(u_max, curr_y);
					}

					// Evaluate leading Node coverage
					float node_a = eval_shape_alpha(
						p - head_pos, node_radius, node_ext_mult, pixel_size,
						node_edge_soft, node_blur, node_blur_85, node_retention,
						node_shape, do_spin, spin_trig
					);

					// Evaluate Trail width SDF and arc-length fade behind the moving head node
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
			}
		}
	}
}

// [UNUSED FROM DNA HELIX] Periodic dual-row helical column evaluator:
// void eval_helix_cell(...) { ... }

// Single-exit outline gradient smoothing & mapping helpers
float calculate_smoothed_factor(float factor, float smoothing) {
	float res = factor;
	if (smoothing < 0.5) {
		res = mix(step(0.5, factor), factor, smoothing * 2.0);
	} else if (smoothing > 0.5 && smoothing <= 1.0) {
		res = mix(factor, smoothstep(0.0, 1.0, factor), (smoothing - 0.5) * 2.0);
	} else if (smoothing > 1.0) {
		res = mix(pow(max(factor, 0.00001), smoothing), 1.0 - pow(max(1.0 - factor, 0.00001), smoothing), factor);
	}
	return res;
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

// Single-exit continuous background gradient curve
float smooth_bg_gradient(float t, float smoothing) {
	float res = t;
	if (smoothing > 0.5001) {
		float t2 = t * t;
		float quintic = t2 * t * (t * (t * 6.0 - 15.0) + 10.0);
		res = mix(t, quintic, (smoothing - 0.5) * 2.0);
	} else if (smoothing < 0.4999) {
		float half_w = max(smoothing, 1e-4);
		res = smoothstep(0.5 - half_w, 0.5 + half_w, t);
	}
	return res;
}

// Single-exit background evaluator: Solid Color (0), Gradient (1), or Texture (2)
vec4 eval_background(vec2 rect_uv, vec2 bg_uv_dx, vec2 bg_uv_dy) {
	vec4 bg = background_color;
	if (background_mode != 0) {
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
			bg = textureLod(background_gradient, vec2(factor, 0.5), 0.0) * background_tint;
		} else {
			vec2 rot_uv = vec2(dot(centered, rot_x), dot(centered, trig));
			vec2 tex_uv = rot_uv * v_bg_misc.xy + 0.5 - scroll_off;
			tex_uv = bg_repeat ? fract(tex_uv) : clamp(tex_uv, 0.0, 1.0);
			vec2 grad_x = vec2(dot(bg_uv_dx, rot_x), dot(bg_uv_dx, trig)) * v_bg_misc.xy;
			vec2 grad_y = vec2(dot(bg_uv_dy, rot_x), dot(bg_uv_dy, trig)) * v_bg_misc.xy;
			bg = textureGrad(background_texture, tex_uv, grad_x, grad_y) * background_tint;
		}
	}
	return bg;
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

	// Compute 48-bit double-single travel distances once per vertex for Hero Lines 1 & 2
	highp float flow_rad = radians(flow_angle_degrees);
	v_flow_time = vec3(cos(flow_rad), sin(flow_rad), TIME);
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

	vec2 bus1_spin = vec2(1.0, 0.0);
	if (enable_bus_1 && bus1_spin_nodes && bus1_spin_speed != 0.0 && bus1_shape_mode != 0) {
		highp float bus1_spin_angle = ds_mod(ds_mul(TIME, bus1_spin_speed), TAU_VAL);
		bus1_spin = vec2(cos(bus1_spin_angle), sin(bus1_spin_angle));
	}

	vec2 bus2_spin = vec2(1.0, 0.0);
	if (enable_bus_2 && bus2_spin_nodes && bus2_spin_speed != 0.0 && bus2_shape_mode != 0) {
		highp float bus2_spin_angle = ds_mod(ds_mul(TIME, bus2_spin_speed), TAU_VAL);
		bus2_spin = vec2(cos(bus2_spin_angle), sin(bus2_spin_angle));
	}
	v_bus_spins = vec4(bus1_spin, bus2_spin);

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

			// Resolve line & bus colors (buses inherit their parent line's color unless overridden)
			vec4 col1 = use_individual_colors ? line1_color : circuit_color;
			vec4 col2 = use_individual_colors ? line2_color : circuit_color;
			vec4 bus1_col = bus1_use_custom_color ? bus1_color : col1;
			vec4 bus2_col = bus2_use_custom_color ? bus2_color : col2;

			int b1_count = (enable_bus_1 && bus1_col.a > 0.0) ? clamp(bus1_line_count, 0, MAX_BUS_LINES) : 0;
			int b2_count = (enable_bus_2 && bus2_col.a > 0.0) ? clamp(bus2_line_count, 0, MAX_BUS_LINES) : 0;
			bool any_circuit_visible = col1.a > 0.0 || col2.a > 0.0 || b1_count > 0 || b2_count > 0;

			if (any_circuit_visible) {
				float uv_scale = 2.0 * inv_rect_size.y;
				float pixel_size = uv_grad.y * (rect_size.y + v_out_grad.w) * uv_scale;
				vec2 uv = pixel_pos * vec2(uv_scale, -uv_scale);

				// Rotate into circuit flow space (u = travel direction, v = lateral offset)
				vec2 rot = v_flow_time.xy;
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

				float node_edge_soft = pixel_size * 0.5 + node_blur;
				float node_blur_85 = node_blur * 0.85;

				// Precompute whole-bus vertical envelopes so off-band pixels skip entire buses cleanly
				float b1_y_min = min(bus1_y_range.x, bus1_y_range.y);
				float b1_y_max = max(bus1_y_range.x, bus1_y_range.y);
				float b1_sh_min = min(bus1_bend_shift_range.x, bus1_bend_shift_range.y);
				float b1_sh_max = max(bus1_bend_shift_range.x, bus1_bend_shift_range.y);
				float b1_r_min = max(min(bus1_radius_range.x, bus1_radius_range.y), 0.002);
				float b1_r_max = max(max(bus1_radius_range.x, bus1_radius_range.y), b1_r_min);
				float b1_max_pad = max(b1_r_max * 1.62 + node_edge_soft, max(bus1_trail_thickness * 0.004, pixel_size * 0.5) + trail_blur);
				float b1_v_lo = min(b1_y_min, b1_y_min + b1_sh_min) * span_v - b1_max_pad;
				float b1_v_hi = max(b1_y_max, b1_y_max + b1_sh_max) * span_v + b1_max_pad;
				bool in_bus1_band = (flow_uv.y >= b1_v_lo && flow_uv.y <= b1_v_hi);

				float b2_y_min = min(bus2_y_range.x, bus2_y_range.y);
				float b2_y_max = max(bus2_y_range.x, bus2_y_range.y);
				float b2_sh_min = min(bus2_bend_shift_range.x, bus2_bend_shift_range.y);
				float b2_sh_max = max(bus2_bend_shift_range.x, bus2_bend_shift_range.y);
				float b2_r_min = max(min(bus2_radius_range.x, bus2_radius_range.y), 0.002);
				float b2_r_max = max(max(bus2_radius_range.x, bus2_radius_range.y), b2_r_min);
				float b2_max_pad = max(b2_r_max * 1.62 + node_edge_soft, max(bus2_trail_thickness * 0.004, pixel_size * 0.5) + trail_blur);
				float b2_v_lo = min(b2_y_min, b2_y_min + b2_sh_min) * span_v - b2_max_pad;
				float b2_v_hi = max(b2_y_max, b2_y_max + b2_sh_max) * span_v + b2_max_pad;
				bool in_bus2_band = (flow_uv.y >= b2_v_lo && flow_uv.y <= b2_v_hi);

				uint b1_seed_u = uint(max(round(bus1_seed * 100.0), 0.0));
				uint b2_seed_u = uint(max(round(bus2_seed * 100.0), 0.0));
				int total_lines = 2 + b1_count + b2_count;

				// D3D12-safe unified loop: single top break, zero 'continue', single call site
				for (int idx = 0; idx < MAX_TOTAL_LINES; idx++) {
					if (idx >= total_lines || accum_a >= 0.999) {
						break;
					}

					bool line_valid = false;
					highp vec2 l_travel_ds = vec2(0.0);
					uint l_seed_u = 1u;
					float l_y_norm = 0.0;
					float l_bend_pos = 0.0;
					float l_bend_shift = 0.0;
					int l_bend_count = 1;
					bool l_rand_bends = false;
					int l_min_bends = 1;
					int l_max_bends = 1;
					float l_trail_len = 1.0;
					float l_interval = 0.0;
					float l_radius = 0.03;
					float l_ext = 1.0;
					int l_shape = 0;
					bool l_do_spin = false;
					vec2 l_spin_trig = vec2(1.0, 0.0);
					vec4 l_col = circuit_color;
					bool l_excl_s1 = false;
					bool l_excl_s2 = false;
					float l_thick = 2.5;
					float l_sharp = 0.2;

					if (idx == 0) {
						if (col1.a > 0.0) {
							line_valid = true;
							l_travel_ds = v_travel_ds.xy;
							l_seed_u = 101u;
							l_y_norm = line1_y_offset;
							l_bend_pos = line1_bend_pos;
							l_bend_shift = line1_bend_shift;
							l_bend_count = line1_bend_count;
							l_rand_bends = line1_random_bends;
							l_min_bends = line1_min_bends;
							l_max_bends = line1_max_bends;
							l_trail_len = line1_trail_length;
							l_interval = line1_interval;
							l_radius = line1_radius;
							l_ext = v_precomp_2.x;
							l_shape = line1_shape;
							l_do_spin = v_precomp_2.z > 0.5;
							l_spin_trig = v_node_spins.xy;
							l_col = col1;
							l_excl_s1 = shine_1_exclude_line1;
							l_excl_s2 = shine_2_exclude_line1;
							l_thick = line1_trail_thickness;
							l_sharp = line1_trail_sharpness;
						}
					} else if (idx == 1) {
						if (col2.a > 0.0) {
							line_valid = true;
							l_travel_ds = v_travel_ds.zw;
							l_seed_u = 202u;
							l_y_norm = line2_y_offset;
							l_bend_pos = line2_bend_pos;
							l_bend_shift = line2_bend_shift;
							l_bend_count = line2_bend_count;
							l_rand_bends = line2_random_bends;
							l_min_bends = line2_min_bends;
							l_max_bends = line2_max_bends;
							l_trail_len = line2_trail_length;
							l_interval = line2_interval;
							l_radius = line2_radius;
							l_ext = v_precomp_2.y;
							l_shape = line2_shape;
							l_do_spin = v_precomp_2.w > 0.5;
							l_spin_trig = v_node_spins.zw;
							l_col = col2;
							l_excl_s1 = shine_1_exclude_line2;
							l_excl_s2 = shine_2_exclude_line2;
							l_thick = line2_trail_thickness;
							l_sharp = line2_trail_sharpness;
						}
					} else if (idx < 2 + b1_count) {
						if (in_bus1_band) {
							int bi = idx - 2;
							uint u_key = uint(bi) * 16u + b1_seed_u * 257u + 1000u;

							float lane_t = (float(bi) + 0.15 + 0.7 * hash_alu(u_key, 0u)) / float(b1_count);
							l_y_norm = mix(b1_y_min, b1_y_max, lane_t);
							l_bend_shift = mix(b1_sh_min, b1_sh_max, hash_alu(u_key, 1u));
							float y_s = l_y_norm * span_v;
							float y_e = y_s + l_bend_shift * span_v;
							float y_c = clamp(y_s, -span_v * 0.96, span_v * 0.96);

							if (flow_uv.y >= min(min(y_s, y_e), y_c) - b1_max_pad && flow_uv.y <= max(max(y_s, y_e), y_c) + b1_max_pad) {
								line_valid = true;
								l_bend_pos = mix(-0.35, 0.35, hash_alu(u_key, 2u));
								float b_speed = mix(max(min(bus1_speed_range.x, bus1_speed_range.y), 0.0), max(max(bus1_speed_range.x, bus1_speed_range.y), 0.0), hash_alu(u_key, 3u));
								l_trail_len = mix(max(min(bus1_trail_length_range.x, bus1_trail_length_range.y), 0.02), max(max(bus1_trail_length_range.x, bus1_trail_length_range.y), 0.02), hash_alu(u_key, 4u));
								l_interval = mix(max(min(bus1_interval_range.x, bus1_interval_range.y), 0.0), max(max(bus1_interval_range.x, bus1_interval_range.y), 0.0), hash_alu(u_key, 5u));
								float b_toff = hash_alu(u_key, 6u) * 7.5;
								l_radius = mix(b1_r_min, b1_r_max, hash_alu(u_key, 7u));

								l_shape = bus1_shape_mode;
								if (bus1_shape_mode == 4) {
									l_shape = clamp(int(floor(hash_alu(u_key, 8u) * 4.0)), 0, 3);
								}
								l_do_spin = bus1_spin_nodes && bus1_spin_speed != 0.0 && l_shape != 0;
								l_ext = get_shape_extent_mult(l_shape, l_do_spin);
								l_spin_trig = v_bus_spins.xy;
								l_travel_ds = vec2((v_flow_time.z + b_toff) * b_speed, 0.0);
								l_seed_u = u_key + 9u;
								l_bend_count = bus1_min_bends;
								l_rand_bends = (bus1_min_bends != bus1_max_bends);
								l_min_bends = bus1_min_bends;
								l_max_bends = bus1_max_bends;
								l_col = bus1_col;
								l_excl_s1 = bus1_exclude_shine_1;
								l_excl_s2 = bus1_exclude_shine_2;
								l_thick = bus1_trail_thickness;
								l_sharp = bus1_trail_sharpness;
							}
						}
					} else if (in_bus2_band) {
						int bi = idx - 2 - b1_count;
						uint u_key = uint(bi) * 16u + b2_seed_u * 257u + 50000u;

						float lane_t = (float(bi) + 0.15 + 0.7 * hash_alu(u_key, 0u)) / float(b2_count);
						l_y_norm = mix(b2_y_min, b2_y_max, lane_t);
						l_bend_shift = mix(b2_sh_min, b2_sh_max, hash_alu(u_key, 1u));
						float y_s = l_y_norm * span_v;
						float y_e = y_s + l_bend_shift * span_v;
						float y_c = clamp(y_s, -span_v * 0.96, span_v * 0.96);

						if (flow_uv.y >= min(min(y_s, y_e), y_c) - b2_max_pad && flow_uv.y <= max(max(y_s, y_e), y_c) + b2_max_pad) {
							line_valid = true;
							l_bend_pos = mix(-0.35, 0.35, hash_alu(u_key, 2u));
							float b_speed = mix(max(min(bus2_speed_range.x, bus2_speed_range.y), 0.0), max(max(bus2_speed_range.x, bus2_speed_range.y), 0.0), hash_alu(u_key, 3u));
							l_trail_len = mix(max(min(bus2_trail_length_range.x, bus2_trail_length_range.y), 0.02), max(max(bus2_trail_length_range.x, bus2_trail_length_range.y), 0.02), hash_alu(u_key, 4u));
							l_interval = mix(max(min(bus2_interval_range.x, bus2_interval_range.y), 0.0), max(max(bus2_interval_range.x, bus2_interval_range.y), 0.0), hash_alu(u_key, 5u));
							float b_toff = hash_alu(u_key, 6u) * 7.5;
							l_radius = mix(b2_r_min, b2_r_max, hash_alu(u_key, 7u));

							l_shape = bus2_shape_mode;
							if (bus2_shape_mode == 4) {
								l_shape = clamp(int(floor(hash_alu(u_key, 8u) * 4.0)), 0, 3);
							}
							l_do_spin = bus2_spin_nodes && bus2_spin_speed != 0.0 && l_shape != 0;
							l_ext = get_shape_extent_mult(l_shape, l_do_spin);
							l_spin_trig = v_bus_spins.zw;
							l_travel_ds = vec2((v_flow_time.z + b_toff) * b_speed, 0.0);
							l_seed_u = u_key + 9u;
							l_bend_count = bus2_min_bends;
							l_rand_bends = (bus2_min_bends != bus2_max_bends);
							l_min_bends = bus2_min_bends;
							l_max_bends = bus2_max_bends;
							l_col = bus2_col;
							l_excl_s1 = bus2_exclude_shine_1;
							l_excl_s2 = bus2_exclude_shine_2;
							l_thick = bus2_trail_thickness;
							l_sharp = bus2_trail_sharpness;
						}
					}

					if (line_valid) {
						float l_blur_half_w = 0.0;
						float l_inner_trail_w = 0.0;
						float l_trail_blur_atten = 1.0;
						calc_trail_params(
							l_thick, l_sharp, pixel_size, trail_blur, trail_retention,
							l_blur_half_w, l_inner_trail_w, l_trail_blur_atten
						);

						eval_circuit_line(
							flow_uv, span_u, span_v,
							l_travel_ds, l_seed_u,
							l_y_norm, l_bend_pos, l_bend_shift,
							l_bend_count, l_rand_bends, l_min_bends, l_max_bends,
							l_trail_len, l_interval,
							l_radius, l_ext, l_shape, l_do_spin, l_spin_trig,
							l_col, l_excl_s1, l_excl_s2,
							pixel_size, l_blur_half_w, l_inner_trail_w, l_trail_blur_atten,
							node_edge_soft, node_blur, node_blur_85, node_retention,
							s1_str, s2_str, accum_rgb, accum_a
						);
					}
				}
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