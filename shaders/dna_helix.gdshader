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

varying vec2 v_local_pos;
varying flat vec2 v_rot;
varying flat vec2 v_time;
varying flat vec2 v_spin1;
varying flat vec2 v_spin2;
varying flat vec2 v_shine_t;
varying flat vec3 v_out_grad; // xy = sin/cos(outline_gradient_rotation), z = inv_scale
varying flat vec4 v_bg_xform; // xy = sin/cos(bg_rotation), zw = bg_offset (+ TIME * bg_scroll_speed when enabled)
varying flat vec2 v_bg_inv_scale;
varying flat float v_exp_double;

// Returns anti-aliased & energy-conserving blurred coverage for Circle (0), Square (1), Hexagon (2), or Triangle (3)
float eval_shape_alpha(vec2 p, float radius, float pixel_size, float blur_radius, float energy_retention, int shape, bool do_spin, vec2 spin_trig) {
	float edge_soft = pixel_size + blur_radius;
	float energy_scale = 1.0;
	if (blur_radius > 0.0) {
		float spread_ratio = radius / max(radius + blur_radius * 0.85, 1e-5);
		energy_scale = mix(spread_ratio * spread_ratio, 1.0, energy_retention);
	}

	if (shape == 0) {
		if (blur_radius <= 0.0) {
			float r_min = max(radius - pixel_size, 0.0);
			float r_max = radius + pixel_size;
			return smoothstep(r_max * r_max, r_min * r_min, dot(p, p));
		}
		float dist = length(p);
		return smoothstep(radius + edge_soft, radius - edge_soft, dist) * energy_scale;
	}
	
	if (do_spin) {
		p = vec2(
			p.x * spin_trig.x - p.y * spin_trig.y,
			p.x * spin_trig.y + p.y * spin_trig.x
		);
	}
	
	float dist = 0.0;
	if (shape == 1) {
		vec2 ap = abs(p);
		dist = max(ap.x, ap.y);
	} else if (shape == 2) {
		vec2 ap = abs(p);
		dist = max(ap.x * 0.8660254 + ap.y * 0.5, ap.y);
	} else {
		const float k = 1.7320508;
		float tri_scale = max(radius * 1.4, 1e-5);
		vec2 tp = p / tri_scale;
		tp.x = abs(tp.x) - 1.0;
		tp.y = tp.y + 1.0 / k;
		if (tp.x + k * tp.y > 0.0) {
			tp = vec2(tp.x - k * tp.y, -k * tp.x - tp.y) * 0.5;
		}
		tp.x -= clamp(tp.x, -2.0, 0.0);
		float signed_d = -length(tp) * sign(tp.y) * tri_scale;
		return smoothstep(edge_soft, -edge_soft, signed_d) * energy_scale;
	}
	
	return smoothstep(radius + edge_soft, radius - edge_soft, dist) * energy_scale;
}

// Returns vec2(coverage_alpha, depth_shade)
vec2 eval_node(vec2 cell_pos, float pixel_size, float blur_radius, float energy_retention, float sin_dna, float cos_raw, float side_sign, float base_radius, int shape, bool do_spin, vec2 spin_trig) {
	float height = side_sign * sin_dna;
	float depth = 0.5 * abs(side_sign - cos_raw);
	float radius = base_radius + depth * node_depth_scale;
	
	vec2 p = vec2(cell_pos.x, cell_pos.y - height);
	float alpha = eval_shape_alpha(p, radius, pixel_size, blur_radius, energy_retention, shape, do_spin, spin_trig);
	float shade = depth * depth_contrast + (1.0 - depth_contrast);
	return vec2(alpha, shade);
}

// Computes sweeping shine strength [0..intensity] across the helix
float eval_shine_strength(vec2 helix_uv, float base_span, float max_bound, float shine_t, float s_alpha, float s_intensity, float s_width, float s_softness, float s_slant) {
	float half_span = base_span + s_width + abs(s_slant) * max_bound;
	float shine_center = mix(-half_span, half_span, shine_t);
	float shine_dist = abs((helix_uv.x + helix_uv.y * s_slant) - shine_center);
	float inner_shine = s_width * (1.0 - s_softness);
	float shine_mask = smoothstep(s_width, max(inner_shine - 1e-5, 0.0), shine_dist);
	return shine_mask * s_intensity * s_alpha;
}

