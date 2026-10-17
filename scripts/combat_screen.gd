extends Control

@onready var panel_container: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer
@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer
@onready var left_enemy_container: VBoxContainer = $SubViewportContainer/SubViewport/PanelContainer/TopPanels/EnemiesSection/LeftEnemyContainer
@onready var center_enemy_container: VBoxContainer = $SubViewportContainer/SubViewport/PanelContainer/TopPanels/EnemiesSection/CenterEnemyContainer
@onready var right_enemy_container: VBoxContainer = $SubViewportContainer/SubViewport/PanelContainer/TopPanels/EnemiesSection/RightEnemyContainer
@onready var enemy_name_bar: Control = $SubViewportContainer/SubViewport/PanelContainer/MidBottomPanels/EnemyNameBar
@onready var red_dmg_flash: PanelContainer = $RedDmgFlash
var left_enemy_status_bar: PanelContainer
var center_enemy_status_bar: PanelContainer
var right_enemy_status_bar: PanelContainer
var block_movement: bool = false

const ENEMY = preload("uid://6y2k6pdfjohj")
const ENEMY_STATUS_BAR = preload("uid://bbk5wegsq6ymc")

func _ready() -> void:
	Global.combat_screen = self
	add_enemies()
	connect_signals()
	sub_viewport_container.custom_minimum_size = panel_container.get_combined_minimum_size()

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("test"):
		#swap_enemy(_enemy, Position.LEFT)

#func take_damage(value: float, enemy, mitigate: bool = true):
	#var _min = 0
	#if mitigate && enemy['shield'] > 0:
		#_min = min(enemy['shield'], 0)
		#enemy['shield'] -= _min
		#enemy['bar'].subtract_from_shield(_min)
	#
	#_min = min(enemy['health'], value)
	#enemy['health'] -= _min
	#enemy['bar'].subtract_from_health(_min)

func center_enemy0(enemy):
	if block_movement:
		return
	block_movement = true
	print('center_enemy() COMBAT_SCREEN')
	var selected_status_bar = enemy.status_bar
	var current_position = enemy._position
	var front_enemy = get_enemy(EnemyPosition.Position.CENTER)
	var pos_front = front_enemy.global_position
	var pos_2 = enemy.global_position
	
	center_enemy_container.remove_child(front_enemy)
	
	match current_position:
		EnemyPosition.Position.CENTER:
			return
		EnemyPosition.Position.LEFT:
			left_enemy_container.remove_child(enemy)
			left_enemy_container.add_child(front_enemy)
			front_enemy.status_bar = left_enemy_status_bar
			left_enemy_status_bar.enemy = front_enemy
			print(left_enemy_status_bar)
			left_enemy_status_bar.enemy_swap()
		EnemyPosition.Position.RIGHT:
			right_enemy_container.remove_child(enemy)
			right_enemy_container.add_child(front_enemy)
			front_enemy.status_bar = right_enemy_status_bar
			right_enemy_status_bar.enemy = front_enemy
			right_enemy_status_bar.enemy_swap()
	
	await get_tree().process_frame
	await get_tree().process_frame
	print('foda-se:\nclick: ', enemy.global_position,'\nfront: ',front_enemy.global_position)
	enemy.move(pos_2)
	front_enemy.move(pos_front)
	
	front_enemy._position = current_position
	center_enemy_container.add_child(enemy)
	enemy.status_bar = center_enemy_status_bar
	enemy._position = EnemyPosition.Position.CENTER
	center_enemy_status_bar.enemy = enemy
	center_enemy_status_bar.enemy_swap()
	enemy_name_bar.set_display_name(enemy.enemy_name)
	#current_position.update()
func center_enemy(enemy):
	if block_movement or enemy._position == EnemyPosition.Position.CENTER:
		return
	block_movement = true

	var front_enemy = get_enemy(EnemyPosition.Position.CENTER)
	var old_pos_enemy = enemy.global_position
	var old_pos_front = front_enemy.global_position
	var old_slot = enemy._position
	var side_container = left_enemy_container if old_slot == EnemyPosition.Position.LEFT else right_enemy_container
	var side_status_bar = left_enemy_status_bar if old_slot == EnemyPosition.Position.LEFT else right_enemy_status_bar

	# reparent tudo de uma vez
	center_enemy_container.remove_child(front_enemy)
	side_container.remove_child(enemy)
	side_container.add_child(front_enemy)
	center_enemy_container.add_child(enemy)

	front_enemy.status_bar = side_status_bar
	side_status_bar.enemy = front_enemy
	side_status_bar.enemy_swap()
	front_enemy._position = old_slot

	enemy.status_bar = center_enemy_status_bar
	center_enemy_status_bar.enemy = enemy
	center_enemy_status_bar.enemy_swap()
	enemy._position = EnemyPosition.Position.CENTER
	enemy_name_bar.set_display_name(enemy.enemy_name)

	#await get_tree().process_frame
	#await get_tree().process_frame

	print('novo enemy: ', enemy.global_position, ' | novo front: ', front_enemy.global_position)

	enemy.move(old_pos_enemy)
	front_enemy.move(old_pos_front)
