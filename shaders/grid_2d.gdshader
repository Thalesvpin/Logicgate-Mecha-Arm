shader_type canvas_item;

const int MAX_CLICKS = 8;

group_uniforms Colors_and_Theme;
uniform vec4 bg_color : source_color = vec4(0.08, 0.08, 0.1, 1.0);
uniform vec4 grid_color : source_color = vec4(0.2, 0.5, 1.0, 1.0);
uniform vec4 subgrid_color : source_color = vec4(0.15, 0.15, 0.22, 1.0);
uniform bool invert_colors = false;
uniform float main_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float sub_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float main_hue_shift_speed = 0.0;
uniform float sub_hue_shift_speed = 0.0;
uniform float bg_hue_shift_speed = 0.0;

group_uniforms MouseHighlight;
uniform bool use_mouse_highlight = true;
uniform bool invert_highlight = false; 
uniform bool absolute_highlight = false;
uniform bool highlight_main_grid = true;
uniform bool highlight_subgrid = true;
uniform bool highlight_background = true;
uniform float highlight_radius : hint_range(10.0, 1000.0) = 150.0;
uniform float highlight_intensity : hint_range(0.0, 10.0) = 1.0;
uniform sampler2D highlight_gradient : hint_default_transparent; 
uniform sampler2D highlight_opacity_gradient : hint_default_white; 

group_uniforms CursorRepulsion;
uniform bool use_cursor_repulsion = false;
uniform bool use_click_repulsion = false;
uniform float cursor_repulsion : hint_range(0.0, 2000.0) = 500.0; 
uniform int repulsion_mode : hint_enum("Push", "Pull", "Vortex", "Lens", "Pinch", "Wave", "Spiral") = 0;
uniform float repulsion_falloff : hint_range(0.1, 5.0) = 1.0;
uniform float repulsion_inner_radius : hint_range(0.0, 300.0) = 0.0;
uniform float repulsion_aspect : hint_range(0.2, 5.0) = 1.0;
uniform float repulsion_swirl_angle : hint_range(-10.0, 10.0) = 2.0;
uniform float repulsion_pinch_amount : hint_range(-2.0, 2.0) = 0.5;
uniform float repulsion_wave_freq : hint_range(0.5, 20.0) = 5.0;
uniform float hole_punch_radius : hint_range(0.0, 500.0) = 0.0; 
uniform vec2 mouse_global_pos = vec2(-10000.0); 
uniform vec4 repulsion_click_sources_v4[MAX_CLICKS];
uniform int active_click_repulsion_count = 0;

group_uniforms Ripple_Shockwave;
uniform bool use_ripple = false;
uniform int ripple_ring_count : hint_range(1, 10) = 1;
uniform float ripple_ring_spacing : hint_range(5.0, 100.0) = 20.0;
uniform float ripple_thickness : hint_range(1.0, 300.0) = 30.0;
uniform float ripple_frequency : hint_range(1.0, 10.0) = 1.0;
uniform float ripple_decay : hint_range(0.0, 5.0) = 1.0;
uniform float ripple_grid_distortion : hint_range(0.0, 200.0) = 0.0;
uniform bool use_ripple_custom_color = false;
uniform vec4 ripple_custom_color : source_color = vec4(1.0, 0.8, 0.3, 1.0);
uniform vec4 ripple_sources_v4[MAX_CLICKS];
uniform int active_ripple_count = 0;

group_uniforms MainGrid;
uniform int main_grid_style : hint_enum("Lines", "Dots", "Crosses", "Brackets") = 0;
uniform float main_line_thickness : hint_range(0.5, 10.0) = 2.0;
uniform float main_dot_cross_size : hint_range(0.5, 20.0) = 4.0;
uniform float main_rail_offset : hint_range(0.0, 0.5) = 0.0;
uniform float main_dash_size : hint_range(0.0, 2.0) = 0.0;
uniform bool use_main_thickness_mod = false;
uniform float main_thickness_mod : hint_range(0.0, 5.0) = 0.0;

group_uniforms Subgrid;
uniform int subgrid_style : hint_enum("Lines", "Dots", "Crosses", "Brackets") = 0;
uniform bool absolute_subgrid = false; 
uniform float absolute_subgrid_size : hint_range(10.0, 500.0) = 20.0; 
uniform float subgrid_divisions : hint_range(1.0, 10.0) = 5.0;
uniform float subgrid_line_thickness : hint_range(0.5, 5.0) = 1.0;
uniform float subgrid_dot_cross_size : hint_range(0.5, 10.0) = 2.0;
uniform float subgrid_rail_offset : hint_range(0.0, 0.5) = 0.0;
uniform float subgrid_dash_size : hint_range(0.0, 2.0) = 0.0;
uniform float subgrid_parallax_mult : hint_range(0.0, 2.0) = 1.0; 

