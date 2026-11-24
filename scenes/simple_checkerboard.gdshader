shader_type canvas_item;

uniform float square_size : hint_range(1.0, 512.0) = 32.0;
uniform vec2 offset = vec2(0.0);
uniform int square_1_spacing : hint_range(1, 64) = 1;
uniform int square_2_spacing : hint_range(1, 64) = 1;

uniform vec4 color_1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 color_2 : source_color = vec4(1.0);

varying vec2 pattern_uv;
varying flat float threshold;

void vertex() {
	float safe_size = max(square_size, 0.001);
	float s1 = float(square_1_spacing);
	float total_cells = max(s1 + float(square_2_spacing), 1.0);
	float period_px = safe_size * total_cells;

	threshold = s1 / total_cells;

	// Pre-wrap offset to prevent precision drift and hoist division into the vertex stage
	vec2 wrapped_offset = mod(offset, period_px);
	pattern_uv = (VERTEX - wrapped_offset) / period_px;
}

void fragment() {
	vec2 cell = fract(pattern_uv);
	bvec2 in_first = lessThan(cell, vec2(threshold));

	COLOR = (in_first.x == in_first.y) ? color_1 : color_2;
}