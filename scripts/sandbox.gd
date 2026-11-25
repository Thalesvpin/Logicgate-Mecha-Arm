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
var and_count: int = 0
var or_count: int = 0
var not_count: int = 0
var nand_count: int = 0
var nor_count: int = 0
var xor_count: int = 0
var xnor_count: int = 0
var total_gates_count: int = 0

func _ready() -> void:
	var inputs = game_input_manager.get_children()
	var outputs = game_output_manager.get_children()
	for input in inputs:
		if input.get_class() == "Control":
			if input.name == 'Spacer':
				continue
			input.get_child(1).new_wire.connect(trace_line)
	for output in outputs:
		if output.get_class() == "Control":
			if output.name == 'Spacer':
				continue
			output.get_child(0).new_wire.connect(trace_line)
	EventBus.gate_added_to_sandbox.connect(gate_added)
	EventBus.gate_removed_from_sandbox.connect(gate_removed)

func gate_added(type: Gates.Type) -> void:
	match type:
		Gates.Type.AND:
			and_count += 1
		Gates.Type.OR:
			or_count += 1
		Gates.Type.NOT:
			not_count += 1
		Gates.Type.NAND:
			nand_count += 1
		Gates.Type.NOR:
			nor_count += 1
		Gates.Type.XOR:
			xor_count += 1
		Gates.Type.XNOR:
			xnor_count += 1
	total_gates_count += 1

func gate_removed(type: Gates.Type) -> void:
	match type:
		Gates.Type.AND:
			and_count -= 1
		Gates.Type.OR:
			or_count -= 1
		Gates.Type.NOT:
			not_count -= 1
		Gates.Type.NAND:
			nand_count -= 1
		Gates.Type.NOR:
			nor_count -= 1
		Gates.Type.XOR:
			xor_count -= 1
		Gates.Type.XNOR:
			xnor_count -= 1
	total_gates_count -= 1

#runs only on first clicked terminal of each line
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
	
	if point.owner is Area2D: #gate output
		point.owner.connected_wires.append(_line)
	elif point.owner is Control && point.owner.get_parent().owner is Area2D: #gate input
		point.owner.get_parent().owner.connected_wires.append(_line)
	else:
		point.connected_wires.append(_line) #input and output bars
	
	_line = null

func check_submit_requirements() -> bool:
	if !game_input_manager.check_submit_requirements():
		#print('missing requirement at InputBar')
		return false
	if !game_output_manager.check_submit_requirements():
		#print('missing requirement at OutputBar')
		return false
	
	for gate in gate_layer.get_children():
		if !gate.check_submit_requirements():
			#print('missing requirement at gate ', Gates.Type.keys()[gate.type],'  node: ', gate)
			return false
	return true

func _on_area_2d_mouse_entered() -> void:
	cursor_in = true

func _on_area_2d_mouse_exited() -> void:
	cursor_in = false

func _on_gate_layer_child_entered_tree(node: Node) -> void:
	node.last_position = node.global_position
	for connector in node.connectors:
		connector.new_wire.connect(trace_line)