group_uniforms MicroGrid;
uniform bool use_microgrid = false;
uniform int micro_grid_style : hint_enum("Lines", "Dots", "Crosses", "Brackets") = 0;
uniform float microgrid_divisions : hint_range(1.0, 10.0) = 5.0;
uniform float micro_line_thickness : hint_range(0.1, 5.0) = 0.5;
uniform float micro_dot_cross_size : hint_range(0.5, 10.0) = 1.0;
uniform float micro_smoothness : hint_range(0.0, 10.0) = 1.0;
uniform vec4 microgrid_color : source_color = vec4(0.1, 0.1, 0.15, 0.5);
uniform float micro_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float micro_parallax_mult : hint_range(0.0, 2.0) = 1.0;

group_uniforms Overlays;
uniform bool use_checkerboard = false;
uniform vec4 checker_color : source_color = vec4(0.1, 0.1, 0.12, 1.0);
uniform bool use_hatching = false;
uniform float hatching_size : hint_range(5.0, 100.0) = 20.0;
uniform float hatching_thickness : hint_range(0.5, 5.0) = 1.0;
uniform vec4 hatching_color : source_color = vec4(1.0, 1.0, 1.0, 0.05);

group_uniforms Settings;
uniform bool auto_aspect_ratio = false;
uniform float grid_pixel_size : hint_range(10.0, 500.0) = 100.0;
uniform float line_smoothness : hint_range(0.0, 10.0) = 1.0;
uniform float dot_cross_smoothness : hint_range(0.0, 10.0) = 1.0;
uniform vec2 rect_size = vec2(100.0);

group_uniforms Viewport;
uniform vec2 pan_offset = vec2(0.0);
uniform float zoom : hint_range(0.1, 10.0) = 1.0;

// GPU Precomputation Cache Varyings
varying vec2 v_local_pos;
varying vec2 v_global_pos;
varying vec2 v_main_uv;
varying vec2 v_sub_uv;
varying vec2 v_micro_uv;
varying float v_camera_zoom;
varying float v_effective_radius;
varying float v_ripple_total_span;
varying float v_ripple_span_inv;
varying float v_ripple_wave_mult;
varying float v_shock_width;
varying float v_shock_width_inv;
varying float v_cursor_force;
varying float v_ripple_force;
varying vec4 v_c_bg;
varying vec4 v_c_main;
varying vec4 v_c_sub;
varying vec4 v_c_mi;
varying float v_main_fw_inv;
varying float v_sub_fw_inv;
varying float v_micro_fw_inv;

vec3 hue_shift(vec3 color, float shift) {
	const vec3 k = vec3(0.57735);
	float cosAngle = cos(shift);
	return vec3(color * cosAngle + cross(k, color) * sin(shift) + k * dot(k, color) * (1.0 - cosAngle));
}