// Applies selected blend mode (0=Add, 1=Mix, 2=Screen, 3=Multiply, 4=Overlay, 5=Soft Light, 6=Subtract)
vec3 apply_shine_blend(vec3 base, vec3 blend_col, float strength, int mode) {
	if (strength <= 0.0) {
		return base;
	}
	if (mode == 0) {
		return base + blend_col * strength;
	} else if (mode == 6) {
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
		vec3 lo = 2.0 * b * blend_col + b * b * (1.0 - 2.0 * blend_col);
		vec3 hi = sqrt(b) * (2.0 * blend_col - 1.0) + 2.0 * b * (1.0 - blend_col);
		res = mix(lo, hi, step(0.5, blend_col));
	}
	return mix(base, res, t);
}

// Evaluates a single helix column (cell_index) at local offset dx and composites into accum_rgb / accum_a
void eval_helix_cell(
	float cell_index, float dx, float uv_y, vec2 helix_uv, float base_span, float max_bound,
	float pixel_size, float node_blur, float node_retention, float rung_blur, float rung_retention,
	inout vec3 accum_rgb, inout float accum_a
) {
	float dna_phase = cell_index * twist_density + v_time.y;
	float sin_raw = sin(dna_phase);
	float cos_raw = cos(dna_phase);
	float sin_dna = sin_raw * amplitude;
	
	// Rung line SDF with adjustable sharpness, blur defocus, and vertical end-caps
	float half_w = pixel_size * rung_thickness;
	float blur_half_w = half_w + rung_blur;
	float sharp_atten = 1.0 - clamp(rung_blur * 4.0, 0.0, 1.0);
	float inner_w = mix(0.0, max(half_w - pixel_size * 0.5, 0.0), rung_sharpness) * sharp_atten;
	float line = smoothstep(blur_half_w, inner_w - rung_blur, abs(dx));
	
	float cut_up = abs(sin_dna);
	float cut_down = -cut_up;
	float cap_soft = pixel_size + rung_blur;
	float mask_up = smoothstep(cut_up + cap_soft, cut_up - cap_soft, uv_y);
	float mask_down = smoothstep(cut_down - cap_soft, cut_down + cap_soft, uv_y);
	float line_cov = line * mask_up * mask_down;
	
	if (rung_blur > 0.0) {
		float rung_ratio = half_w / max(blur_half_w, 1e-5);
		line_cov *= mix(rung_ratio, 1.0, rung_retention);
	}
	
	// Evaluate Row 1 (+1.0) and Row 2 (-1.0) nodes
	vec2 cell_pos = vec2(dx, uv_y);
	vec2 node1 = eval_node(cell_pos, pixel_size, node_blur, node_retention, sin_dna, cos_raw, 1.0, row1_base_radius, row1_shape, spin_row1_nodes, v_spin1);
	vec2 node2 = eval_node(cell_pos, pixel_size, node_blur, node_retention, sin_dna, cos_raw, -1.0, row2_base_radius, row2_shape, spin_row2_nodes, v_spin2);
	
	// Rung depth gradient between the two nodes
	float grad_t = clamp(uv_y / max(2.0 * cut_up, 1e-5) + 0.5, 0.0, 1.0);
	grad_t = sin_raw > 0.0 ? (1.0 - grad_t) : grad_t;
	float line_shade = mix(node1.y, node2.y, grad_t);
	
	// Resolve active colors (Global vs. Individual Colors group)
	vec4 col1 = helix_color;
	vec4 col2 = helix_color;
	vec4 col_rung = helix_color;
	
	if (use_individual_colors) {
		col1 = row1_color;
		col2 = row2_color;
		float denom = abs(sin_dna) < 1e-5 ? 1e-5 : (2.0 * sin_dna);
		float rung_uv_x = clamp((sin_dna - uv_y) / denom, 0.0, 1.0);
		col_rung = texture(rung_gradient, vec2(rung_uv_x, 0.5));
	}
	
	// Evaluate Shine 1 and Shine 2 strengths independently
	float s1_str = 0.0;
	if (enable_shine_1 && v_shine_t.x >= 0.0 && v_shine_t.x <= 1.0) {
		s1_str = eval_shine_strength(helix_uv, base_span, max_bound, v_shine_t.x, shine_1_color.a, shine_1_intensity, shine_1_width, shine_1_softness, shine_1_slant);
	}
	
	float s2_str = 0.0;
	if (enable_shine_2 && v_shine_t.y >= 0.0 && v_shine_t.y <= 1.0) {
		s2_str = eval_shine_strength(helix_uv, base_span, max_bound, v_shine_t.y, shine_2_color.a, shine_2_intensity, shine_2_width, shine_2_softness, shine_2_slant);
	}
	
	// Apply Shine 1 then Shine 2 using their respective blend modes and per-element exclusions
	vec3 row1_rgb = col1.rgb * node1.y;
	row1_rgb = apply_shine_blend(row1_rgb, shine_1_color.rgb, shine_1_exclude_row1 ? 0.0 : s1_str, shine_1_blend_mode);
	row1_rgb = apply_shine_blend(row1_rgb, shine_2_color.rgb, shine_2_exclude_row1 ? 0.0 : s2_str, shine_2_blend_mode);
	
	vec3 row2_rgb = col2.rgb * node2.y;
	row2_rgb = apply_shine_blend(row2_rgb, shine_1_color.rgb, shine_1_exclude_row2 ? 0.0 : s1_str, shine_1_blend_mode);
	row2_rgb = apply_shine_blend(row2_rgb, shine_2_color.rgb, shine_2_exclude_row2 ? 0.0 : s2_str, shine_2_blend_mode);
	
	vec3 rung_rgb = col_rung.rgb * line_shade;
	rung_rgb = apply_shine_blend(rung_rgb, shine_1_color.rgb, shine_1_exclude_rung ? 0.0 : s1_str, shine_1_blend_mode);
	rung_rgb = apply_shine_blend(rung_rgb, shine_2_color.rgb, shine_2_exclude_rung ? 0.0 : s2_str, shine_2_blend_mode);
	
	// Branchless back-to-front depth sorting: rung sits behind both node faces
	bool n1_in_front = node1.y > node2.y;
	vec2 back_node = n1_in_front ? node2 : node1;
	vec3 back_rgb = n1_in_front ? row2_rgb : row1_rgb;
	float back_col_a = n1_in_front ? col2.a : col1.a;
	
	vec2 front_node = n1_in_front ? node1 : node2;
	vec3 front_rgb = n1_in_front ? row1_rgb : row2_rgb;
	float front_col_a = n1_in_front ? col1.a : col2.a;
	
	float rung_a = line_cov * col_rung.a;
	accum_rgb = mix(accum_rgb, rung_rgb, rung_a);
	accum_a = mix(accum_a, 1.0, rung_a);
	
	float back_a = back_node.x * back_col_a;
	accum_rgb = mix(accum_rgb, back_rgb, back_a);
	accum_a = mix(accum_a, 1.0, back_a);
	
	float front_a = front_node.x * front_col_a;
	accum_rgb = mix(accum_rgb, front_rgb, front_a);
	accum_a = mix(accum_a, 1.0, front_a);
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
		float quintic = t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
		return mix(t, quintic, (smoothing - 0.5) * 2.0);
	}
	float half_w = max(smoothing, 1e-4);
	return smoothstep(0.5 - half_w, 0.5 + half_w, t);
}

