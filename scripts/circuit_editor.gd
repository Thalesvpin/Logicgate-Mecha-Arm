extends PanelContainer
@onready var gate_layer: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/GateLayer
@onready var wire_layer: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/WireLayer
@onready var drag_layer: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/DragLayer
@onready var circuit_camera: Camera2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/CircuitCamera
@onready var sandbox: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox

@onready var attack_container: Control = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/CircuitCamera/Attack
@onready var shield_regen: Control = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/CircuitCamera/ShieldRegen
@onready var self_damage_container: Control = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/CircuitCamera/SelfDamage

var execution_sequence: Array
var all_gate_inputs: Array
var all_gate_outputs: Array
var hovered_pin: Area2D
var action_list: Dictionary={
	'attack': 0,
	'charged_attack': 0,
	'charge_charged_attack': 0,
	'self_damage': 0,
	'heal': 0,
	'repair_shield': 0
}
var action_signals: Dictionary = {
	'attack': EventBus.attacked,
	'charged_attack': EventBus.charged_attack_used,
	'charge_charged_attack': EventBus.charged_charged_attack,
	'self_damage': EventBus.self_damage,
	'heal': EventBus.healed,
	'repair_shield': EventBus.repaired_shield
}

func _ready() -> void:
	Global.circuit_editor = self

func generate_action_list() -> void:
	var list: Array[int] = Global.unique_random_list(action_list.size(), 4)
	var aux = 0
	for action in action_list:
		action_list[action] = list[aux]
		aux += 1
	
	attack_container.get_child(1).text = '%04d' % Global.dec_to_bin(action_list['attack'])
	shield_regen.get_child(1).text = '%04d' % Global.dec_to_bin(action_list['repair_shield'])
	self_damage_container.get_child(1).text = '%04d' % Global.dec_to_bin(action_list['self_damage'])

func compare_output(output: int) -> void:
	for action in action_list:
		if output == action_list[action]:
			action_signals[action].emit()

func add_input(node):
	all_gate_inputs.append(node)
	#node.

func remove_input(node):
	all_gate_inputs = all_gate_inputs.filter(func(e): return e != node)

func remove_output(node):
	all_gate_outputs = all_gate_outputs.filter(func(e): return e != node)
