extends Area2D
@onready var and_gate: Area2D = $"../../.."

var sprite: Sprite2D
var collision: CollisionShape2D

var type: String = "input"
var connected_gate: Area2D = null
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

func _on_mouse_entered() -> void:
	sprite.scale = Vector2(0.02,0.02)

func _on_mouse_exited() -> void:
	sprite.scale = Vector2(0.007,0.007)
