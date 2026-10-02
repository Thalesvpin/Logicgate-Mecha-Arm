extends Control

@onready var left_enemy_status_bar: PanelContainer = $HBoxContainer/LeftEnemyStatusBar
@onready var center_enemy_status_bar: PanelContainer = $HBoxContainer/CenterEnemyStatusBar
@onready var right_enemy_status_bar: PanelContainer = $HBoxContainer/RightEnemyStatusBar
@onready var left_enemy_container: VBoxContainer = $VBoxContainer/HBoxContainer/LeftEnemyContainer
@onready var center_enemy_container: VBoxContainer = $VBoxContainer/HBoxContainer/CenterEnemyContainer
@onready var right_enemy_container: VBoxContainer = $VBoxContainer/HBoxContainer/RightEnemyContainer
@onready var enemy_name_bar: Control = $MidBottomPanels/EnemyNameBar

const ENEMY = preload("uid://6y2k6pdfjohj")
const ENEMY_STATUS_BAR = preload("uid://bbk5wegsq6ymc")

func _ready() -> void:
	Global.combat_screen = self
	#_enemy['bar'] = center_enemy_status_bar

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("test"):
		#swap_enemy(_enemy, Position.LEFT)

func take_damage(value: float, enemy, mitigate: bool = true):
	var min = 0
	if mitigate && enemy['shield'] > 0:
		min = min(enemy['shield'], 0)
		enemy['shield'] -= min
		enemy['bar'].subtract_from_shield(min)
	
	min = min(enemy['health'], value)
	enemy['health'] -= min
	enemy['bar'].subtract_from_health(min)

func center_enemy(enemy):
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
			left_enemy_status_bar.update()
		EnemyPosition.Position.RIGHT:
			right_enemy_container.remove_child(enemy)
			right_enemy_container.add_child(front_enemy)
			front_enemy.status_bar = right_enemy_status_bar
			right_enemy_status_bar.enemy = front_enemy
			right_enemy_status_bar.update()
	
	
	center_enemy_container.add_child(enemy)
	enemy.status_bar = center_enemy_status_bar
	center_enemy_status_bar.enemy = enemy
	center_enemy_status_bar.update()
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
	EventBus.enemy_defeated.connect(enemy_defeated)

func enemy_defeated(enemy) -> void:
	var left_enemy = get_enemy(EnemyPosition.Position.LEFT)
	var right_enemy = get_enemy(EnemyPosition.Position.RIGHT)
	
	if enemy._position == EnemyPosition.Position.CENTER:
		if left_enemy.stats[Stats.List.CURRENT_HEALTH] > right_enemy.stats[Stats.List.CURRENT_HEALTH]:
			center_enemy(left_enemy)
		else:
			center_enemy(right_enemy)

func get_enemy(position: EnemyPosition.Position):
	var slot
	match position:
		EnemyPosition.Position.LEFT:
			slot = left_enemy_container
		EnemyPosition.Position.RIGHT:
			slot = right_enemy_container
		EnemyPosition.Position.CENTER:
			slot = center_enemy_container
	
	for child in slot.get_children():
		if child.get_class() == "Control":
			return child