void vertex() {
	v_local_pos = VERTEX;
	v_global_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	v_camera_zoom = length(CANVAS_MATRIX[0].xy);
	v_effective_radius = absolute_highlight ? (highlight_radius / v_camera_zoom) : highlight_radius;
	
	// Coordinate Space Scaling
	vec2 base_uv_scale = vec2(zoom / grid_pixel_size);
	if (auto_aspect_ratio && rect_size.y > 0.0) { 
		base_uv_scale.x *= (rect_size.x / rect_size.y); 
	}
	
	v_main_uv = ((VERTEX * zoom) + pan_offset) / grid_pixel_size;
	if (auto_aspect_ratio && rect_size.y > 0.0) v_main_uv.x *= (rect_size.x / rect_size.y);
	
	if (absolute_subgrid) {
		v_sub_uv = ((VERTEX * v_camera_zoom) + (pan_offset * subgrid_parallax_mult)) / absolute_subgrid_size;
	} else {
		v_sub_uv = v_main_uv * subgrid_divisions + (pan_offset * subgrid_parallax_mult / grid_pixel_size * subgrid_divisions);
	}
	v_micro_uv = v_main_uv * (subgrid_divisions * microgrid_divisions) + (pan_offset * micro_parallax_mult / grid_pixel_size * (subgrid_divisions * microgrid_divisions));
	
	// Analytic Derivative Replacement
	float fw_base = max(base_uv_scale.x, base_uv_scale.y);
	v_main_fw_inv = 1.0 / max(0.0001, fw_base);
	v_sub_fw_inv = absolute_subgrid ? (1.0 / max(0.0001, v_camera_zoom / absolute_subgrid_size)) : (1.0 / max(0.0001, fw_base * subgrid_divisions));
	v_micro_fw_inv = 1.0 / max(0.0001, fw_base * (subgrid_divisions * microgrid_divisions));
	
	// Precomputed Constants
	v_ripple_total_span = ripple_thickness + (float(ripple_ring_count - 1) * ripple_ring_spacing);
	v_ripple_span_inv = 1.0 / max(0.001, v_ripple_total_span);
	v_ripple_wave_mult = 3.14159 * float(ripple_ring_count) * ripple_frequency;
	v_shock_width = v_effective_radius * 0.5;
	v_shock_width_inv = 1.0 / max(0.001, v_shock_width);
	v_cursor_force = cursor_repulsion / 1000.0;
	v_ripple_force = ripple_grid_distortion / 1000.0;
	
	// Hue Shift & Global Opacity
	v_c_bg = bg_color;
	v_c_main = grid_color;
	v_c_sub = subgrid_color;
	v_c_mi = microgrid_color;
	
	if (bg_hue_shift_speed != 0.0) v_c_bg.rgb = hue_shift(v_c_bg.rgb, TIME * bg_hue_shift_speed);
	if (main_hue_shift_speed != 0.0) v_c_main.rgb = hue_shift(v_c_main.rgb, TIME * main_hue_shift_speed);
	if (sub_hue_shift_speed != 0.0) v_c_sub.rgb = hue_shift(v_c_sub.rgb, TIME * sub_hue_shift_speed);
	
	v_c_main.a *= main_opacity;
	v_c_sub.a *= sub_opacity;
	v_c_mi.a *= micro_opacity;
}

float get_grid_val(vec2 uv, int style, float fw_inv, float th, float sz, float rail, float dash, bool use_mod, float t_mod) {
	vec2 p = abs(fract(uv) - 0.5);
	if (rail > 0.001) p = abs(p - rail);
	
	if (use_mod) {
		vec2 id = floor(uv);
		float mod_mult = 1.0 + (sin(id.x * 12.9898 + id.y * 78.233) * t_mod);
		th *= mod_mult; sz *= mod_mult;
	}
	
	if (style == 0) { // Lines
		vec2 grid = p * fw_inv;
		float val = min(grid.x, grid.y);
		if (dash > 0.001) {
			float axis = (p.x < p.y) ? uv.y : uv.x;
			if (fract(axis / dash) > 0.5) val = 100.0;
		}
		return val;
	} else if (style == 1) { // Dots
		return length(p * fw_inv);
	} else if (style == 2) { // Crosses
		vec2 pa = p * fw_inv;
		return min(max(pa.x - th, pa.y - sz), max(pa.y - th, pa.x - sz));
	} else { // Brackets
		vec2 pa = p * fw_inv;
		float cross_val = min(max(pa.x - th, pa.y - sz), max(pa.y - th, pa.x - sz));
		return (length(pa) < sz * 0.45) ? 100.0 : cross_val;
	}
}

vec2 get_mode_direction(vec2 base_dir, float norm_dist, float force) {
	if (repulsion_mode == 0) return base_dir * force; 
	if (repulsion_mode == 1) return -base_dir * force; 
	if (repulsion_mode == 2) return vec2(-base_dir.y, base_dir.x) * (force * repulsion_swirl_angle); 
	if (repulsion_mode == 3) return base_dir * ((pow(norm_dist, max(0.01, 1.0 - repulsion_pinch_amount)) - norm_dist) * force * 2.0);
	if (repulsion_mode == 4) return -base_dir * ((norm_dist - pow(norm_dist, max(0.01, 1.0 + repulsion_pinch_amount))) * force * 2.0);
	if (repulsion_mode == 5) return base_dir * (sin(norm_dist * 3.14159 * repulsion_wave_freq) * force); 
	
	vec2 perp = vec2(-base_dir.y, base_dir.x);
	vec2 spiral = mix(base_dir, perp, clamp(abs(repulsion_swirl_angle) * 0.2, 0.0, 1.0));
	return spiral * (force * sign(repulsion_swirl_angle == 0.0 ? 1.0 : repulsion_swirl_angle));
}

