shader_type canvas_item;

uniform vec4 square_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float line_thickness : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float spacing : hint_range(2.0, 256.0, 1.0) = 12.0;
uniform float square_length : hint_range(0.05, 0.95, 0.01) = 0.45;
uniform float square_thickness : hint_range(0.05, 1.0, 0.01) = 1.0;
uniform float speed : hint_range(0.0, 500.0, 1.0) = 5.0;
uniform bool invert_trajectory = false;

varying float v_inv_spacing;
varying float v_phase;
varying vec2 v_sq_half_size;
varying float v_line_half_thickness;

void vertex() {
	v_inv_spacing = 1.0 / spacing;
	float dir = invert_trajectory ? 1.0 : -1.0;
	v_phase = fract(TIME * speed * v_inv_spacing) * dir;
	v_sq_half_size = vec2(square_length, square_thickness) * 0.5;
	v_line_half_thickness = line_thickness * 0.5;
}

void fragment() {
	vec2 cell = vec2(fract(UV.x * v_inv_spacing + v_phase), UV.y);
	vec2 sq_mask = step(abs(cell - 0.5), v_sq_half_size);
	float line_mask = step(abs(UV.y - 0.5), v_line_half_thickness);

	float src_a = square_color.a * sq_mask.x * sq_mask.y;
	float dst_a = COLOR.a * line_mask;
	float out_a = src_a + dst_a * (1.0 - src_a);
	vec3 out_rgb = mix(COLOR.rgb, square_color.rgb, src_a / max(out_a, 0.0001));

	COLOR = vec4(out_rgb, out_a);
}