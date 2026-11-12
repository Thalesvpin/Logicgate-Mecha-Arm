extends Control

@onready var panel_container: PanelContainer = $SubViewportContainer/SubViewport/PanelContainer
@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer
@onready var left_enemy_container: VBoxContainer = $SubViewportContainer/SubViewport/PanelContainer/TopPanels/EnemiesSection/LeftEnemyContainer
@onready var center_enemy_container: VBoxContainer = $SubViewportContainer/SubViewport/PanelContainer/TopPanels/EnemiesSection/CenterEnemyContainer
@onready var right_enemy_container: VBoxContainer = $SubViewportContainer/SubViewport/PanelContainer/TopPanels/EnemiesSection/RightEnemyContainer
@onready var enemy_name_bar: Control = $SubViewportContainer/SubViewport/PanelContainer/MidBottomPanels/EnemyNameBar
@onready var red_dmg_flash: PanelContainer = $RedDmgFlash

var enemy_l: Control
var enemy_c: Control
var enemy_r: Control
var left_enemy_status_bar: PanelContainer
var center_enemy_status_bar: PanelContainer
var right_enemy_status_bar: PanelContainer
var block_movement: bool = false
var is_first_battle: bool = true

const ENEMY = preload("uid://6y2k6pdfjohj")
const ENEMY_STATUS_BAR = preload("uid://bbk5wegsq6ymc")

func _ready() -> void:
	Global.combat_screen = self
	start_battle()
	connect_signals()
	sub_viewport_container.custom_minimum_size = panel_container.get_combined_minimum_size()

func start_battle() -> void:
	if is_first_battle:
		is_first_battle = false
		set_battle_field()
	clear_battle()
	add_enemies()

func set_battle_field() -> void:
	enemy_l = ENEMY.instantiate()
	enemy_r = ENEMY.instantiate()
	enemy_c = ENEMY.instantiate()
	left_enemy_status_bar = ENEMY_STATUS_BAR.instantiate()
	right_enemy_status_bar = ENEMY_STATUS_BAR.instantiate()
	center_enemy_status_bar = ENEMY_STATUS_BAR.instantiate()

func clear_battle() -> void:
	Global.turn_manager.reset_turn_sequence()
	pass

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
	show_enemy_name(enemy)

func connect_signals() -> void:
	#EventBus.enemy_defeated.connect(enemy_defeated)
	EventBus.damage_taken.connect(flash_red)
	EventBus.battle_started.connect(start_battle)

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

func get_random_enemies(amount:int, unique:bool = true, boss:bool = false, attempts: int = 0) -> Array:
	var result: Array = []
	var enemy: EnemyConfig
	for i in range(amount):
		var chance = Global.random.next()
		if boss:
			enemy = Global.boss_enemies[chance%Global.boss_enemies.size()]
		else:
			match Global.run_stats.current_battle:
				1:
					if Global.run_stats.current_firewall == 1:
						chance = chance % Global.weak_enemies.size()
						enemy = Global.weak_enemies[chance]
					else:
						chance = chance % 100
						if chance < 65:
							enemy = Global.weak_enemies[chance%Global.weak_enemies.size()]
						else:
							enemy = Global.medium_enemies[chance%Global.medium_enemies.size()]
				2:
					chance = chance % 100
					if chance < 25:
						enemy = Global.weak_enemies[chance%Global.weak_enemies.size()]
					elif chance < 75:
						enemy = Global.medium_enemies[chance%Global.medium_enemies.size()]
					else:
						enemy = Global.strong_enemies[chance%Global.strong_enemies.size()]
				3:
					chance = chance % 100
					if chance < 40:
						enemy = Global.weak_enemies[chance%Global.weak_enemies.size()]
					elif chance < 75:
						enemy = Global.medium_enemies[chance%Global.medium_enemies.size()]
					else:
						enemy = Global.strong_enemies[chance%Global.strong_enemies.size()]
		
		while unique && result.has(enemy):
			attempts += 1
			enemy = get_random_enemies(1, false, boss, attempts)[0]
			if attempts > 10:
				break
		
		result.append(enemy)
	return result

func add_enemies() -> void:
	Global.turn_manager.add_to_turn_sequence(enemy_c)
	Global.turn_manager.add_to_turn_sequence(enemy_l)
	Global.turn_manager.add_to_turn_sequence(enemy_r)
	
	#enemy_l.config = ENEMY_TEST
	#enemy_r.config = ENEMY_TEST_3
	#enemy_c.config = ENEMY_TEST_2
	
	if Global.run_stats.current_battle % 3:
		var random_enemy_list = get_random_enemies(3)
		enemy_l.config = random_enemy_list[0]
		enemy_r.config = random_enemy_list[1]
		enemy_c.config = random_enemy_list[2]
	else:
		var random_enemy_list = get_random_enemies(2)
		random_enemy_list.append(get_random_enemies(1, true, true)[0])
		enemy_l.config = random_enemy_list[0]
		enemy_r.config = random_enemy_list[1]
		enemy_c.config = random_enemy_list[2]
	
	enemy_l._position = EnemyPosition.Position.LEFT
	enemy_r._position = EnemyPosition.Position.RIGHT
	enemy_c._position = EnemyPosition.Position.CENTER
	enemy_l.status_bar = left_enemy_status_bar
	enemy_r.status_bar = right_enemy_status_bar
	enemy_c.status_bar = center_enemy_status_bar
	left_enemy_status_bar.enemy = enemy_l
	right_enemy_status_bar.enemy = enemy_r
	center_enemy_status_bar.enemy = enemy_c
	
	left_enemy_container.add_child(left_enemy_status_bar)
	right_enemy_container.add_child(right_enemy_status_bar)
	center_enemy_container.add_child(center_enemy_status_bar)
	
	left_enemy_container.add_child(enemy_l)
	right_enemy_container.add_child(enemy_r)
	center_enemy_container.add_child(enemy_c)
	
	left_enemy_status_bar.update()
	right_enemy_status_bar.update()
	center_enemy_status_bar.update()
	show_enemy_name(enemy_c)

func show_enemy_name(enemy) -> void:
	enemy_name_bar.set_display_name(enemy.config._name)

func flash_red(arg) -> void:
	var style: StyleBoxFlat = red_dmg_flash.get_theme_stylebox("panel").duplicate()
	red_dmg_flash.add_theme_stylebox_override("panel", style)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(style, 'border_color', Color(0.72, 0.0, 0.0, 0.53), 0.1)
	tween.chain().tween_property(style, 'border_color', Color(0.72, 0.0, 0.0, 0.0), 0.1)
