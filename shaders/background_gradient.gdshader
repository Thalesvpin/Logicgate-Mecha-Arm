shader_type canvas_item;

// =============================================================================
// MAIN GROUP 1: Base Gradient
// =============================================================================
group_uniforms Base_Gradient;
uniform sampler2D gradient_texture : source_color, filter_linear, repeat_disable;
uniform int gradient_type : hint_range(0, 3) = 1;
uniform float gradient_rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform float gradient_scale : hint_range(0.1, 10.0) = 1.0;
uniform float gradient_smoothing : hint_range(0.0, 5.0) = 0.5;
uniform float gradient_offset : hint_range(-2.0, 2.0) = 0.0;
uniform bool repeat_gradient = false;

// SUBGROUP: Base Pulsation Settings
group_uniforms Base_Gradient.Pulsation_Effects;
uniform bool enable_pulsation = false;
uniform float animation_speed : hint_range(0.0, 10.0) = 1.0;
uniform float pulse_min_offset : hint_range(-2.0, 2.0) = -0.5;
uniform float pulse_max_offset : hint_range(-2.0, 2.0) = 0.5;

// =============================================================================
// MAIN GROUP 2: Overlay Settings
// =============================================================================
group_uniforms Overlay_Settings;
uniform bool enable_overlay = false;
uniform vec4 overlay_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform int overlay_type : hint_range(0, 3) = 2;
uniform float overlay_rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform float overlay_scale : hint_range(0.1, 10.0) = 1.0;
uniform float overlay_smoothing : hint_range(0.0, 5.0) = 0.5;
uniform float overlay_offset : hint_range(-2.0, 2.0) = 0.0;
uniform bool overlay_invert_fade = false;

// SUBGROUP: Overlay Pulsation Settings
group_uniforms Overlay_Settings.Pulsation_Effects;
uniform bool overlay_enable_pulsation = false;
uniform float overlay_animation_speed : hint_range(0.0, 10.0) = 1.0;
uniform float overlay_pulse_min_offset : hint_range(-2.0, 2.0) = -0.5;
uniform float overlay_pulse_max_offset : hint_range(-2.0, 2.0) = 0.5;

// --- HELPER FUNCTIONS ---
group_uniforms;

// Optimized UV rotation using a pre-calculated radians value passed directly
vec2 rotate_uv_coords(vec2 uv_centered, float rad) {
	float s = sin(rad);
	float c = cos(rad);
	return vec2(
		uv_centered.x * c - uv_centered.y * s,
		uv_centered.x * s + uv_centered.y * c
	) + 0.5;
}

float calculate_smoothed_factor(float factor, float smoothing_value) {
	if (smoothing_value < 0.5) {
		return mix(step(0.5, factor), factor, smoothing_value * 2.0);
	} else if (smoothing_value <= 1.0) {
		return mix(factor, factor * factor * (3.0 - 2.0 * factor), (smoothing_value - 0.5) * 2.0);
	} else {
		return mix(pow(factor, smoothing_value), 1.0 - pow(1.0 - factor, smoothing_value), factor);
	}
}

void fragment() {
	// Pre-center UV once to reuse across both passes
	vec2 uv_centered = UV - 0.5;

	// ------------------------------------------
	// PASS 1: Base Multi-Color Gradient
	// ------------------------------------------
	vec2 base_uv = rotate_uv_coords(uv_centered, radians(gradient_rotation_degrees));
	float base_factor = 0.0;
	float inv_base_scale = 1.0 / max(gradient_scale, 0.001);
	
	if (gradient_type == 0) base_factor = base_uv.x * inv_base_scale;
	else if (gradient_type == 1) base_factor = base_uv.y * inv_base_scale;
	else if (gradient_type == 2) base_factor = distance(base_uv, vec2(0.5)) * inv_base_scale * 2.0;
	else base_factor = abs(base_uv.y - 0.5) * inv_base_scale * 2.0;

	float current_base_offset = gradient_offset;
	if (enable_pulsation) {
		current_base_offset = mix(pulse_min_offset, pulse_max_offset, sin(TIME * animation_speed) * 0.5 + 0.5);
	}
	base_factor -= current_base_offset;

	if (repeat_gradient) {
		base_factor = fract(base_factor);
		if (base_factor < 0.0) base_factor += 1.0;
	} else {
		base_factor = clamp(base_factor, 0.0, 1.0);
	}

	base_factor = calculate_smoothed_factor(base_factor, gradient_smoothing);
	vec4 final_color = texture(gradient_texture, vec2(base_factor, 0.0));

	// ------------------------------------------
	// PASS 2: Experimental Fade Overlay
	// ------------------------------------------
	if (enable_overlay) {
		vec2 overlay_uv = rotate_uv_coords(uv_centered, radians(overlay_rotation_degrees));
		float overlay_factor = 0.0;
		float inv_overlay_scale = 1.0 / max(overlay_scale, 0.001);
		
		if (overlay_type == 0) overlay_factor = overlay_uv.x * inv_overlay_scale;
		else if (overlay_type == 1) overlay_factor = overlay_uv.y * inv_overlay_scale;
		else if (overlay_type == 2) overlay_factor = distance(overlay_uv, vec2(0.5)) * inv_overlay_scale * 2.0;
		else overlay_factor = abs(overlay_uv.y - 0.5) * inv_overlay_scale * 2.0;

		float current_overlay_offset = overlay_offset;
		if (overlay_enable_pulsation) {
			current_overlay_offset = mix(overlay_pulse_min_offset, overlay_pulse_max_offset, sin(TIME * overlay_animation_speed) * 0.5 + 0.5);
		}
		overlay_factor -= current_overlay_offset;

		overlay_factor = clamp(overlay_factor, 0.0, 1.0);
		overlay_factor = calculate_smoothed_factor(overlay_factor, overlay_smoothing);

		float fade = mix(1.0 - overlay_factor, overlay_factor, float(overlay_invert_fade));
		vec4 overlay_layer = vec4(overlay_color.rgb, overlay_color.a * fade);
		
		final_color.rgb = mix(final_color.rgb, overlay_layer.rgb, overlay_layer.a);
	}

	COLOR = final_color;
}
