shader_type canvas_item;

uniform bool effect_enabled = true;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

group_uniforms Color_Remap_1;
// Default: Hex #000000 (Black)
uniform vec4 source_color_1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
// Default: Hex #34f3ff (Cyan)
uniform vec4 target_color_1 : source_color = vec4(0.20392, 0.95294, 1.0, 1.0);

group_uniforms Color_Remap_2;
// Default: Hex #34f3ff (Cyan)
uniform vec4 source_color_2 : source_color = vec4(0.20392, 0.95294, 1.0, 1.0);
// Default: Hex #000000 (Black)
uniform vec4 target_color_2 : source_color = vec4(0.0, 0.0, 0.0, 1.0);

group_uniforms Settings;
// Default: 0.5 tolerance
uniform float tolerance : hint_range(0.0, 1.0) = 0.5;

group_uniforms; 

void fragment() {
    vec4 screen_color = texture(screen_texture, SCREEN_UV);
    
    // Branchless optimization: calculate masks based on color distance and tolerance
    float match_1 = step(distance(screen_color.rgb, source_color_1.rgb), tolerance);
    float match_2 = step(distance(screen_color.rgb, source_color_2.rgb), tolerance);
    
    // Mix colors cleanly based on mathematical masks instead of nested 'if' blocks
    vec3 mixed_rgb = mix(screen_color.rgb, target_color_1.rgb, match_1);
    mixed_rgb = mix(mixed_rgb, target_color_2.rgb, match_2 * (1.0 - match_1)); // Priority to mask 1
    
    // Master toggle blend
    COLOR = vec4(mix(screen_color.rgb, mixed_rgb, float(effect_enabled)), screen_color.a);
}