// Evaluates Solid Color (0), Gradient (1), or Texture (2) background centered at (0.5, 0.5)
vec4 eval_background(vec2 rect_uv) {
	if (background_mode == 0) {
		return background_color;
	}
	
	vec2 trig = v_bg_xform.xy;
	vec2 scroll_off = v_bg_xform.zw;
	vec2 centered = rect_uv - 0.5;
	vec2 rot_uv = vec2(
		dot(centered, vec2(trig.y, -trig.x)),
		dot(centered, trig)
	);
	
	if (background_mode == 1) {
		float factor = 0.0;
		if (bg_gradient_type == 0) {
			factor = rot_uv.x * v_bg_inv_scale.x + 0.5;
		} else if (bg_gradient_type == 1) {
			factor = rot_uv.y * v_bg_inv_scale.x + 0.5;
		} else if (bg_gradient_type == 2) {
			factor = length(rot_uv * v_bg_inv_scale) * 2.0;
		} else {
			factor = abs(rot_uv.y * v_bg_inv_scale.x) * 2.0;
		}
		
		factor -= scroll_off.x;
		factor = bg_repeat ? fract(factor) : clamp(factor, 0.0, 1.0);
		factor = smooth_bg_gradient(factor, bg_gradient_smoothing);
		return textureLod(background_gradient, vec2(factor, 0.5), 0.0) * background_tint;
	}
	
	// Texture mode (2): centered rotation, 2D scale, offset, and optional smooth 2D scroll
	vec2 tex_uv = rot_uv * v_bg_inv_scale + 0.5 - scroll_off;
	tex_uv = bg_repeat ? fract(tex_uv) : clamp(tex_uv, 0.0, 1.0);
	return texture(background_texture, tex_uv) * background_tint;
}

