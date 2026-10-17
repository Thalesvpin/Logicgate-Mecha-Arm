shader_type canvas_item;

uniform bool effect_enabled = true;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

group_uniforms Color_Remap;
// Default: Hex #34f3ff (Cyan)
uniform vec4 source_color_val : source_color = vec4(0.20392, 0.95294, 1.0, 1.0);
// The gradient texture to remap the color into
uniform sampler2D gradient_texture : filter_linear;

group_uniforms Gradient_Settings;
// 0: Linear, 1: Radial, 2: Reflected
uniform int gradient_type : hint_enum("Linear", "Radial", "Reflected") = 0;
// Controls how stretched/repeated the gradient is
uniform float gradient_scale : hint_range(0.1, 10.0) = 1.0;
// Shifts the gradient position
uniform float gradient_offset : hint_range(0.0, 1.0) = 0.0;

group_uniforms Offset_Animation;
uniform bool animate_offset = false;
// Curve texture to animate the offset over time
uniform sampler2D offset_curve : hint_default_white, filter_linear;
uniform float offset_animation_speed : hint_range(0.0, 10.0) = 1.0;

group_uniforms Opacity_Animation;
uniform bool animate_opacity = false;
// Curve texture to animate opacity over time
uniform sampler2D opacity_curve : hint_default_white, filter_linear;
uniform float opacity_animation_speed : hint_range(0.0, 10.0) = 1.0;
// Base multiplier for overall opacity
uniform float opacity : hint_range(0.0, 1.0) = 1.0;

group_uniforms Settings;
// Default: 0.5 tolerance
uniform float tolerance : hint_range(0.0, 1.0) = 0.5;
// Controls edge softness/smoothing for the color match transition
uniform float gradient_smoothing : hint_range(0.0, 0.5) = 0.05;

group_uniforms; 

void fragment() {
    vec4 screen_color = texture(screen_texture, SCREEN_UV);
    vec3 final_rgb = screen_color.rgb;
    
    // Only process if the effect is globally enabled
    if (effect_enabled) {
        // Smooth transition mask using distance, tolerance, and smoothing
        float match = 1.0 - smoothstep(tolerance - gradient_smoothing, tolerance + gradient_smoothing, distance(screen_color.rgb, source_color_val.rgb));
        
        // Only calculate gradients and curves if the pixel actually matches the target color
        if (match > 0.0) {
            float raw_grad_uv = 0.0;
            if (gradient_type == 0) {
                // Linear (Horizontal flow)
                raw_grad_uv = SCREEN_UV.x;
            } else if (gradient_type == 1) {
                // Radial (Circular flow from screen center)
                raw_grad_uv = distance(SCREEN_UV, vec2(0.5)) * 1.41421356; // Precalculated sqrt(2)
            } else {
                // Reflected (Mirrored horizontal flow)
                raw_grad_uv = abs(fract(SCREEN_UV.x) - 0.5) * 2.0;
            }
            
            // Calculate dynamic offset if enabled
            float current_offset = gradient_offset;
            if (animate_offset) {
                current_offset += texture(offset_curve, vec2(fract(TIME * offset_animation_speed), 0.5)).r;
            }
            
            // Apply scale and offset
            float grad_uv = fract(raw_grad_uv * gradient_scale + current_offset);
            vec3 gradient_color = texture(gradient_texture, vec2(grad_uv, 0.5)).rgb;
            
            // Calculate dynamic opacity if enabled
            float final_opacity = opacity;
            if (animate_opacity) {
                final_opacity *= texture(opacity_curve, vec2(fract(TIME * opacity_animation_speed), 0.5)).r;
            }
            
            // Blend gradient color
            final_rgb = mix(screen_color.rgb, gradient_color, match * final_opacity);
        }
    }
    
    COLOR = vec4(final_rgb, screen_color.a);
}