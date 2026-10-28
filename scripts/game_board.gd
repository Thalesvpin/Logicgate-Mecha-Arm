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

func randomize_binaries() -> void:
	execution_panel.generate_execution_sequence()
	circuit_editor.generate_action_list()

func connect_signals() -> void:
	combat_screen.connect_action_signals(circuit_editor)
	EventBus.battle_ended.connect(battle_ended)

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

func open_shop() -> void:
	last_top_h_split_offsets = top_h_split.split_offsets
	last_v_split_offsets = v_split.split_offsets
	v_split.dragging_enabled = false
	top_h_split.dragging_enabled = false
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	
	var h_from := float(top_h_split.split_offsets[0])
	tween.tween_method(
		func(v: float):
			top_h_split.split_offsets = [roundi(v), -roundi(v)],
		h_from, 350.0, shop_tween_speed
	)
	var v_from := float(v_split.split_offsets[0])
	tween.tween_method(
		func(v: float):
			v_split.split_offsets = [roundi(v)],
		v_from, 0.0, shop_tween_speed
	)
	
	tween.set_parallel(false)
	tween.tween_callback(_open_shop)

##fazer essa parte no shop apos emitir um singal
func _open_shop():
	EventBus.open_shop.emit()
	print('emitiu')
	#shop.show()
	#shop.open()
	stats_viewport.show()
	stats_viewport.glow()
	close_battle()

func close_shop() -> void:
	shop.hide()
	stats_viewport.hide()

func open_battle() -> void:
	v_split.dragging_enabled = false
	top_h_split.dragging_enabled = false
	#tween_handler(top_h_split, "split_offsets", last_top_h_split_offsets, shop_tween_speed, Tween.EASE_OUT, true, _open_battle)
	#tween_handler(v_split, "split_offsets", last_v_split_offsets, shop_tween_speed, Tween.EASE_OUT, true, _open_battle)
	v_split.split_offsets = last_v_split_offsets
	top_h_split.split_offsets = last_top_h_split_offsets

#func _open_battle() -> void:
	combat_screen.show()
	gates_selector.show()
	circuit_editor.show()
	execution_panel.show()
	close_shop()
	v_split.dragging_enabled = true
	top_h_split.dragging_enabled = true

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
const TM_6 = preload("uid://dm2y0nuwvhshu")
const BH_1 = preload("uid://cdfw1je21a364")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Y"):# Y
		pass
	if event.is_action_pressed("U"):# U
		pass
	if event.is_action_pressed("B"):# B
		Global.implant_manager.add_bio_hack(BH_1)
	if event.is_action_pressed("T"):# T
		Global.implant_manager.add_tech_mod(TM_6)
	if event.is_action_pressed("S"):
		EventBus.battle_ended.emit(true)
	if event.is_action_pressed("L"):
		v_split.dragging_enabled = !v_split.dragging_enabled
		top_h_split.dragging_enabled = !top_h_split.dragging_enabled
	if event.is_action_pressed("M"):
		var ef = AddMoneyEffect.new()
		ef.amount = 1000
		ef.apply()
	
