shader_type canvas_item;

// License: CC0
// Author: Ultipuk, https://ultipuk.xyz
// Link: https://godotshaders.com/shader/desaturated-and-darkened-texture-progress

#define USE_TERMINATOR
 //#define USE_UV_BASED_TERMINATOR_SIZE
 //#define USE_SAMPLER_TEXTURE

/** Use this from the editor for interpolation. */
uniform float progress: hint_range(0.0, 1.0) = 0.5;
/** Make it more gray/grey with lower value. */
uniform float saturation: hint_range(0.0, 4.0) = 0.2;
/** Make it darker with lower value. */
uniform float lightness: hint_range(0.0, 4.0) = 0.4;

#ifdef USE_SAMPLER_TEXTURE
/** Just a texture. */
uniform sampler2D albedo_texture : source_color;
#endif

#ifdef USE_TERMINATOR
group_uniforms terminator;
/** Terminator color. */
uniform vec4 terminator_color: source_color = vec4(1.0);
	#ifdef USE_UV_BASED_TERMINATOR_SIZE
	/** Terminator size in UV coords. */
	uniform float terminator_size: hint_range(0.0, 1.0) = 0.012;
	#else
	/** Terminator size in pixels. */
	uniform float terminator_size_px: hint_range(0.0, 64.0, 1.0) = 4.0;
	#endif
#endif

void fragment() {
	#ifdef USE_SAMPLER_TEXTURE
	vec4 color = texture(albedo_texture, UV);
	#else
	vec4 color = COLOR;
	#endif
	
	float cutoff = 1.0 - UV.y;
	
	#ifdef USE_TERMINATOR
	
	float terminator_size_uv;
	
	#ifdef USE_UV_BASED_TERMINATOR_SIZE
		terminator_size_uv = terminator_size;
	#else
		terminator_size_uv = terminator_size_px * SCREEN_PIXEL_SIZE.y;
	#endif
	
	if (abs(progress - cutoff) < terminator_size_uv * 0.5) {
		color = terminator_color;
	} else
	#endif
	if (progress < cutoff) {
		// CRT-style luminance ITU-R BT.601 (https://www.itu.int/rec/R-REC-BT.601-7-201103-I)
		float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
		
		color.rgb = vec3(luminance) * (1.0 - saturation) + color.rgb * saturation;
		color.rgb *= lightness;
	}
	
	COLOR = color;
}