extends Control

@onready var left_enemy_container: VBoxContainer = $TopPanels/EnemiesSection/LeftEnemyContainer
@onready var center_enemy_container: VBoxContainer = $TopPanels/EnemiesSection/CenterEnemyContainer
@onready var right_enemy_container: VBoxContainer = $TopPanels/EnemiesSection/RightEnemyContainer
@onready var enemy_name_bar: Control = $MidBottomPanels/EnemyNameBar
var left_enemy_status_bar: PanelContainer
var center_enemy_status_bar: PanelContainer
var right_enemy_status_bar: PanelContainer

const ENEMY = preload("uid://6y2k6pdfjohj")
const ENEMY_STATUS_BAR = preload("uid://bbk5wegsq6ymc")

func _ready() -> void:
	Global.combat_screen = self
	add_enemies()
	connect_signals()

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

func center_enemy(enemy):
	print('combat_screen center_enemy()')
	var selected_status_bar = enemy.status_bar
	var current_position = enemy._position
	var front_enemy = get_enemy(EnemyPosition.Position.CENTER)
	
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
	
	front_enemy._position = current_position
	center_enemy_container.add_child(enemy)
	enemy.status_bar = center_enemy_status_bar
	enemy._position = EnemyPosition.Position.CENTER
	center_enemy_status_bar.enemy = enemy
	center_enemy_status_bar.enemy_swap()
	enemy_name_bar.set_display_name(enemy.enemy_name)
	#current_position.update()

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
	pass

func enemy_defeated(enemy) -> void:
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

func add_enemies() -> void:
	var enemy_l = ENEMY.instantiate()
	var enemy_r = ENEMY.instantiate()
	var enemy_c = ENEMY.instantiate()
	var bar_l = ENEMY_STATUS_BAR.instantiate()
	var bar_r = ENEMY_STATUS_BAR.instantiate()
	var bar_c = ENEMY_STATUS_BAR.instantiate()
	
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
