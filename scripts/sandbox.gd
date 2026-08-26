extends Node2D

@onready var gate_layer: Node2D = $GateLayer
@onready var wire_layer: Node2D = $WireLayer
@onready var drag_layer: Node2D = $DragLayer
@onready var collision_shape_2d: CollisionShape2D = $CircuitCamera/Area2D/CollisionShape2D
@onready var game_output_manager: VBoxContainer = $GameOutputManager
@onready var game_input_manager: VBoxContainer = $GameInputManager

var line := preload("uid://64o4r0ww4ft2")
var was_pressed: bool = false
var cursor_in: bool = false
var point_a: Node2D = null
var point_b: Node2D = null
var _line: Node2D = null

func _ready() -> void:
	var inputs = game_input_manager.get_children()
	var outputs = game_output_manager.get_children()
	for input in inputs:
		if input.get_class() == "Control":
			input.get_child(1).new_wire.connect(trace_line)
	for output in outputs:
		if output.get_class() == "Control":
			output.get_child(0).new_wire.connect(trace_line)

func trace_line(point):
	if !_line:
		_line = line.instantiate()
		wire_layer.add_child(_line)
	
	#Point A
	if point.type.to_lower() == "output":
		_line.set_point_a(point)
	#Point B
	if point.type.to_lower() == "input":
		_line.set_point_b(point)
	
	if point.owner is Area2D:
		point.owner.connected_wires.append(_line)
	else:
		point.connected_wires.append(_line)
	
	_line = null

func _on_area_2d_mouse_entered() -> void:
	cursor_in = true

func _on_area_2d_mouse_exited() -> void:
	cursor_in = false

func _on_gate_layer_child_entered_tree(node: Node) -> void:
	node.last_position = node.global_position
	for connector in node.connectors:
		connector.new_wire.connect(trace_line)
