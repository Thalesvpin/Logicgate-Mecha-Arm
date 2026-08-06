extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

signal clicked(pin)

var type: String = "output"
var connected_gate
var connected_wires: Array

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			clicked.emit(self)

func _on_mouse_entered() -> void:
	sprite.scale = Vector2(0.02,0.02)

func _on_mouse_exited() -> void:
	sprite.scale = Vector2(0.007,0.007)
