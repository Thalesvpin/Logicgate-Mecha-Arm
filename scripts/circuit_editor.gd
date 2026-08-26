extends PanelContainer
@onready var gate_layer: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/GateLayer
@onready var wire_layer: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/WireLayer
@onready var drag_layer: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/DragLayer
@onready var circuit_camera: Camera2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/CircuitCamera
@onready var sandbox: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox

@onready var attack: Control = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/CircuitCamera/Attack
@onready var shield_regen: Control = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/CircuitCamera/ShieldRegen
@onready var self_damage: Control = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/CircuitCamera/SelfDamage

var all_gate_inputs: Array
var all_gate_outputs: Array
var hovered_pin: Area2D

func _ready() -> void:
	Global.circuit_editor = self

func generate_action_list() -> void:
	var list: Array[int] = Global.unique_random_binary_list(3, 4)
	attack.get_child(1).text = '%04d' % list[0]
	shield_regen.get_child(1).text = '%04d' % list[1]
	self_damage.get_child(1).text = '%04d' % list[2]

func add_input(node):
	all_gate_inputs.append(node)
	#node.

func remove_input(node):
	all_gate_inputs = all_gate_inputs.filter(func(e): return e != node)

func remove_output(node):
	all_gate_outputs = all_gate_outputs.filter(func(e): return e != node)
