extends PanelContainer

func _on_skip_button_up() -> void:
	EventBus.skip_pack.emit()
