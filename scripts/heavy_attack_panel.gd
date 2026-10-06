extends CollapsablePanel

@onready var charges_bar: ColorRect = $PanelContainer/Control/ChargesBar

var _material

func _ready() -> void:
	is_charged = true
	Global.heavy_attack_panel = self
	_material = charges_bar.material as ShaderMaterial

func fill_charges() -> void:
	_material.set_shader_parameter("pour_fill_amount", 1)

func add_charges(amount: float = 1) -> void:
	#var current = _material.get_shader_parameter("pour_fill_amount")
	#var _max = _material.get_shader_parameter("segment_count")
	var current = Global.run_stats.player_stats[Stats.List.HEAVY_ATTACK_ACTIVE_CHARGES]
	var _max = Global.run_stats.player_stats[Stats.List.HEAVY_ATTACK_MAX_CHARGES]
	print('cur: ', current, 'max: ', _max)
	current += amount/_max
	_material.set_shader_parameter("pour_fill_amount", current)

func deplete_charges() -> void:
	_material.set_shader_parameter("pour_fill_amount", 0.0)
