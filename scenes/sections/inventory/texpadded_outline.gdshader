shader_type canvas_item;

group_uniforms Outline;
uniform bool enable_outline = true;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 32.0, 0.5) = 2.0;
uniform float outline_softness : hint_range(0.0, 0.5, 0.01) = 0.0;
uniform float alpha_threshold : hint_range(0.01, 0.99, 0.01) = 0.5;
uniform bool include_diagonals = true;
uniform bool round_corners = true;
uniform float pulse_speed : hint_range(0.0, 15.0, 0.1) = 0.0;
uniform float pulse_min_alpha : hint_range(0.0, 1.0, 0.05) = 0.35;

group_uniforms Color_Overlay;
uniform bool enable_overlay = false;
uniform vec4 overlay_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float overlay_strength : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform int overlay_mode : hint_enum("Flat Mix", "Multiply Tint", "Additive Glow") = 0;
uniform bool use_overlay_gradient = false;
uniform sampler2D overlay_gradient : source_color, hint_default_white;
uniform float gradient_angle : hint_range(0.0, 360.0, 1.0) = 90.0;
uniform bool gradient_use_2d_uv = false;
group_uniforms;

// 8 primary directions (cardinals + diagonals) checked first for fast early-out
const vec2 DIRS_8[8] = {
	vec2(1.0, 0.0),
	vec2(0.7071068, 0.7071068),
	vec2(0.0, 1.0),
	vec2(-0.7071068, 0.7071068),
	vec2(-1.0, 0.0),
	vec2(-0.7071068, -0.7071068),
	vec2(0.0, -1.0),
	vec2(0.7071068, -0.7071068)
};

// 8 mid-angle directions (22.5 deg offsets) for medium widths
const vec2 DIRS_MID_8[8] = {
	vec2(0.9238795, 0.3826834),
	vec2(0.3826834, 0.9238795),
	vec2(-0.3826834, 0.9238795),
	vec2(-0.9238795, 0.3826834),
	vec2(-0.9238795, -0.3826834),
	vec2(-0.3826834, -0.9238795),
	vec2(0.3826834, -0.9238795),
	vec2(0.9238795, -0.3826834)
};

// 16 fine-angle directions (11.25 deg offsets) used only when wide outlines miss the first 16 rays
const vec2 DIRS_FINE_16[16] = {
	vec2(0.9807853, 0.1950903),
	vec2(0.8314696, 0.5555702),
	vec2(0.5555702, 0.8314696),
	vec2(0.1950903, 0.9807853),
	vec2(-0.1950903, 0.9807853),
	vec2(-0.5555702, 0.8314696),
	vec2(-0.8314696, 0.5555702),
	vec2(-0.9807853, 0.1950903),
	vec2(-0.9807853, -0.1950903),
	vec2(-0.8314696, -0.5555702),
	vec2(-0.5555702, -0.8314696),
	vec2(-0.1950903, -0.9807853),
	vec2(0.1950903, -0.9807853),
	vec2(0.5555702, -0.8314696),
	vec2(0.8314696, -0.5555702),
	vec2(0.9807853, -0.1950903)
};

varying vec4 v_modulate;

void vertex() {
	v_modulate = COLOR;
}

vec3 apply_overlay(vec3 base_rgb, vec4 tint) {
	float amount = overlay_strength * tint.a;
	if (overlay_mode == 1) {
		return mix(base_rgb, base_rgb * tint.rgb, amount);
	} else if (overlay_mode == 2) {
		return base_rgb + (tint.rgb * amount);
	}
	return mix(base_rgb, tint.rgb, amount);
}

vec4 get_overlay_sample(vec2 uv) {
	if (!use_overlay_gradient) {
		return overlay_color;
	}
	if (gradient_use_2d_uv) {
		return texture(overlay_gradient, uv);
	}
	float rad = radians(gradient_angle);
	vec2 dir = vec2(cos(rad), sin(rad));
	float span = abs(dir.x) + abs(dir.y);
	float t = clamp(dot(uv - 0.5, dir) / span + 0.5, 0.0, 1.0);
	return texture(overlay_gradient, vec2(t, 0.5));
}

