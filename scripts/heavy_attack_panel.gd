extends CollapsablePanel

@onready var charges_bar: ColorRect = $PanelContainer/Control/ChargesBar

var _material

func ready() -> void:
	is_charged = true
	Global.heavy_attack_panel = self
	_material = charges_bar.material as ShaderMaterial

func fill_charges() -> void:
	_material.set_shader_parameter("pour_fill_amount", 1)

func add_charges(amount: int) -> void:
	var current = _material.get_shader_parameter("pour_fill_amount")
	var max = _material.get_shader_parameter("segment_count")
	current += amount/max
	_material.set_shader_parameter("pour_fill_amount", current)

func deplete_charges() -> void:
	_material.set_shader_parameter("pour_fill_amount", 0.0)
