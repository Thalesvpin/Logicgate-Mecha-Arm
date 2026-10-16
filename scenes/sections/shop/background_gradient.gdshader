shader_type canvas_item;

// Core texture configuration
uniform sampler2D gradient_texture : source_color, filter_linear, repeat_disable;

// Gradient Type: 0 = Horizontal, 1 = Vertical, 2 = Radial, 3 = Reflected
uniform int gradient_type : hint_range(0, 3) = 1;
uniform float gradient_rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform float gradient_scale : hint_range(0.1, 10.0) = 1.0;

// Smoothing: 0.0 = Hard Edge (Toon) / 0.5 = Linear / 1.0 = Smoothstep
uniform float gradient_smoothing : hint_range(0.0, 1.0) = 0.5;
uniform bool repeat_gradient = false;

// --- GROUP: MANUAL OFFSET ---
uniform float gradient_offset : hint_range(-2.0, 2.0) = 0.0;

// --- GROUP: PULSATION ANIMATION ---
uniform bool enable_pulsation = false;
uniform float animation_speed : hint_range(0.0, 10.0) = 1.0;
uniform float pulse_min_offset : hint_range(-2.0, 2.0) = -0.5;
uniform float pulse_max_offset : hint_range(-2.0, 2.0) = 0.5;

void fragment() {
	// 1. Optimized UV Rotation around center (0.5, 0.5)
	float rad = radians(gradient_rotation_degrees);
	float s = sin(rad);
	float c = cos(rad);
	vec2 uv_centered = UV - 0.5;
	vec2 rotated_uv = vec2(
		uv_centered.x * c - uv_centered.y * s,
		uv_centered.x * s + uv_centered.y * c
	) + 0.5;

	// 2. Shape Selection (Uniform Branching)
	float factor = 0.0;
	float inv_scale = 1.0 / max(gradient_scale, 0.001); // Prevent division by zero
	
	if (gradient_type == 0) {
		factor = rotated_uv.x * inv_scale;
	} else if (gradient_type == 1) {
		factor = rotated_uv.y * inv_scale;
	} else if (gradient_type == 2) {
		factor = distance(rotated_uv, vec2(0.5)) * inv_scale * 2.0;
	} else {
		factor = abs(rotated_uv.y - 0.5) * inv_scale * 2.0;
	}

	// 3. Offset & Pulsation Calculation
	float current_offset = gradient_offset;
	if (enable_pulsation) {
		float pulse_wave = sin(TIME * animation_speed) * 0.5 + 0.5;
		current_offset = mix(pulse_min_offset, pulse_max_offset, pulse_wave);
	}
	factor -= current_offset;

	// 4. Edge Behavior (Clamp or Loop)
	if (repeat_gradient) {
		factor = fract(factor);
		if (factor < 0.0) factor += 1.0;
	} else {
		factor = clamp(factor, 0.0, 1.0);
	}

	// 5. Blended Smoothing Curves
	float smooth_factor = factor * factor * (3.0 - 2.0 * factor);
	if (gradient_smoothing < 0.5) {
		factor = mix(step(0.5, factor), factor, gradient_smoothing * 2.0);
	} else {
		factor = mix(factor, smooth_factor, (gradient_smoothing - 0.5) * 2.0);
	}

	// Output final pixel color from the 1D Texture
	COLOR = texture(gradient_texture, vec2(factor, 0.0));
}
