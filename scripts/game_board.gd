extends Control
@onready var execution_panel: PanelContainer = $GameplayElements/VSplit/baixo/BotHSplit/HBoxContainer/ExecutionPanel
@onready var circuit_editor: PanelContainer = $GameplayElements/VSplit/baixo/BotHSplit/HBoxContainer/CircuitEditor
@onready var combat_screen: PanelContainer = $GameplayElements/VSplit/cima/TopHSplit/CombatScreen
@onready var tech_mods_container: PanelContainer = $GameplayElements/VSplit/cima/TopHSplit/TechModsContainer
@onready var bio_hacks_container: PanelContainer = $GameplayElements/VSplit/cima/TopHSplit/BioHacksContainer
@onready var shop: PanelContainer = $GameplayElements/VSplit/baixo/Shop
@onready var stats_viewport: PanelContainer = $GameplayElements/VSplit/cima/TopHSplit/StatsViewport
@onready var gates_selector: PanelContainer = $GameplayElements/VSplit/baixo/BotHSplit/GatesSelector
@onready var gameplay_elements: VBoxContainer = $GameplayElements
@onready var game_over_screen: PanelContainer = $GameOverScreen
@onready var v_split: VSplitContainer = $GameplayElements/VSplit
@onready var top_h_split: HSplitContainer = $GameplayElements/VSplit/cima/TopHSplit
@onready var bot_h_split: HSplitContainer = $GameplayElements/VSplit/baixo/BotHSplit
@onready var pause_menu: PanelContainer = $PauseMenu

@export var shop_tween_speed: float = 0.8
var last_top_h_split_offsets: PackedInt32Array
var last_v_split_offsets: PackedInt32Array
const SHOP_H_OFFSETS: Array[int] = [350, -350]
const SHOP_V_OFFSETS: Array[int] = [0]

func _ready() -> void:
	Global.game_board = self
	if Global._seed == 0:
		Global.set_new_seed()
	randomize_binaries()
	connect_signals()
	EventBus.turn_started.emit('player')

func pause_game(value: bool) -> void:
	if value:
		v_split.process_mode = Node.PROCESS_MODE_DISABLED
		pause_menu.open()
	else:
		v_split.process_mode = Node.PROCESS_MODE_INHERIT

func randomize_binaries(arg = null) -> void:
	if !(arg is String):
		return
	execution_panel.generate_execution_sequence()
	circuit_editor.generate_action_list()

func connect_signals() -> void:
	#combat_screen.connect_action_signals(circuit_editor)
	EventBus.battle_ended.connect(battle_ended)
	EventBus.turn_started.connect(randomize_binaries)

func is_last_firewall() -> bool:
	return false

func is_boss() -> bool:
	return false

func battle_ended(is_victory: bool) -> void:
	if is_victory:
		if is_boss():
			if is_last_firewall():
				game_over(is_victory)
				return
			else:
				open_boss_reward()
		open_shop()
	else:
		game_over(is_victory)

func open_boss_reward() -> void:
	pass

func tween_handler(object: Object, property: NodePath, final_val: Variant, duration: float, _ease: Tween.EaseType, parallel: bool = true , callback = null):
	var tween = create_tween()
	tween.set_parallel(parallel)
	tween.set_ease(_ease)
	#tween.tween_property(object, property, final_val, duration)
	tween.tween_method(
		func(value: int):
			object.split_offsets = [roundi(value), object.split_offsets[1]],
		float(object.split_offsets[0]),
		200.0,
		0.5
	)
	if callback != null:
		tween.tween_callback(callback)

func tween_offsets(split: SplitContainer, target: PackedInt32Array, tween: Tween) -> void:
	var from = split.split_offsets.duplicate()
	var to = fit(target, from.size())
	tween.tween_method(
		func(t: float):
			var arr := PackedInt32Array()
			for i in from.size():
				arr.append(roundi(lerpf(from[i], to[i], t)))
			split.split_offsets = arr,
		0.0, 1.0, shop_tween_speed
	)

func fit(arr: PackedInt32Array, size: int) -> PackedInt32Array:
	var out := arr.duplicate()
	while out.size() < size:
		out.append(out[out.size() - 1] if out.size() > 0 else 0)
	out.resize(size)
	return out

func open_shop() -> void:
	last_top_h_split_offsets = top_h_split.split_offsets.duplicate()
	last_v_split_offsets = v_split.split_offsets.duplicate()
	v_split.dragging_enabled = false
	top_h_split.dragging_enabled = false
	
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween_offsets(top_h_split, SHOP_H_OFFSETS, tween)
	tween_offsets(v_split, SHOP_V_OFFSETS, tween)
	tween.set_parallel(false)
	tween.tween_callback(
		func():
			close_battle()
			stats_viewport.show()
			EventBus.open_shop.emit()
			stats_viewport.glow()
			await get_tree().process_frame
			top_h_split.split_offsets = fit(SHOP_H_OFFSETS, top_h_split.split_offsets.size())
			v_split.split_offsets = fit(SHOP_V_OFFSETS, v_split.split_offsets.size())
	)

