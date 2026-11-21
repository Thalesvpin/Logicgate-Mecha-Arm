extends PanelContainer
@onready var gate_layer: Node2D = $SubViewportContainer/SubViewport/Sandbox/GateLayer
@onready var wire_layer: Node2D = $SubViewportContainer/SubViewport/Sandbox/WireLayer
@onready var drag_layer: Node2D = $SubViewportContainer/SubViewport/Sandbox/DragLayer
@onready var circuit_camera: Camera2D = $SubViewportContainer/SubViewport/Sandbox/CircuitCamera
@onready var sandbox: Node2D = $SubViewportContainer/SubViewport/Sandbox
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer
@onready var block_input: PanelContainer = $SubViewportContainer/SubViewport/Control2/BlockInput
@onready var heal_container: Control = $Control/Heal
@onready var shield_regen: Control = $Control/ShieldRegen
@onready var attack_container: Control = $Control/Attack
@onready var self_damage_container: Control = $Control/SelfDamage
@onready var actions_panel_sandbox: PanelContainer = $Control/ActionsPanelSandbox
@onready var wall: Control = $Wall

var execution_sequence: Array
var all_gate_inputs: Array
var all_gate_outputs: Array
var hovered_pin: Area2D
var block_up = false

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
	EventBus.turn_started.connect(turn_start)
	EventBus.turn_ended.connect(block_sandbox)
	EventBus.submit_circuit.connect(lock_sandbox)
	wall.show()
	wall.offset_transform_position.y = wall.get_viewport_rect().size.y

#func _process(delta: float) -> void:
	#if block_up:
		#wall_old.offset_transform_position.y = -circuit_camera.collision_shape_2d.shape.size.y

func generate_action_list() -> void:
	var list: Array[int] = Global.unique_random_list(action_list.size(), 4)
	var aux = 0
	for action in action_list:
		action_list[action] = list[aux]
		print(str(action)+' - '+str(list[aux]))
		aux += 1
	
	actions_panel_sandbox.set_attack(Global.dec_to_bin(action_list[CombatActions.List.ATTACK]))
	actions_panel_sandbox.set_shield_regen(Global.dec_to_bin(action_list[CombatActions.List.REPAIR_SHIELD]))
	actions_panel_sandbox.set_self_damage(Global.dec_to_bin(action_list[CombatActions.List.SELF_DAMAGE]))
	actions_panel_sandbox.set_heal(Global.dec_to_bin(action_list[CombatActions.List.HEAL]))
	actions_panel_sandbox.set_heavy_attack(Global.dec_to_bin(action_list[CombatActions.List.HEAVY_ATTACK]))
	actions_panel_sandbox.set_charge_heavy_attack(Global.dec_to_bin(action_list[CombatActions.List.CHARGE_HEAVY_ATTACK]))

func compare_output(output: int) -> void:
	for action in action_list:
		if output == action_list[action]:
			print('compare_output: ',CombatActions.list_signals[action])
			CombatActions.list_signals[action].emit()

func add_input(node):
	all_gate_inputs.append(node)
	#node.

func remove_input(node):
	all_gate_inputs = all_gate_inputs.filter(func(e): return e != node)

func remove_output(node):
	all_gate_outputs = all_gate_outputs.filter(func(e): return e != node)

func turn_start(who: String) -> void:
	if who == 'player':
		unblock_sandbox()
		unlock_sandbox()

func block_sandbox(who: String) -> void:
	if who != 'player':
		return
	var tween = create_tween().set_parallel(false)
	tween.tween_property(wall, 'offset_transform_position:y', 0.0, 0.8)
	tween.tween_callback(func(): block_up = true)

func unblock_sandbox() -> void:
	var tween = create_tween().set_parallel(false)
	tween.tween_property(wall, 'offset_transform_position:y', wall.get_viewport_rect().size.y, 0.8)
	block_up = false

func lock_sandbox() -> void:
	block_input.show()

func unlock_sandbox() -> void:
	block_input.hide()

func lock_zoom(value: bool) -> void:
	circuit_camera.lock_zoom = value
