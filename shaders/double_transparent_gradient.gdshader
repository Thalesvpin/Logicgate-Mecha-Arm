shader_type canvas_item;

render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float fade_start : hint_range(0.0, 0.5) = 0.05;
uniform float fade_end : hint_range(0.0, 0.5) = 0.30;

void fragment() {
    vec4 color = textureLod(screen_texture, SCREEN_UV, 0.0);

    if (color.a > 0.0001) {
        color.rgb /= color.a;
    }

    float left = smoothstep(
        fade_start,
        fade_end,
        UV.x
    );

    float right = smoothstep(
        fade_start,
        fade_end,
        1.0 - UV.x
    );

    color.a *= left * right;

    COLOR = color;
}