func close_shop() -> void:
	shop.hide()
	stats_viewport.hide()
	open_battle()
	EventBus.close_shop.emit()
	
	await get_tree().process_frame
	top_h_split.split_offsets = fit(SHOP_H_OFFSETS, top_h_split.split_offsets.size())
	v_split.split_offsets = fit(SHOP_V_OFFSETS, v_split.split_offsets.size())
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	
	tween_offsets(top_h_split, last_top_h_split_offsets, tween)
	tween_offsets(v_split, last_v_split_offsets, tween)
	
	tween.set_parallel(false)
	tween.tween_callback(
		func():
			v_split.dragging_enabled = true
			top_h_split.dragging_enabled = true
	)

func open_battle() -> void:
	bot_h_split.show()
	combat_screen.show()
	gates_selector.show()
	circuit_editor.show()
	execution_panel.show()

func close_battle() -> void:
	combat_screen.hide()
	bot_h_split.hide()
	#gates_selector.hide()
	#circuit_editor.hide()
	#execution_panel.hide()

func game_over(is_victory: bool) -> void:
	gameplay_elements.hide()
	game_over_screen.is_victory = is_victory
	game_over_screen.show()

const TECHMOD_TEST = preload("uid://3gmr422layic")
const TECHMOD = preload("uid://dm2y0nuwvhshu")
const BIOHACK = preload("uid://c24lfewwtgac8")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Y"):
		print('\n\n\n\n\n\n\n')
		pass
	if event.is_action_pressed("H"):
		var ef = ChargeHeavyAttackEffect.new()
		ef.amount = 1
		ef.apply()
	if event.is_action_pressed("B"):
		Global.implant_manager.add_bio_hack(BIOHACK)
	if event.is_action_pressed("T"):
		Global.implant_manager.add_tech_mod(TECHMOD)
	if event.is_action_pressed("S"):
		EventBus.battle_ended.emit(true)
	if event.is_action_pressed("L"):
		v_split.dragging_enabled = !v_split.dragging_enabled
		top_h_split.dragging_enabled = !top_h_split.dragging_enabled
	if event.is_action_pressed("M"):
		var ef = AddMoneyEffect.new()
		ef.amount = 123456789
		ef.apply()
	if event.is_action_pressed("N"):
		var ef = AddMoneyEffect.new()
		ef.amount = -10000
		ef.apply()
	
	
	
	
	if event.is_action_pressed("0"):
		print('\n\nplayer_stats: ')
		for key in Global.run_stats.player_stats:
			print(Stats.List.keys()[key], ': ', Global.run_stats.player_stats[key])
		print('\nextra: ')
		for key in Global.implant_manager.extra_stats:
			print(Stats.List.keys()[key], ': ', Global.implant_manager.extra_stats[key])
	
	
	if event.is_action_pressed("7"):
		Global.implant_manager.add_bio_hack(BH_64)
	if event.is_action_pressed("9"):
		EventBus.enemy_defeated.emit()
	
	if event.is_action_pressed("4"):
		Global.implant_manager.add_bio_hack(TM_4)
	if event.is_action_pressed("6"):
		print('gates na sand: ', Global.circuit_editor.sandbox.total_gates_count)
	
	if event.is_action_pressed("1"):
		Global.implant_manager.add_bio_hack(TM_5)
	if event.is_action_pressed("3"):
		EventBus.self_damage.emit()
	
#region BH
const BH_33 = preload("uid://c8awfm3qb8gn5")
const BH_64 = preload("uid://bn6hkf2voidul")
#endregion
#region TM
const TM_1 = preload("uid://cswsbscbyhuh2")
const TM_3 = preload("uid://dpmi2d3veyfmy")


const TM_4 = preload("uid://cgber4cjaov0l")
const TM_5 = preload("uid://dy6wk36d0rq4p")
const TM_6 = preload("uid://dm2y0nuwvhshu")
const TM_7 = preload("uid://dytisrt6s3x5i")
const TM_9 = preload("uid://qx3dyanxqyph")
const TM_16 = preload("uid://c608np6txr6nk")
const TM_19 = preload("uid://yj4flmkwtf36")
const TM_26 = preload("uid://bvp8tt51e64tv")
const TM_27 = preload("uid://dllp5egfwepqa")
const TM_38 = preload("uid://dp7y2gimfbfvn")
const TM_40 = preload("uid://dao2lw7lx1c71")
const TM_42 = preload("uid://dcq1ffaygsw7b")
const TM_43 = preload("uid://fu1vmnu5rnwk")
const TM_46 = preload("uid://c1cgiwl6m8ila")
const TM_47 = preload("uid://difi687gv8edj")
#endregion
