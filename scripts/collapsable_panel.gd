extends Control
class_name CollapsablePanel

@onready var panel_container: PanelContainer = $PanelContainer

var expanded_position: Vector2
var collapsed_position: Vector2
@export var duration: float = 0.8
var is_collapsed: bool = true
var is_elemental: bool = false
var is_charged: bool = false
@export var charged_offset: int = 125
@export var elemental_offset: int = 125

func _ready() -> void:
	ready()
	expanded_position = panel_container.position
	if is_charged:
		collapsed_position = Vector2(panel_container.size.x - charged_offset, panel_container.position.y)
	elif is_elemental:
		collapsed_position = Vector2(-panel_container.size.x + elemental_offset, panel_container.position.y)
	
	panel_container.position = collapsed_position

func _input(event: InputEvent) -> void:
	input()
	if event.is_action_pressed("K"):
		var tween = create_tween().set_parallel(false)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		if is_collapsed:
			is_collapsed = false
			tween.tween_property(panel_container, "position", expanded_position, duration)
		else:
			is_collapsed = true
			tween.tween_property(panel_container, "position", collapsed_position, duration)

func ready() -> void:
	pass

func input() -> void:
	pass