void vertex() {
	// Expand mesh bounds in local space so outer outlines and blurred edges never clip
	float exp_pad = 2.0;
	if (enable_outline) {
		exp_pad += outline_width + outline_blur;
	}
	v_exp_double = exp_pad * 2.0;
	VERTEX += (UV - 0.5) * v_exp_double;
	v_local_pos = VERTEX;

	if (enable_outline) {
		float out_rad = radians(outline_gradient_rotation_degrees);
		v_out_grad = vec3(sin(out_rad), cos(out_rad), 1.0 / max(outline_gradient_scale, 0.001));
	} else {
		v_out_grad = vec3(0.0, 1.0, 1.0);
	}

	if (background_mode != 0) {
		float bg_rad = radians(bg_rotation_degrees);
		vec2 active_offset = bg_enable_scroll ? (bg_offset + TIME * bg_scroll_speed) : bg_offset;
		v_bg_xform = vec4(sin(bg_rad), cos(bg_rad), active_offset);
		v_bg_inv_scale = 1.0 / max(abs(bg_scale), vec2(1e-4)) * sign(bg_scale + vec2(1e-7));
	} else {
		v_bg_xform = vec4(0.0, 1.0, 0.0, 0.0);
		v_bg_inv_scale = vec2(1.0);
	}

	// Precompute helix trig and time products once per vertex
	v_rot = vec2(cos(angle), sin(angle));
	v_time = vec2(TIME * scroll_speed, TIME * rotation_speed);
	
	float spin1_angle = TIME * row1_spin_speed;
	v_spin1 = vec2(cos(spin1_angle), sin(spin1_angle));
	
	float spin2_angle = TIME * row2_spin_speed;
	v_spin2 = vec2(cos(spin2_angle), sin(spin2_angle));
	
	float cycle1 = 1.0 + shine_1_interval;
	float m1 = mod(TIME * abs(shine_1_speed), cycle1);
	v_shine_t.x = (shine_1_speed >= 0.0) ? m1 : (1.0 - m1);
	
	float cycle2 = 1.0 + shine_2_interval;
	float m2 = mod(TIME * abs(shine_2_speed), cycle2);
	v_shine_t.y = (shine_2_speed >= 0.0) ? m2 : (1.0 - m2);
}

