shader_type canvas_item;

// License: CC0
// Author: Ultipuk, https://ultipuk.xyz (Modified for screen-reading, direction, & low-end optimization)

#define USE_TERMINATOR
//#define USE_UV_BASED_TERMINATOR_SIZE

/** Screen texture capturing everything rendered behind this node. */
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

/** Use this from the editor for interpolation. */
uniform float progress : hint_range(0.0, 1.0) = 0.5;
/** Fill direction in degrees (0 = Right, 90 = Up, 180 = Left, 270 = Down). */
uniform float direction_angle : hint_range(0.0, 360.0, 1.0) = 90.0;
/** Make it more gray/grey with lower value. */
uniform float saturation : hint_range(0.0, 4.0) = 0.2;
/** Make it darker with lower value. */
uniform float lightness : hint_range(0.0, 4.0) = 0.4;

#ifdef USE_TERMINATOR
group_uniforms terminator;
/** Terminator color. */
uniform vec4 terminator_color : source_color = vec4(1.0);
	#ifdef USE_UV_BASED_TERMINATOR_SIZE
	/** Terminator size in UV coords. */
	uniform float terminator_size : hint_range(0.0, 1.0) = 0.012;
	#else
	/** Terminator size in pixels. */
	uniform float terminator_size_px : hint_range(0.0, 64.0, 1.0) = 4.0;
	#endif
#endif

// Flat varyings pass constants from vertex() to fragment() without interpolation overhead
varying flat vec2 fill_axis;
varying flat float cutoff_offset;

#ifdef USE_TERMINATOR
	#ifdef USE_UV_BASED_TERMINATOR_SIZE
	varying flat float half_terminator_size;
	#else
	varying flat vec2 scaled_dir_sq;
	#endif
#endif

void vertex() {
	// Precompute direction trigonometry and bounding-box normalization once per vertex
	// instead of once per pixel
	float rad = radians(direction_angle);
	vec2 dir = vec2(cos(rad), -sin(rad));
	float inv_span = 1.0 / (abs(dir.x) + abs(dir.y));

	fill_axis = dir * inv_span;
	cutoff_offset = 0.5 - 0.5 * (fill_axis.x + fill_axis.y);

	#ifdef USE_TERMINATOR
		#ifdef USE_UV_BASED_TERMINATOR_SIZE
		half_terminator_size = terminator_size * 0.5;
		#else
		scaled_dir_sq = fill_axis * fill_axis;
		#endif
	#endif
}

void fragment() {
	mediump float mask_alpha = COLOR.a;

	// Skip screen texture fetch and color math completely for transparent sprite pixels
	if (mask_alpha <= 0.0001) {
		COLOR = vec4(0.0);
	} else {
		mediump vec4 color = texture(screen_texture, SCREEN_UV);

		// Single dot-add (FMA) equivalent to: (dot(UV - 0.5, dir) / span) + 0.5
		float cutoff = dot(UV, fill_axis) + cutoff_offset;

		#ifdef USE_TERMINATOR
			#ifndef USE_UV_BASED_TERMINATOR_SIZE
			float px_scale = sqrt(dot(scaled_dir_sq, SCREEN_PIXEL_SIZE * SCREEN_PIXEL_SIZE));
			float half_terminator_size = (terminator_size_px * 0.5) * px_scale;
			#endif

		if (abs(progress - cutoff) < half_terminator_size) {
			color = terminator_color;
		} else
		#endif
		if (progress < cutoff) {
			// CRT-style luminance ITU-R BT.601[cite: 1]
			mediump float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
			color.rgb = mix(vec3(luminance), color.rgb, saturation) * lightness;
		}

		color.a *= mask_alpha;
		COLOR = color;
	}
}