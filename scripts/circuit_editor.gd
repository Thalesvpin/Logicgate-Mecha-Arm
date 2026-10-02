extends PanelContainer
@onready var gate_layer: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/GateLayer
@onready var wire_layer: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/WireLayer
@onready var drag_layer: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/DragLayer
@onready var circuit_camera: Camera2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/CircuitCamera
@onready var sandbox: Node2D = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox

@onready var attack_container: Control = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/CircuitCamera/Attack
@onready var shield_regen: Control = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/CircuitCamera/ShieldRegen
@onready var self_damage_container: Control = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/CircuitCamera/SelfDamage
@onready var heal_container: Control = $HBoxContainer/SubViewportContainer/SubViewport/Sandbox/CircuitCamera/Heal

var execution_sequence: Array
var all_gate_inputs: Array
var all_gate_outputs: Array
var hovered_pin: Area2D
var action_list: Dictionary[CombatActions.List, int]={
	CombatActions.List.ATTACK: 0,
	CombatActions.List.HEAVY_ATTACK: 0,
	CombatActions.List.CHARGE_HEAVY_ATTACK: 0,
	CombatActions.List.SELF_DAMAGE: 0,
	CombatActions.List.HEAL: 0,
	CombatActions.List.REPAIR_SHIELD: 0
}

func _ready() -> void:
	Global.circuit_editor = self

func generate_action_list() -> void:
	var list: Array[int] = Global.unique_random_list(action_list.size(), 4)
	var aux = 0
	for action in action_list:
		action_list[action] = list[aux]
		aux += 1
	
	attack_container.get_child(1).text = '%04d' % Global.dec_to_bin(action_list[CombatActions.List.ATTACK])
	shield_regen.get_child(1).text = '%04d' % Global.dec_to_bin(action_list[CombatActions.List.REPAIR_SHIELD])
	self_damage_container.get_child(1).text = '%04d' % Global.dec_to_bin(action_list[CombatActions.List.SELF_DAMAGE])
	heal_container.get_child(1).text = '%04d' % Global.dec_to_bin(action_list[CombatActions.List.HEAL])

func compare_output(output: int) -> void:
	for action in action_list:
		if output == action_list[action]:
			CombatActions.list_signals[action].emit()

func add_input(node):
	all_gate_inputs.append(node)
	#node.

func remove_input(node):
	all_gate_inputs = all_gate_inputs.filter(func(e): return e != node)

func remove_output(node):
	all_gate_outputs = all_gate_outputs.filter(func(e): return e != node)
