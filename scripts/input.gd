extends Area2D
@onready var and_gate: Area2D = $"../../.."

var sprite: Sprite2D
var collision: CollisionShape2D

var type: String = "input"
var connected_gate: Area2D = null
var is_active: bool = false
#var input_gate: Node2D

signal clicked(pin)

func _ready() -> void:
	for child in get_children():
		if child is Sprite2D:
			sprite = child
		if child is CollisionShape2D:
			collision = child

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			clicked.emit(self)

func _process(delta: float) -> void:
	check_input_value()

func check_input_value() -> void:
	if connected_gate:
		set_active(connected_gate.is_active)

func set_active(value: bool) -> void:
	is_active = value

func _on_mouse_entered() -> void:
	sprite.scale = Vector2(0.02,0.02)
	Global.circuit_editor.hovered_pin = self

func _on_mouse_exited() -> void:
	print('input exit')
	sprite.scale = Vector2(0.007,0.007)
	if Global.circuit_editor.hovered_pin == self:
		Global.circuit_editor.hovered_pin = null