float sample_ring_max_alpha(sampler2D tex, vec2 uv, vec2 px, float radius_scale) {
	vec2 step_px = px * radius_scale;
	float effective_width = outline_width * radius_scale;
	float max_a = 0.0;

	if (!include_diagonals) {
		max_a = max(max_a, texture(tex, clamp(uv + vec2(step_px.x, 0.0), vec2(0.0), vec2(1.0))).a);
		max_a = max(max_a, texture(tex, clamp(uv + vec2(-step_px.x, 0.0), vec2(0.0), vec2(1.0))).a);
		max_a = max(max_a, texture(tex, clamp(uv + vec2(0.0, step_px.y), vec2(0.0), vec2(1.0))).a);
		max_a = max(max_a, texture(tex, clamp(uv + vec2(0.0, -step_px.y), vec2(0.0), vec2(1.0))).a);
		return max_a;
	}

	if (!round_corners) {
		// Pass 1: 4 cardinals + 4 exact (+/-1, +/-1) square corners
		for (int i = 0; i < 8; i++) {
			vec2 sq_dir = sign(DIRS_8[i]);
			max_a = max(max_a, texture(tex, clamp(uv + sq_dir * step_px, vec2(0.0), vec2(1.0))).a);
			if (max_a >= alpha_threshold) return max_a;
		}
		// Pass 2: 8 edge midpoints only when wider than 2.5px
		if (effective_width > 2.5) {
			for (int i = 0; i < 8; i++) {
				vec2 d = DIRS_MID_8[i];
				vec2 sq_dir = d / max(abs(d.x), abs(d.y));
				max_a = max(max_a, texture(tex, clamp(uv + sq_dir * step_px, vec2(0.0), vec2(1.0))).a);
				if (max_a >= alpha_threshold) return max_a;
			}
		}
		return max_a;
	}

	// Pass 1: 8 primary directions (exits immediately for most border pixels)
	for (int i = 0; i < 8; i++) {
		max_a = max(max_a, texture(tex, clamp(uv + DIRS_8[i] * step_px, vec2(0.0), vec2(1.0))).a);
		if (max_a >= alpha_threshold) return max_a;
	}

	// Pass 2: 8 mid-angle directions when wider than 2px
	if (effective_width > 2.0) {
		for (int i = 0; i < 8; i++) {
			max_a = max(max_a, texture(tex, clamp(uv + DIRS_MID_8[i] * step_px, vec2(0.0), vec2(1.0))).a);
			if (max_a >= alpha_threshold) return max_a;
		}
	}

	// Pass 3: 16 fine-angle directions only for wide outlines (> 6px) near sharp corners
	if (effective_width > 6.0) {
		for (int i = 0; i < 16; i++) {
			max_a = max(max_a, texture(tex, clamp(uv + DIRS_FINE_16[i] * step_px, vec2(0.0), vec2(1.0))).a);
			if (max_a >= alpha_threshold) return max_a;
		}
	}

	return max_a;
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 subject = tex;

	if (enable_overlay && overlay_strength > 0.0 && tex.a > 0.0) {
		vec4 active_overlay = get_overlay_sample(UV);
		subject.rgb = apply_overlay(tex.rgb, active_overlay);
	}

	// Fast path: skip all neighbor lookups for solid interior pixels
	if (!enable_outline || outline_width <= 0.0 || tex.a >= 0.999) {
		COLOR = subject * v_modulate;
	} else {
		vec2 px = TEXTURE_PIXEL_SIZE * outline_width;
		float outline_mask = 0.0;

		if (outline_softness <= 0.001) {
			float outer_a = sample_ring_max_alpha(TEXTURE, UV, px, 1.0);
			if (outer_a >= alpha_threshold) {
				outline_mask = 1.0;
			} else if (outline_width > 1.5 && outer_a > 0.001) {
				float mid_a = sample_ring_max_alpha(TEXTURE, UV, px, 0.5);
				outline_mask = step(alpha_threshold, mid_a);
			}
		} else {
			float exact_dist = 2.0;
			float prev_a = tex.a;
			float prev_frac = 0.0;

			for (int r = 1; r <= 4; r++) {
				float frac = float(r) * 0.25;
				float ring_a = sample_ring_max_alpha(TEXTURE, UV, px, frac);
				if (ring_a >= alpha_threshold) {
					float t = (alpha_threshold - prev_a) / max(ring_a - prev_a, 0.0001);
					exact_dist = mix(prev_frac, frac, clamp(t, 0.0, 1.0));
					break;
				}
				prev_a = ring_a;
				prev_frac = frac;
			}

			float feather = outline_softness * 2.0;
			float edge_start = min(max(0.0, 1.0 - feather), 0.999);
			outline_mask = 1.0 - smoothstep(edge_start, 1.0, exact_dist);
		}

		float pulse = (pulse_speed > 0.0)
			? mix(pulse_min_alpha, 1.0, 0.5 + 0.5 * sin(TIME * pulse_speed))
			: 1.0;

		vec4 outline = vec4(outline_color.rgb, outline_color.a * outline_mask * pulse);

		// True straight-alpha compositing (prevents any gap on anti-aliased borders)
		float out_a = subject.a + outline.a * (1.0 - subject.a);
		vec3 out_rgb = (out_a > 0.0)
			? (subject.rgb * subject.a + outline.rgb * outline.a * (1.0 - subject.a)) / out_a
			: vec3(0.0);

		COLOR = vec4(out_rgb, out_a) * v_modulate;
	}
}