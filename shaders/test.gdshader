shader_type canvas_item;

uniform float fade_left_start = 0.0;
uniform float fade_left_end = 0.2;

uniform float fade_right_start = 0.8;
uniform float fade_right_end = 1.0;

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    float left_alpha = smoothstep(
        fade_left_start,
        fade_left_end,
        UV.x
    );

    float right_alpha = 1.0 - smoothstep(
        fade_right_start,
        fade_right_end,
        UV.x
    );

    color.a *= left_alpha * right_alpha;

    COLOR = color;
}