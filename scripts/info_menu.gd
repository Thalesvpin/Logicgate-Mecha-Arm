extends PanelContainer

func open() -> void:
	show()

func close() -> void:
	Global.pause_game(false)
	hide()

func _on_continue_btn_button_up() -> void:
	close()
