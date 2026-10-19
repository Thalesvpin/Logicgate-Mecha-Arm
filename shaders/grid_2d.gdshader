shader_type canvas_item;

// --- Colors ---
uniform vec4 bg_color : source_color = vec4(0.08, 0.08, 0.1, 1.0);
uniform vec4 grid_color : source_color = vec4(0.2, 0.5, 1.0, 1.0);
uniform vec4 subgrid_color : source_color = vec4(0.15, 0.15, 0.22, 1.0);

// --- Grid Dimensions (in Pixels) ---
uniform float grid_pixel_size : hint_range(10.0, 500.0) = 100.0;
uniform float line_thickness : hint_range(0.5, 10.0) = 2.0;
uniform float subgrid_divisions : hint_range(1.0, 10.0) = 5.0;
uniform float subgrid_thickness : hint_range(0.5, 5.0) = 1.0;

// --- Viewport Control ---
uniform vec2 pan_offset = vec2(0.0);
uniform float zoom : hint_range(0.1, 10.0) = 1.0;

varying vec2 local_pos;

void vertex() {
	// Captures exact local pixel coordinates of the ColorRect
	local_pos = VERTEX;
}

void fragment() {
	// Apply zoom and panning offset in pixel space
	vec2 pos = (local_pos * zoom) + pan_offset;
	
	float cell_size = grid_pixel_size;
	
	// --- Subgrid Calculations ---
	vec2 sub_pos = pos / (cell_size / subgrid_divisions);
	vec2 sub_fw = fwidth(sub_pos);
	vec2 sub_grid = abs(fract(sub_pos - 0.5) - 0.5) / sub_fw;
	float sub_line = min(sub_grid.x, sub_grid.y);
	
	// --- Main Grid Calculations ---
	vec2 main_pos = pos / cell_size;
	vec2 main_fw = fwidth(main_pos);
	vec2 main_grid = abs(fract(main_pos - 0.5) - 0.5) / main_fw;
	float main_line = min(main_grid.x, main_grid.y);
	
	// --- Rendering & Blending ---
	vec4 final_color = bg_color;
	
	// Draw subgrid lines
	float sub_thresh = subgrid_thickness;
	if (sub_line < sub_thresh) {
		float sub_alpha = 1.0 - smoothstep(0.0, sub_thresh, sub_line);
		final_color = mix(final_color, subgrid_color, sub_alpha);
	}
	
	// Draw main grid lines on top
	float main_thresh = line_thickness;
	if (main_line < main_thresh) {
		float main_alpha = 1.0 - smoothstep(0.0, main_thresh, main_line);
		final_color = mix(final_color, grid_color, main_alpha);
	}
	
	COLOR = final_color;
}