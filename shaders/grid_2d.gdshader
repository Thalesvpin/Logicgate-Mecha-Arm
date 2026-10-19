shader_type canvas_item;

group_uniforms Colors;
uniform vec4 bg_color : source_color = vec4(0.08, 0.08, 0.1, 1.0);
uniform vec4 grid_color : source_color = vec4(0.2, 0.5, 1.0, 1.0);
uniform vec4 subgrid_color : source_color = vec4(0.15, 0.15, 0.22, 1.0);

group_uniforms Checkerboard;
uniform bool use_checkerboard = false;
uniform vec4 checker_color : source_color = vec4(0.1, 0.1, 0.12, 1.0);

group_uniforms MouseHighlight;
uniform bool use_mouse_highlight = true;
// When true, the highlight radius is measured in screen pixels rather than world pixels
uniform bool absolute_highlight = false;
uniform bool highlight_main_grid = true;
uniform bool highlight_subgrid = true;
uniform bool highlight_background = true;
uniform float highlight_radius : hint_range(10.0, 1000.0) = 150.0;
uniform float highlight_intensity : hint_range(0.0, 10.0) = 1.0;
uniform sampler2D highlight_gradient : hint_default_transparent; 
uniform sampler2D highlight_opacity_gradient : hint_default_white; 
uniform vec2 mouse_global_pos = vec2(-10000.0); 

group_uniforms MainGrid;
uniform int main_grid_style : hint_enum("Lines", "Dots", "Crosses") = 0;
uniform float main_line_thickness : hint_range(0.5, 10.0) = 2.0;
uniform float main_dot_cross_size : hint_range(0.5, 20.0) = 4.0;

group_uniforms Subgrid;
uniform int subgrid_style : hint_enum("Lines", "Dots", "Crosses") = 0;
uniform bool absolute_subgrid = false; 
uniform float absolute_subgrid_size : hint_range(10.0, 500.0) = 20.0; 
uniform float subgrid_divisions : hint_range(1.0, 10.0) = 5.0;
uniform float subgrid_line_thickness : hint_range(0.5, 5.0) = 1.0;
uniform float subgrid_dot_cross_size : hint_range(0.5, 10.0) = 2.0;

group_uniforms Settings;
uniform float grid_pixel_size : hint_range(10.0, 500.0) = 100.0;
uniform float line_smoothness : hint_range(0.0, 10.0) = 1.0;
uniform float dot_cross_smoothness : hint_range(0.0, 10.0) = 1.0;

group_uniforms Viewport;
uniform vec2 pan_offset = vec2(0.0);
uniform float zoom : hint_range(0.1, 10.0) = 1.0;

varying vec2 grid_uv;
varying vec2 absolute_uv;
varying vec2 global_pos;
varying float v_camera_zoom;

varying float v_main_thresh;
varying float v_sub_thresh;
varying float v_main_smooth;
varying float v_sub_smooth;

void vertex() {
	global_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	
	grid_uv = ((VERTEX * zoom) + pan_offset) / grid_pixel_size;
	
	// Calculate and store camera zoom for both absolute features
	v_camera_zoom = length(CANVAS_MATRIX[0].xy);
	absolute_uv = ((VERTEX * v_camera_zoom) + pan_offset) / absolute_subgrid_size;
	
	if (main_grid_style == 0) {
		v_main_thresh = main_line_thickness;
	} else if (main_grid_style == 1) {
		v_main_thresh = main_dot_cross_size;
	} else {
		v_main_thresh = 0.0;
	}
	
	if (subgrid_style == 0) {
		v_sub_thresh = subgrid_line_thickness;
	} else if (subgrid_style == 1) {
		v_sub_thresh = subgrid_dot_cross_size;
	} else {
		v_sub_thresh = 0.0;
	}
	
	float ms = (main_grid_style == 0) ? line_smoothness : dot_cross_smoothness;
	float ss = (subgrid_style == 0) ? line_smoothness : dot_cross_smoothness;
	v_main_smooth = max(0.001, ms);
	v_sub_smooth = max(0.001, ss);
}

