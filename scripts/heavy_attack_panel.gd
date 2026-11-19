extends CollapsablePanel

@onready var charges_bar: ColorRect = $PanelContainer/Control/ChargesBar
@onready var crt_1: ColorRect = $PanelContainer/Control/PanelContainer2/Mask/CRT1
@onready var percentage: RichTextLabel = $PanelContainer/Control/PanelContainer2/Mask/SubViewportContainer/SubViewport/ContextPanelBG/Control/Percentage

var _material: ShaderMaterial

func ready() -> void:
	is_charged = true
	Global.heavy_attack_panel = self
	_material = charges_bar.material as ShaderMaterial
	shader = crt_1.material as ShaderMaterial
	shader.set_shader_parameter('power_state', 0)
	update_contextual_panel()

func fill_charges() -> void:
	_material.set_shader_parameter("pour_fill_amount", 1)

func add_charges() -> void:
	#var current = _material.get_shader_parameter("pour_fill_amount")
	#var _max = _material.get_shader_parameter("segment_count")
	var current = Global.run_stats.player_stats[Stats.List.CURRENT_HEAVY_ATTACK_CHARGES]
	var _max = Global.run_stats.player_stats[Stats.List.MAX_HEAVY_ATTACK_CHARGES]
	#print('cur: ', current, 'max: ', _max)
	#current += amount/_max
	var percent = current/_max
	_material.set_shader_parameter("pour_fill_amount", percent)
	if percent < 0.76:
		_material.set_shader_parameter('filled_color', LivePalette.GLOBAL.HEAVYATTKYELLOW)
	else:
		_material.set_shader_parameter('filled_color', LivePalette.GLOBAL.HEAVYATTKGREEN)
	update_contextual_panel()

func update_contextual_panel() -> void:
	var curr = Global.run_stats.player_stats[Stats.List.CURRENT_HEAVY_ATTACK_CHARGES]
	var _max = Global.run_stats.player_stats[Stats.List.MAX_HEAVY_ATTACK_CHARGES]
	percentage.text = str(int(curr * (100 / _max))) + '%'

func deplete_charges() -> void:
	_material.set_shader_parameter("pour_fill_amount", 0.0)

func turn_on() -> void:
	if turn_on_delay > 0:
		await get_tree().create_timer(turn_on_delay).timeout
	var tween = create_tween()
	tween.tween_property(shader, 'shader_parameter/power_state', 1.0, turn_on_speed)
