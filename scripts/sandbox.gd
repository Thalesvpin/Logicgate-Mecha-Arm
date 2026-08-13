extends Node2D

@onready var gate_layer: Node2D = $GateLayer
@onready var wire_layer: Node2D = $WireLayer
@onready var drag_layer: Node2D = $DragLayer
@onready var collision_shape_2d: CollisionShape2D = $CircuitCamera/Area2D/CollisionShape2D
@onready var game_output_manager: VBoxContainer = $GameOutputManager
@onready var game_input_manager: VBoxContainer = $GameInputManager

var line := preload("res://scenes/cable.tscn")

var was_pressed := false
var cursor_in: bool = false

func _ready() -> void:
	var inputs = game_input_manager.get_children()
	var outputs = game_output_manager.get_children()
	for input in inputs:
		input.get_child(1).clicked.connect(trace_line)
	for output in outputs:
		output.get_child(0).clicked.connect(trace_line)

func _process(delta):
	update_drag()
	if DragManager.dragging:
		var is_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		if was_pressed && !is_pressed:
			end_drag()
		was_pressed = is_pressed

func update_drag():
	if !DragManager.dragging:
		return
	
	DragManager.original_node.global_position = get_global_mouse_position()

func end_drag():
	DragManager.drop(cursor_in)

var point_a = null
var point_b = null
func trace_line(point):
	print(point.name, point.owner)
	if point.type.to_lower() == "output":
		point_a = point
	if point.type.to_lower() == "input":
		point_b = point
	
	if point_a && point_b:
		if point_a.owner != point_b.owner:
			var _line = line.instantiate()
			_line.point_a = point_a
			_line.point_b = point_b
			wire_layer.add_child(_line)
			point_b.connected_gate = point_a
			if point_a.owner is Area2D:
				point_a.owner.connected_wires.append(_line)
			else:
				point_a.connected_wires.append(_line)
			if point_b.owner is Area2D:
				point_b.owner.connected_wires.append(_line)
			else:
				point_b.connected_wires.append(_line)
			
			point_a = null
			point_b = null
		else:
			if point == point_a:
				point_a = null
			if point == point_b:
				point_b = null

func _on_area_2d_mouse_entered() -> void:
	cursor_in = true

func _on_area_2d_mouse_exited() -> void:
	cursor_in = false

func _on_gate_layer_child_entered_tree(node: Node) -> void:
	node.last_position = node.global_position
	for connector in node.connectors:
		connector.clicked.connect(trace_line)
