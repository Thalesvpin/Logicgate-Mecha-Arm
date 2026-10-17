extends CollapsablePanel

@onready var charges_bar: ColorRect = $PanelContainer/Control/ChargesBar

var _material: ShaderMaterial

func _ready() -> void:
	is_charged = true
	Global.heavy_attack_panel = self
	_material = charges_bar.material as ShaderMaterial

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
	print('current: ', current)
	print('_max: ', _max)
	print('percent: ', percent)

func deplete_charges() -> void:
	_material.set_shader_parameter("pour_fill_amount", 0.0)
