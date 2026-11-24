shader_type canvas_item;

group_uniforms Checkerboard;
uniform float square_size : hint_range(1.0, 512.0) = 32.0;
uniform vec2 offset = vec2(0.0);
uniform int square_1_spacing : hint_range(1, 64) = 1;
uniform int square_2_spacing : hint_range(1, 64) = 1;
uniform bool match_rect_color_1 = false;
uniform vec4 color_1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 color_2 : source_color = vec4(1.0);
group_uniforms;

group_uniforms EdgeMask;
uniform bool edge_only = false;
uniform float edge_top : hint_range(0.0, 512.0) = 3.0;
uniform float edge_bottom : hint_range(0.0, 512.0) = 3.0;
uniform float edge_left : hint_range(0.0, 512.0) = 3.0;
uniform float edge_right : hint_range(0.0, 512.0) = 3.0;
uniform vec4 cutout_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);
group_uniforms;

varying vec2 pattern_uv;
varying vec2 local_pos;
varying flat float threshold;
varying flat vec4 resolved_color_1;

void vertex() {
	float safe_size = max(square_size, 0.001);
	float s1 = float(square_1_spacing);
	float total_cells = max(s1 + float(square_2_spacing), 1.0);
	float period_px = safe_size * total_cells;

	threshold = s1 / total_cells;
	resolved_color_1 = match_rect_color_1 ? COLOR : color_1;

	// Pre-wrap offset to prevent precision drift and hoist division into the vertex stage
	vec2 wrapped_offset = mod(offset, period_px);
	pattern_uv = (VERTEX - wrapped_offset) / period_px;
	local_pos = VERTEX;
}

void fragment() {
	vec2 cell = fract(pattern_uv);
	bvec2 in_first = lessThan(cell, vec2(threshold));
	vec4 pattern_color = (in_first.x == in_first.y) ? resolved_color_1 : color_2;

	if (edge_only) {
		// Derive the ColorRect's local pixel dimensions automatically without script overhead
		vec2 rect_size = local_pos / max(UV, vec2(1e-6));
		vec2 dist_from_br = rect_size - local_pos;

		bool in_cutout = local_pos.x > edge_left &&
				dist_from_br.x > edge_right &&
				local_pos.y > edge_top &&
				dist_from_br.y > edge_bottom;

		COLOR = in_cutout ? cutout_color : pattern_color;
	} else {
		COLOR = pattern_color;
	}
}