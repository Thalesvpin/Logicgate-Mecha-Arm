extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

signal clicked(pin)

var type: String = "input"
var connected_gate
var connected_wires: Array
var is_active: bool = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		get_viewport().set_input_as_handled()
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			clicked.emit(self)

func _process(delta: float) -> void:
	if connected_gate:
		owner.output = connected_gate.is_active

func _on_mouse_entered() -> void:
	sprite.scale = Vector2(0.02,0.02)
	owner.owner.prevent_click(true)

func _on_mouse_exited() -> void:
	sprite.scale = Vector2(0.007,0.007)
	owner.owner.prevent_click(false)
