shader_type canvas_item;

group_uniforms Outline;
uniform bool enable_outline = true;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 32.0, 0.5) = 2.0;
uniform float outline_softness : hint_range(0.0, 0.5, 0.01) = 0.0;
uniform float alpha_threshold : hint_range(0.01, 0.99, 0.01) = 0.15;
uniform bool include_diagonals = true;
uniform bool round_corners = true;
uniform float pulse_speed : hint_range(0.0, 15.0, 0.1) = 0.0;
uniform float pulse_min_alpha : hint_range(0.0, 1.0, 0.05) = 0.35;

group_uniforms Color_Overlay;
uniform bool enable_overlay = false;
uniform vec4 overlay_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float overlay_strength : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform int overlay_mode : hint_enum("Flat Mix", "Multiply Tint", "Additive Glow") = 0;
group_uniforms;

varying vec4 v_modulate;

void vertex() {
	v_modulate = COLOR;
}

vec3 apply_overlay(vec3 base_rgb) {
	float amount = overlay_strength * overlay_color.a;
	if (overlay_mode == 1) {
		return mix(base_rgb, base_rgb * overlay_color.rgb, amount);
	} else if (overlay_mode == 2) {
		return base_rgb + (overlay_color.rgb * amount);
	}
	return mix(base_rgb, overlay_color.rgb, amount);
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 subject = tex;

	// Apply color overlay across all non-transparent pixels, including anti-aliased edges
	if (enable_overlay && overlay_strength > 0.0 && tex.a > 0.0) {
		subject.rgb = apply_overlay(tex.rgb);
	}

	// Fast path: skip neighbor lookups when outline is off, zero-width, or pixel is fully opaque
	if (!enable_outline || outline_width <= 0.0 || tex.a >= 0.999) {
		COLOR = subject * v_modulate;
	} else {
		vec2 px = TEXTURE_PIXEL_SIZE * outline_width;

		// Outer cardinal samples
		float max_a = texture(TEXTURE, clamp(UV + vec2(px.x, 0.0), vec2(0.0), vec2(1.0))).a;
		max_a = max(max_a, texture(TEXTURE, clamp(UV + vec2(-px.x, 0.0), vec2(0.0), vec2(1.0))).a);
		max_a = max(max_a, texture(TEXTURE, clamp(UV + vec2(0.0, px.y), vec2(0.0), vec2(1.0))).a);
		max_a = max(max_a, texture(TEXTURE, clamp(UV + vec2(0.0, -px.y), vec2(0.0), vec2(1.0))).a);

		// Inner half-step cardinal samples when outline_width > 1.5 to prevent hollow gaps
		if (outline_width > 1.5) {
			vec2 half_px = px * 0.5;
			max_a = max(max_a, texture(TEXTURE, clamp(UV + vec2(half_px.x, 0.0), vec2(0.0), vec2(1.0))).a);
			max_a = max(max_a, texture(TEXTURE, clamp(UV + vec2(-half_px.x, 0.0), vec2(0.0), vec2(1.0))).a);
			max_a = max(max_a, texture(TEXTURE, clamp(UV + vec2(0.0, half_px.y), vec2(0.0), vec2(1.0))).a);
			max_a = max(max_a, texture(TEXTURE, clamp(UV + vec2(0.0, -half_px.y), vec2(0.0), vec2(1.0))).a);
		}

		// Optional diagonal samples
		if (include_diagonals) {
			vec2 diag = round_corners ? px * 0.70710678 : px;
			max_a = max(max_a, texture(TEXTURE, clamp(UV + vec2(diag.x, diag.y), vec2(0.0), vec2(1.0))).a);
			max_a = max(max_a, texture(TEXTURE, clamp(UV + vec2(-diag.x, diag.y), vec2(0.0), vec2(1.0))).a);
			max_a = max(max_a, texture(TEXTURE, clamp(UV + vec2(diag.x, -diag.y), vec2(0.0), vec2(1.0))).a);
			max_a = max(max_a, texture(TEXTURE, clamp(UV + vec2(-diag.x, -diag.y), vec2(0.0), vec2(1.0))).a);
		}

		float outline_mask = (outline_softness <= 0.001)
			? step(alpha_threshold, max_a)
			: smoothstep(
				max(0.0, alpha_threshold - outline_softness),
				min(1.0, alpha_threshold + outline_softness),
				max_a
			);

		float pulse = (pulse_speed > 0.0)
			? mix(pulse_min_alpha, 1.0, 0.5 + 0.5 * sin(TIME * pulse_speed))
			: 1.0;

		vec4 outline = vec4(outline_color.rgb, outline_color.a * outline_mask * pulse);

		// True straight-alpha "subject over outline" compositing (no edge darkening or gap)
		float out_a = subject.a + outline.a * (1.0 - subject.a);
		vec3 out_rgb = (out_a > 0.0)
			? (subject.rgb * subject.a + outline.rgb * outline.a * (1.0 - subject.a)) / out_a
			: vec3(0.0);

		COLOR = vec4(out_rgb, out_a) * v_modulate;
	}
}