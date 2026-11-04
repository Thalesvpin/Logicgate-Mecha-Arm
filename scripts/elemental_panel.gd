extends CollapsablePanel

@onready var crt_1: ColorRect = $PanelContainer/Control/PanelContainer2/Mask/CRT1

func ready() -> void:
	is_elemental = true
	shader = crt_1.material as ShaderMaterial
	shader.set_shader_parameter('power_state', 0.0)

func turn_on() -> void:
	if turn_on_delay > 0:
		await get_tree().create_timer(turn_on_delay).timeout
	var tween = create_tween()
	tween.tween_property(shader, 'shader_parameter/power_state', 1.0, turn_on_speed)