void fragment() {
	vec2 main_fw = fwidth(grid_uv);
	
	vec2 active_sub_uv;
	vec2 sub_fw;
	
	if (absolute_subgrid) {
		active_sub_uv = absolute_uv;
		sub_fw = fwidth(absolute_uv);
	} else {
		active_sub_uv = grid_uv * subgrid_divisions;
		sub_fw = main_fw * subgrid_divisions;
	}
	
	float main_val = 0.0;
	float sub_val = 0.0;
	
	// --- Subgrid Calculations ---
	if (subgrid_style == 0) { // Lines
		vec2 sub_grid = abs(fract(active_sub_uv - 0.5) - 0.5) / sub_fw;
		sub_val = min(sub_grid.x, sub_grid.y);
	} else if (subgrid_style == 1) { // Dots
		vec2 sub_pos = (fract(active_sub_uv) - 0.5) / sub_fw;
		sub_val = length(sub_pos);
	} else { // Crosses
		vec2 sub_pos = (fract(active_sub_uv) - 0.5) / sub_fw;
		vec2 p = abs(sub_pos);
		float th = max(1.0, subgrid_dot_cross_size * 0.35);
		float sz = subgrid_dot_cross_size;
		sub_val = min(max(p.x - th, p.y - sz), max(p.y - th, p.x - sz));
	}
	
	// --- Main Grid Calculations ---
	if (main_grid_style == 0) { // Lines
		vec2 main_grid = abs(fract(grid_uv - 0.5) - 0.5) / main_fw;
		main_val = min(main_grid.x, main_grid.y);
	} else if (main_grid_style == 1) { // Dots
		vec2 main_pos = (fract(grid_uv) - 0.5) / main_fw;
		main_val = length(main_pos);
	} else { // Crosses
		vec2 main_pos = (fract(grid_uv) - 0.5) / main_fw;
		vec2 p = abs(main_pos);
		float th = max(1.0, main_dot_cross_size * 0.35);
		float sz = main_dot_cross_size;
		main_val = min(max(p.x - th, p.y - sz), max(p.y - th, p.x - sz));
	}
	
	// --- Rendering Masks ---
	float sub_alpha = 1.0 - smoothstep(v_sub_thresh - v_sub_smooth, v_sub_thresh + v_sub_smooth, sub_val);
	float main_alpha = 1.0 - smoothstep(v_main_thresh - v_main_smooth, v_main_thresh + v_main_smooth, main_val);
	
	// --- Background & Checkerboard ---
	vec4 final_bg = bg_color;
	if (use_checkerboard) {
		vec2 cell_id = floor(grid_uv);
		if (mod(cell_id.x + cell_id.y, 2.0) > 0.5) {
			final_bg = checker_color;
		}
	}
	
	// --- Colors Setup ---
	vec4 current_grid_color = grid_color;
	vec4 current_subgrid_color = subgrid_color;
	
	// --- Mouse Radial Highlight / Flashlight ---
	if (use_mouse_highlight) {
		float mouse_dist = length(global_pos - mouse_global_pos);
		
		if (absolute_highlight) {
			mouse_dist *= v_camera_zoom;
		}
		
		if (mouse_dist < highlight_radius) {
			float gradient_pos = mouse_dist / highlight_radius;
			
			vec4 highlight_color = texture(highlight_gradient, vec2(gradient_pos, 0.5));
			vec4 highlight_opacity = texture(highlight_opacity_gradient, vec2(gradient_pos, 0.5));
			
			float opacity_val = highlight_opacity.a * highlight_opacity.r;
			vec3 added_light = highlight_color.rgb * highlight_color.a * opacity_val * highlight_intensity;
			
			if (highlight_main_grid) {
				current_grid_color.rgb += added_light;
				current_grid_color.a = clamp(current_grid_color.a + opacity_val, 0.0, 1.0);
			}
			
			if (highlight_subgrid) {
				current_subgrid_color.rgb += added_light;
				current_subgrid_color.a = clamp(current_subgrid_color.a + opacity_val, 0.0, 1.0);
			}
			
			if (highlight_background) {
				final_bg.rgb += added_light;
				final_bg.a = clamp(final_bg.a + opacity_val, 0.0, 1.0);
			}
		}
	}
	
	// --- Final Blending ---
	vec4 final_color = mix(final_bg, current_subgrid_color, sub_alpha * current_subgrid_color.a);
	final_color = mix(final_color, current_grid_color, main_alpha * current_grid_color.a);
	
	COLOR = final_color;
}