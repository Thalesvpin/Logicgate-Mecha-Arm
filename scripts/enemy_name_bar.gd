extends Control

@onready var name_label: Label = $PanelContainer/Name

func set_display_name(_name: String) -> void:
	name_label.text = _name
