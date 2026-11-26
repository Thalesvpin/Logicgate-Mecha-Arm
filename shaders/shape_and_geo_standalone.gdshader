shader_type canvas_item;

// =============================================================================
// Shape & Geometry
// =============================================================================
group_uniforms Shape_And_Geometry;
uniform vec4 corner_radii = vec4(0.0); // TL, TR, BR, BL
uniform bvec4 use_beveled_corners = bvec4(false); // TL, TR, BR, BL
uniform float edge_sharpness : hint_range(0.0, 1.0) = 0.5;
group_uniforms;

// =============================================================================
// VARYINGS (Minimal 2-Float Footprint for Low-End & Mobile Compatibility)
// =============================================================================
varying vec2 local_pos;

// =============================================================================
// VERTEX SHADER
// =============================================================================
void vertex() {
	local_pos = VERTEX;
}

// =============================================================================
// FRAGMENT SHADER
// =============================================================================
void fragment() {
	vec2 uv_cen = UV - 0.5;
	vec2 rect_size = fwidth(local_pos) / max(fwidth(UV), vec2(0.00001));
	vec2 half_size = rect_size * 0.5;
	vec2 pixel_pos = uv_cen * rect_size;

	float d = 0.0;
	if (corner_radii == vec4(0.0) && !any(use_beveled_corners)) {
		vec2 q_box = abs(pixel_pos) - half_size;
		d = length(max(q_box, 0.0)) + min(max(q_box.x, q_box.y), 0.0);
	} else {
		vec2 q_sign = step(0.0, uv_cen);
		float r = mix(
			mix(corner_radii.w, corner_radii.z, q_sign.x),
			mix(corner_radii.x, corner_radii.y, q_sign.x),
			q_sign.y
		);
		r = min(r, min(half_size.x, half_size.y));

		vec4 bevel_vec = vec4(use_beveled_corners);
		float is_beveled = mix(
			mix(bevel_vec.w, bevel_vec.z, q_sign.x),
			mix(bevel_vec.x, bevel_vec.y, q_sign.x),
			q_sign.y
		);

		vec2 q_box = abs(pixel_pos) - half_size + vec2(r);
		vec2 max_q_vec = max(q_box, 0.0);
		float max_q = max(q_box.x, q_box.y);
		float dist_inner = min(max_q, 0.0) - r;

		float d_round = length(max_q_vec) + dist_inner;
		float d_bevel = max(max_q, (max_q_vec.x + max_q_vec.y) * 0.70710678) + dist_inner;
		d = mix(d_round, d_bevel, is_beveled);
	}

	float outer_aa = max((1.0 - edge_sharpness) * 3.0, 0.0001);
	float shape_alpha = 1.0 - smoothstep(-outer_aa, 0.0, d - 0.001);

	if (shape_alpha <= 0.0) {
		COLOR = vec4(0.0);
	} else {
		COLOR.a *= shape_alpha;
	}
}