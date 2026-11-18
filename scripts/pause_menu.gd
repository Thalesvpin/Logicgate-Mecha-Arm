extends PanelContainer

const MAIN_MENU = preload("uid://gjnsre4vgni8")

func open() -> void:
	show()

func close() -> void:
	Global.pause_game(false)
	hide()

func _on_continue_btn_button_up() -> void:
	close()

func _on_copy_seed_button_up() -> void:
	DisplayServer.clipboard_set(str(Global._seed))

func _on_main_menu_button_up() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)