void fragment() {
	vec4 c_bg = v_c_bg; vec4 c_main = v_c_main; vec4 c_sub = v_c_sub; vec4 c_mi = v_c_mi;
	
	vec2 shared_warp = vec2(0.0);
	float light_opacity = 0.0;
	vec3 added_light = vec3(0.0);
	float cursor_dist = length(v_global_pos - mouse_global_pos);
	
	if (use_cursor_repulsion && cursor_repulsion > 0.001) {
		vec2 diff = v_global_pos - mouse_global_pos;
		if (abs(diff.x) <= v_effective_radius && abs(diff.y) <= v_effective_radius) {
			diff.x *= repulsion_aspect;
			float dist = max(0.0, length(diff) - repulsion_inner_radius);
			if (dist < v_effective_radius) {
				float norm_dist = clamp(1.0 - (dist / v_effective_radius), 0.0, 1.0);
				float force = pow(norm_dist, repulsion_falloff) * v_cursor_force;
				vec2 base_dir = (dist > 0.001) ? (diff / dist) : vec2(1.0, 0.0);
				shared_warp += get_mode_direction(base_dir, norm_dist, force);
			}
		}
	}
	
	// FIX: Use a "processed" counter to find all scattered active clicks in the ring buffer safely
	if (use_click_repulsion && active_click_repulsion_count > 0) {
		int processed = 0;
		for (int i = 0; i < MAX_CLICKS; i++) {
			if (processed >= active_click_repulsion_count) break;
			float c_rad = repulsion_click_sources_v4[i].z;
			if (c_rad <= 0.0) continue;
			processed++;
			
			vec2 diff = v_global_pos - repulsion_click_sources_v4[i].xy;
			if (abs(diff.x) > c_rad + v_shock_width || abs(diff.y) > c_rad + v_shock_width) continue;
			
			diff.x *= repulsion_aspect;
			float dist = max(0.0, length(diff) - repulsion_inner_radius);
			float c_diff = abs(dist - c_rad);
			
			if (c_diff < v_shock_width) {
				float norm = 1.0 - (c_diff * v_shock_width_inv);
				float norm_click = norm * (2.0 - norm); 
				float force = norm_click * repulsion_click_sources_v4[i].w * v_cursor_force;
				vec2 base_dir = (dist > 0.001) ? (diff / dist) : vec2(1.0, 0.0);
				shared_warp += get_mode_direction(base_dir, norm_click, force);
			}
		}
	}
	
	// FIX: Use a "processed" counter here as well
	if (use_ripple && active_ripple_count > 0) {
		int processed = 0;
		for (int i = 0; i < MAX_CLICKS; i++) {
			if (processed >= active_ripple_count) break;
			float r_rad = ripple_sources_v4[i].z;
			if (r_rad <= 0.0) continue;
			processed++;
			
			vec2 diff = v_global_pos - ripple_sources_v4[i].xy;
			if (abs(diff.x) > r_rad + v_ripple_total_span || abs(diff.y) > r_rad + v_ripple_total_span) continue;
			
			float r_dist = length(diff);
			float r_diff = abs(r_dist - r_rad);
			
			if (r_diff < v_ripple_total_span) {
				float gp = r_diff * v_ripple_span_inv;
				float warp_wave = sin(gp * v_ripple_wave_mult);
				float light_wave = abs(warp_wave);
				
				if (ripple_grid_distortion > 0.001) {
					vec2 r_dir = (r_dist > 0.001) ? (diff / r_dist) : vec2(1.0, 0.0);
					shared_warp += r_dir * (warp_wave * v_ripple_force);
				}
				
				float decay = ripple_sources_v4[i].w;
				if (decay > 0.01) {
					vec4 hO = texture(highlight_opacity_gradient, vec2(gp, 0.5));
					float oV = hO.a * hO.r * light_wave * decay;
					if (oV > 0.0) {
						vec4 hC = use_ripple_custom_color ? ripple_custom_color : texture(highlight_gradient, vec2(gp, 0.5));
						added_light += hC.rgb * hC.a * oV * highlight_intensity;
						light_opacity += oV;
					}
				}
			}
		}
	}
	
	vec2 m_uv = v_main_uv + shared_warp;
	vec2 s_uv = v_sub_uv + shared_warp;
	vec2 mi_uv = v_micro_uv + shared_warp;
	
	float mT = (main_grid_style == 0) ? main_line_thickness : main_dot_cross_size;
	float sT = (subgrid_style == 0) ? subgrid_line_thickness : subgrid_dot_cross_size;
	float miT = (micro_grid_style == 0) ? micro_line_thickness : micro_dot_cross_size;
	float mS = max(0.001, (main_grid_style == 0) ? line_smoothness : dot_cross_smoothness);
	float sS = max(0.001, (subgrid_style == 0) ? line_smoothness : dot_cross_smoothness);
	float miS = max(0.001, micro_smoothness);
	float mCth = max(1.0, main_dot_cross_size * 0.35); 
	float sCth = max(1.0, subgrid_dot_cross_size * 0.35); 
	float miCth = max(1.0, micro_dot_cross_size * 0.35);
	
	float main_val = get_grid_val(m_uv, main_grid_style, v_main_fw_inv, mCth, mT, main_rail_offset, main_dash_size, use_main_thickness_mod, main_thickness_mod);
	float main_mask = 1.0 - smoothstep(mT - mS, mT + mS, main_val);
	
	float sub_val = get_grid_val(s_uv, subgrid_style, v_sub_fw_inv, sCth, sT, subgrid_rail_offset, subgrid_dash_size, false, 0.0);
	float sub_mask = 1.0 - smoothstep(sT - sS, sT + sS, sub_val);
	
	float micro_mask = 0.0;
	if (use_microgrid) {
		float mi_val = get_grid_val(mi_uv, micro_grid_style, v_micro_fw_inv, miCth, miT, 0.0, 0.0, false, 0.0);
		micro_mask = 1.0 - smoothstep(miT - miS, miT + miS, mi_val);
	}
	
	if (hole_punch_radius > 0.001 && cursor_dist < hole_punch_radius) {
		main_mask = 0.0; sub_mask = 0.0; micro_mask = 0.0;
	}
	
	if (use_mouse_highlight && cursor_dist < v_effective_radius) {
		float gp = cursor_dist / v_effective_radius;
		vec4 hO = texture(highlight_opacity_gradient, vec2(gp, 0.5));
		float oV = hO.a * hO.r;
		if (oV > 0.0) {
			vec4 hC = texture(highlight_gradient, vec2(gp, 0.5));
			light_opacity += oV;
			added_light += hC.rgb * hC.a * oV * highlight_intensity;
		}
	}
	
	if (light_opacity > 0.0) {
		if (highlight_main_grid) { c_main.rgb += added_light; c_main.a = invert_highlight ? max(0.0, c_main.a - light_opacity) : min(1.0, c_main.a + light_opacity); }
		if (highlight_subgrid) { c_sub.rgb += added_light; c_sub.a = invert_highlight ? max(0.0, c_sub.a - light_opacity) : min(1.0, c_sub.a + light_opacity); }
		if (use_microgrid) { c_mi.rgb += added_light; c_mi.a = invert_highlight ? max(0.0, c_mi.a - light_opacity) : min(1.0, c_mi.a + light_opacity); }
		if (highlight_background) { c_bg.rgb += added_light; c_bg.a = invert_highlight ? max(0.0, c_bg.a - light_opacity) : min(1.0, c_bg.a + light_opacity); }
	}
	
	if (use_checkerboard && mod(floor(m_uv).x + floor(m_uv).y, 2.0) > 0.5) c_bg = checker_color;
	if (use_hatching) {
		float hatch = fract((v_local_pos.x + v_local_pos.y) / hatching_size);
		if (hatch < hatching_thickness * (fwidth(v_local_pos.x + v_local_pos.y) / hatching_size)) {
			c_bg = mix(c_bg, hatching_color, hatching_color.a);
		}
	}
	
	vec3 current_bg = use_microgrid ? mix(c_bg.rgb, c_mi.rgb, micro_mask * c_mi.a) : c_bg.rgb;
	vec3 sub_rgb = mix(current_bg, c_sub.rgb, sub_mask * c_sub.a);
	vec3 final_rgb = mix(sub_rgb, c_main.rgb, main_mask * c_main.a);
	
	vec4 final_color = vec4(final_rgb, c_bg.a);
	if (invert_colors) final_color.rgb = vec3(1.0) - final_color.rgb;
	
	COLOR = final_color;
}