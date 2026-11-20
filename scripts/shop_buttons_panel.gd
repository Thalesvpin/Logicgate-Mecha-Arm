extends PanelContainer

@onready var info_btn: Button = $Control/InfoBtn
@onready var next_battle_btn: Button = $Control/NextBattleBtn
@onready var pause_btn: Button = $Control/PauseBtn
@onready var combat_screen: PanelContainer = $"."


func _on_next_battle_btn_button_up() -> void:
	Global.game_board.close_shop()
	EventBus.battle_started.emit()

func _on_info_btn_button_up() -> void:
	pass # Replace with function body.

func _on_pause_btn_button_up() -> void:
	Global.pause_game(true)