void fragment() {
	vec2 uv_cen = UV - 0.5;
	vec2 uv_deriv = max(fwidth(UV), vec2(1e-6));
	
	// Zoom-invariant local ColorRect size
	vec2 expanded_size = fwidth(v_local_pos) / uv_deriv;
	vec2 rect_size = max(expanded_size - v_exp_double, vec2(0.001));
	vec2 pixel_pos = uv_cen * expanded_size;

	// Rounded / Beveled Rect Signed Distance Field in local node space (d = 0 at original ColorRect edge)
	vec2 half_size = rect_size * 0.5;
	vec2 q_sign = step(0.0, uv_cen);
	float r = mix(
		mix(corner_radii.w, corner_radii.z, q_sign.x),
		mix(corner_radii.x, corner_radii.y, q_sign.x),
		q_sign.y
	);
	r = min(r, min(half_size.x, half_size.y));

	vec2 q_box = abs(pixel_pos) - half_size + vec2(r);
	vec2 max_q_vec = max(q_box, 0.0);
	float max_q = max(q_box.x, q_box.y);
	float dist_inner = min(max_q, 0.0) - r;
	float d = use_beveled_corners
		? max(max_q, (max_q_vec.x + max_q_vec.y) * 0.70710678) + dist_inner
		: length(max_q_vec) + dist_inner;

	float outer_limit = enable_outline ? (outline_width + outline_blur + 1.5) : 1.5;
	
	// Un-padded UVs [0..1] locked to the original ColorRect bounds (compute fwidth before branching)
	vec2 rect_uv = pixel_pos / rect_size + 0.5;
	float pixel_size = max(fwidth(rect_uv.y), 1e-6) * 2.0 * scale;

	if (d > outer_limit) {
		COLOR = vec4(0.0);
	} else {
		// Interior mask (d <= 0) keeps background & helix strictly inside the ColorRect
		float inner_mask = 1.0 - smoothstep(-0.75, 0.75, d);
		
		vec3 inner_rgb = vec3(0.0);
		float inner_a = 0.0;
		
		if (inner_mask > 0.0) {
			float aspect = rect_size.x / rect_size.y;
			vec2 uv = (rect_uv * 2.0 - 1.0) * vec2(aspect, -1.0) * scale;
			
			// Rotate into helix-aligned space (preserved un-scrolled for end-to-end shine sweeps)
			vec2 helix_uv = vec2(
				uv.x * v_rot.x + uv.y * v_rot.y,
				uv.y * v_rot.x - uv.x * v_rot.y
			);
			uv = vec2(helix_uv.x - v_time.x, helix_uv.y);
			
			// Combine Global Helix Blur + Edge-to-Center Border Blur (strictly inside d <= 0; outline untouched)
			float g_blur = (enable_helix_blur && helix_blur_amount > 0.0) ? (helix_blur_amount * 0.35) : 0.0;
			float e_blur = 0.0;
			if (enable_edge_blur && edge_blur_amount > 0.0) {
				float inward_dist = max(-d - edge_blur_edge_offset, 0.0);
				float edge_t = 1.0 - clamp(inward_dist / max(edge_blur_reach, 1e-4), 0.0, 1.0);
				edge_t = pow(smoothstep(0.0, 1.0, edge_t), edge_blur_falloff);
				e_blur = edge_t * edge_blur_amount * 0.35;
			}
			
			float g_node = helix_blur_affect_nodes ? g_blur : 0.0;
			float e_node = edge_blur_affect_nodes ? e_blur : 0.0;
			float node_blur = g_node + e_node;
			float node_retention = (node_blur > 1e-5)
				? (g_node * helix_blur_energy_retention + e_node * edge_blur_energy_retention) / node_blur
				: 1.0;
			
			float g_rung = helix_blur_affect_rungs ? g_blur : 0.0;
			float e_rung = edge_blur_affect_rungs ? e_blur : 0.0;
			float rung_blur = g_rung + e_rung;
			float rung_retention = (rung_blur > 1e-5)
				? (g_rung * helix_blur_energy_retention + e_rung * edge_blur_energy_retention) / rung_blur
				: 1.0;
			
			float max_blur = max(node_blur, rung_blur);
			float max_radius = max(row1_base_radius, row2_base_radius) + node_depth_scale;
			float max_bound = amplitude + max_radius * 1.5 + max_blur + pixel_size;
			
			vec3 accum_rgb = vec3(0.0);
			float accum_a = 0.0;
			
			// Skip all helix math for pixels outside the diagonal band
			if (abs(uv.y) <= max_bound) {
				float line_index = floor(uv.x);
				float cell_x = fract(uv.x);
				float dx = cell_x - 0.5;
				float base_span = (aspect * abs(v_rot.x) + abs(v_rot.y)) * scale;
				
				// When heavy blur spills across cell boundaries, also sample the nearest adjacent column
				if (max_radius * 1.5 + max_blur > 0.48) {
					float neighbor_dir = dx < 0.0 ? -1.0 : 1.0;
					eval_helix_cell(
						line_index + neighbor_dir, dx - neighbor_dir, uv.y, helix_uv, base_span, max_bound,
						pixel_size, node_blur, node_retention, rung_blur, rung_retention,
						accum_rgb, accum_a
					);
				}
				
				eval_helix_cell(
					line_index, dx, uv.y, helix_uv, base_span, max_bound,
					pixel_size, node_blur, node_retention, rung_blur, rung_retention,
					accum_rgb, accum_a
				);
			}
			
			// Evaluate background (Solid Color, Gradient, or Texture) and composite helix cleanly over it
			vec4 bg_col = eval_background(rect_uv);
			float combined_inner_a = accum_a + bg_col.a * (1.0 - accum_a);
			if (combined_inner_a > 0.0) {
				inner_rgb = (accum_rgb + bg_col.rgb * bg_col.a * (1.0 - accum_a)) / combined_inner_a;
			}
			inner_a = combined_inner_a * inner_mask;
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
				
				float combined_a = out_a + final_a * (1.0 - out_a);
				if (combined_a > 0.0) {
					final_rgb = (out_color.rgb * out_a + final_rgb * final_a * (1.0 - out_a)) / combined_a;
				}
				final_a = combined_a;
			}
		}
		
		COLOR = vec4(final_rgb, final_a);
	}
}