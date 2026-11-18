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
var shader: ShaderMaterial
@export var turn_on_speed: float = 0.4
@export var turn_off_speed: float = 0.4
@export var turn_on_delay: float = 0.3

func _ready() -> void:
	ready()
	expanded_position = panel_container.position
	if is_charged:
		collapsed_position = Vector2(panel_container.size.x - charged_offset, panel_container.position.y)
	elif is_elemental:
		collapsed_position = Vector2(-panel_container.size.x + elemental_offset, panel_container.position.y)
	
	panel_container.position = collapsed_position
	gui_input.connect(_on_gui_input)
	
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			var tween = create_tween().set_parallel()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			if is_collapsed:
				is_collapsed = false
				turn_off(true)
				tween.tween_property(panel_container, "position", expanded_position, duration)
				tween.tween_callback(turn_on)
			else:
				is_collapsed = true
				tween.tween_property(panel_container, "position", collapsed_position, duration)
				turn_off()

func _input(event: InputEvent) -> void:
	input()
	if event.is_action_pressed("K"):
		var tween = create_tween().set_parallel()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		if is_collapsed:
			is_collapsed = false
			turn_off(true)
			tween.tween_property(panel_container, "position", expanded_position, duration)
			tween.tween_callback(turn_on)
		else:
			is_collapsed = true
			tween.tween_property(panel_container, "position", collapsed_position, duration)
			turn_off()

func ready() -> void:
	pass

func input() -> void:
	pass

func turn_on():
	pass

func turn_off(fast: bool = false) -> void:
	if fast:
		shader.set_shader_parameter('power_state', 0.0)
	else:
		var tween = create_tween()
		tween.tween_property(shader, 'shader_parameter/power_state', 0.0, turn_off_speed)
