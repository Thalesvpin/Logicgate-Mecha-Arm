extends PanelContainer

@onready var info_btn: TextureButton = $Control/InfoBtn
@onready var next_battle_btn: TextureButton = $Control/NextBattleBtn
@onready var pause_btn: TextureButton = $Control/PauseBtn


func _on_next_battle_btn_button_up() -> void:
	#EventBus.bat
	pass

func _on_info_btn_button_up() -> void:
	pass # Replace with function body.

func _on_pause_btn_button_up() -> void:
	Global.pause_game(true)