#region PLAYER ACTIONS
func player_attack() -> void:
	pass

func player_heavy_attack() -> void:
	pass

func player_charge_heavy_attack() -> void:
	pass

func player_self_damage() -> void:
	pass

func player_heal_health() -> void:
	pass

func player_repair_shield() -> void:
	pass
#endregion

#region ENEMY ACTIONS
func enemy_attack() -> void:
	pass

func enemy_heal_health() -> void:
	pass

func enemy_heal_shield() -> void:
	pass
#endregion

func connect_action_signals(circuit_editor: PanelContainer) -> void:
	EventBus.attacked.connect(player_attack)
	EventBus.heavy_attack_used.connect(player_heavy_attack)
	EventBus.charged_heavy_attack.connect(player_charge_heavy_attack)
	EventBus.self_damage.connect(player_self_damage)
	EventBus.healed.connect(player_heal_health)
	EventBus.repaired_shield.connect(player_repair_shield)

func connect_signals() -> void:
	#EventBus.enemy_defeated.connect(enemy_defeated)
	EventBus.damage_taken.connect(flash_red)
	pass

func enemy_defeated(enemy) -> void:
	print('enemy_defeated COMBAT_SCREEN')
	var left_enemy = get_enemy(EnemyPosition.Position.LEFT)
	var right_enemy = get_enemy(EnemyPosition.Position.RIGHT)
	
	if enemies_alive() == 0:
		EventBus.battle_ended.emit(true)
		return
	
	if enemy == left_enemy || enemy == right_enemy:
		return
	
	if enemy._position == EnemyPosition.Position.CENTER:
		if left_enemy.stats[Stats.List.CURRENT_HEALTH] > right_enemy.stats[Stats.List.CURRENT_HEALTH]:
			center_enemy(left_enemy)
		else:
			center_enemy(right_enemy)

func enemies_alive() -> int:
	var count = 0
	if get_enemy(EnemyPosition.Position.LEFT).stats[Stats.List.CURRENT_HEALTH] > 0:
		count += 1
	if get_enemy(EnemyPosition.Position.RIGHT).stats[Stats.List.CURRENT_HEALTH] > 0:
		count += 1
	if get_enemy(EnemyPosition.Position.CENTER).stats[Stats.List.CURRENT_HEALTH] > 0:
		count += 1
	return count

func get_enemy(_position: EnemyPosition.Position):
	var slot
	match _position:
		EnemyPosition.Position.LEFT:
			slot = left_enemy_container
		EnemyPosition.Position.RIGHT:
			slot = right_enemy_container
		EnemyPosition.Position.CENTER:
			slot = center_enemy_container
	
	for child in slot.get_children():
		if child.get_class() == "Control":
			return child

const ENEMY_TEST_3 = preload("uid://bmtwmbaxdbb5b")
const ENEMY_TEST_2 = preload("uid://btj4l0vpo5o5m")
const ENEMY_TEST = preload("uid://dh7i6kpmm4sh8")

func add_enemies() -> void:
	var enemy_l = ENEMY.instantiate()
	var enemy_r = ENEMY.instantiate()
	var enemy_c = ENEMY.instantiate()
	var bar_l = ENEMY_STATUS_BAR.instantiate()
	var bar_r = ENEMY_STATUS_BAR.instantiate()
	var bar_c = ENEMY_STATUS_BAR.instantiate()
	
	Global.turn_manager.add_to_sequence(enemy_c)
	Global.turn_manager.add_to_sequence(enemy_l)
	Global.turn_manager.add_to_sequence(enemy_r)
	enemy_l.config = ENEMY_TEST
	enemy_r.config = ENEMY_TEST_3
	enemy_c.config = ENEMY_TEST_2
	
	enemy_l._position = EnemyPosition.Position.LEFT
	enemy_r._position = EnemyPosition.Position.RIGHT
	enemy_c._position = EnemyPosition.Position.CENTER
	enemy_l.status_bar = bar_l
	enemy_r.status_bar = bar_r
	enemy_c.status_bar = bar_c
	bar_l.enemy = enemy_l
	bar_r.enemy = enemy_r
	bar_c.enemy = enemy_c
	
	left_enemy_container.add_child(bar_l)
	right_enemy_container.add_child(bar_r)
	center_enemy_container.add_child(bar_c)
	left_enemy_container.add_child(enemy_l)
	right_enemy_container.add_child(enemy_r)
	center_enemy_container.add_child(enemy_c)
	
	bar_l.update()
	bar_r.update()
	bar_c.update()
	
	left_enemy_status_bar = bar_l
	right_enemy_status_bar = bar_r
	center_enemy_status_bar = bar_c

func flash_red(arg) -> void:
	var style: StyleBoxFlat = red_dmg_flash.get_theme_stylebox("panel").duplicate()
	red_dmg_flash.add_theme_stylebox_override("panel", style)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(style, 'border_color', Color(0.72, 0.0, 0.0, 0.53), 0.1)
	tween.chain().tween_property(style, 'border_color', Color(0.72, 0.0, 0.0, 0.0), 0.1)
