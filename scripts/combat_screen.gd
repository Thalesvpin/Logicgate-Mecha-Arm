extends Control

@onready var left_enemy_status_bar: PanelContainer = $HBoxContainer/LeftEnemyStatusBar
@onready var center_enemy_status_bar: PanelContainer = $HBoxContainer/CenterEnemyStatusBar
@onready var right_enemy_status_bar: PanelContainer = $HBoxContainer/RightEnemyStatusBar

enum Position {LEFT, RIGHT, CENTER}

var _enemy: Dictionary = {
	'id': 0,
	'health': 100,
	'shield': 0,
	'elemental': null,
	'elemental_lvl': null,
	'afflicted_element': null,
	'afflicted_count': null,
	'actions': 1,
	'bar': null
}

func _ready() -> void:
	Global.combat_screen = self
	_enemy['bar'] = center_enemy_status_bar

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		swap_enemy(_enemy, Position.LEFT)

func take_damage(value: float, enemy, mitigate: bool = true):
	var min = 0
	if mitigate && enemy['shield'] > 0:
		min = min(enemy['shield'], 0)
		enemy['shield'] -= min
		enemy['bar'].subtract_from_shield(min)
	
	min = min(enemy['health'], value)
	enemy['health'] -= min
	enemy['bar'].subtract_from_health(min)

func swap_enemy(enemy, to: Position):
	var current_position = enemy['bar']
	match to:
		Position.CENTER:
			center_enemy_status_bar.enemy['bar'] = current_position
			enemy['bar'] = center_enemy_status_bar
			center_enemy_status_bar.update()
		Position.LEFT:
			#left_enemy_status_bar.enemy['bar'] = current_position
			#enemy['bar'] = left_enemy_status_bar
			left_enemy_status_bar.update()
		Position.RIGHT:
			right_enemy_status_bar.enemy['bar'] = current_position
			enemy['bar'] = right_enemy_status_bar
			right_enemy_status_bar.update()
	current_position.update()

#region PLAYER ACTIONS
func player_attack() -> void:
	pass

func player_charged_attack() -> void:
	pass

func player_charge_charged_attack() -> void:
	pass

func player_self_damage() -> void:
	pass

func player_heal_health() -> void:
	pass

func player_heal_shield() -> void:
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
	circuit_editor.attack.connect(player_attack)
	circuit_editor.charged_attack.connect(player_charged_attack)
	circuit_editor.charge_charged_attack.connect(player_charge_charged_attack)
	circuit_editor.self_damage.connect(player_self_damage)
	circuit_editor.heal_health.connect(player_heal_health)
	circuit_editor.heal_shield.connect(player_heal_shield)
