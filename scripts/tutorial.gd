extends Control

@onready var circuit_editor: PanelContainer = $CircuitEditor

func _ready() -> void:
	circuit_editor.lock_zoom(true)
