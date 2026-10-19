shader_type canvas_item;

// --- Colors ---
uniform vec4 bg_color : source_color = vec4(0.08, 0.08, 0.1, 1.0);
uniform vec4 grid_color : source_color = vec4(0.2, 0.5, 1.0, 1.0);
uniform vec4 subgrid_color : source_color = vec4(0.15, 0.15, 0.22, 1.0);

// --- Style & Layout ---
uniform int grid_style : hint_enum("Lines", "Dots") = 0;
uniform float grid_pixel_size : hint_range(10.0, 500.0) = 100.0;
uniform float line_thickness : hint_range(0.5, 10.0) = 2.0;
uniform float dot_size : hint_range(0.5, 10.0) = 2.0;
uniform float subgrid_divisions : hint_range(1.0, 10.0) = 5.0;
uniform float subgrid_thickness : hint_range(0.5, 5.0) = 1.0;

// --- Viewport Control ---
uniform vec2 pan_offset = vec2(0.0);
uniform float zoom : hint_range(0.1, 10.0) = 1.0;

varying vec2 grid_uv;

void vertex() {
	grid_uv = ((VERTEX * zoom) + pan_offset) / grid_pixel_size;
}

void fragment() {
	vec2 main_fw = fwidth(grid_uv);
	vec2 sub_fw = main_fw * subgrid_divisions;
	
	float main_val = 0.0;
	float sub_val = 0.0;
	
	if (grid_style == 0) {
		// --- Lines Style (Graph Paper) ---
		vec2 sub_grid = abs(fract(grid_uv * subgrid_divisions - 0.5) - 0.5) / sub_fw;
		sub_val = min(sub_grid.x, sub_grid.y);
		
		vec2 main_grid = abs(fract(grid_uv - 0.5) - 0.5) / main_fw;
		main_val = min(main_grid.x, main_grid.y);
	} else {
		// --- Dots Style (Dot Matrix at Intersections) ---
		vec2 sub_pos = (fract(grid_uv * subgrid_divisions) - 0.5) / sub_fw;
		sub_val = length(sub_pos);
		
		vec2 main_pos = (fract(grid_uv) - 0.5) / main_fw;
		main_val = length(main_pos);
	}
	
	// --- Rendering & Blending ---
	// Blend Subgrid
	float sub_thresh = (grid_style == 0) ? subgrid_thickness : dot_size * 0.75;
	float sub_alpha = 1.0 - smoothstep(0.0, sub_thresh, sub_val);
	vec4 final_color = mix(bg_color, subgrid_color, sub_alpha);
	
	// Blend Main Grid
	float main_thresh = (grid_style == 0) ? line_thickness : dot_size;
	float main_alpha = 1.0 - smoothstep(0.0, main_thresh, main_val);
	COLOR = mix(final_color, grid_color, main_alpha);
}