extends PanelContainer
@onready var gate_layer: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/GateLayer
@onready var wire_layer: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/WireLayer
@onready var drag_layer: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/DragLayer
@onready var circuit_camera: Camera2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/CircuitCamera
@onready var sandbox: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox

var all_gate_inputs: Array
var all_gate_outputs: Array
var hovered_pin: Area2D

func _ready() -> void:
	Global.circuit_editor = self

func add_input(node):
	all_gate_inputs.append(node)
	#node.

func remove_input(node):
	all_gate_inputs = all_gate_inputs.filter(func(e): return e != node)

func remove_output(node):
	all_gate_outputs = all_gate_outputs.filter(func(e): return e != node)
