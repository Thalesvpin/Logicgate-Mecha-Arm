extends PanelContainer

func open() -> void:
	var x = get_parent().size.x * 0.4
	var y = get_parent().size.y * 0.8
	size = Vector2(x, y)
	show()
	set_anchors_preset(Control.PRESET_CENTER)
	position = (get_parent_control().size - size) / 2

func close() -> void:
	Global.pause_game(false)
	hide()

func _on_continue_btn_button_up() -> void:
	close()
