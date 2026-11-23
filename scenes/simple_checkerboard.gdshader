shader_type canvas_item;

uniform int columns : hint_range(1, 512) = 20;
uniform int rows : hint_range(1, 512) = 20;
uniform float offset_x = 0.0;
uniform float offset_y = 0.0;
uniform int square_1_spacing : hint_range(1, 64) = 1;
uniform int square_2_spacing : hint_range(1, 64) = 1;

uniform vec4 color1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 color2 : source_color = vec4(1.0);

void fragment() {
	vec2 grid = vec2(float(columns), float(rows));

	// Measure the ColorRect's true screen-space aspect ratio automatically (rotation-safe, no script needed)
	vec2 uv_deriv = vec2(
		length(vec2(dFdx(UV.x), dFdy(UV.x))),
		length(vec2(dFdx(UV.y), dFdy(UV.y)))
	);
	float rect_aspect = uv_deriv.y / uv_deriv.x;
	float grid_aspect = grid.x / grid.y;
	float ratio = rect_aspect / grid_aspect;

	// Scale UVs along the longer axis so every cell remains a 1:1 square
	vec2 uv = UV;
	if (ratio > 1.0) {
		uv.x *= ratio;
	} else {
		uv.y /= ratio;
	}

	// Snap to discrete grid cells while keeping smooth float offsets
	vec2 pos = floor(uv * grid - vec2(offset_x, offset_y));
	float s1_space = float(square_1_spacing);
	float total = s1_space + float(square_2_spacing);
	vec2 cell = mod(pos, total);

	bool is_color1 = (cell.x < s1_space) == (cell.y < s1_space);
	COLOR = is_color1 ? color1 : color2;
}