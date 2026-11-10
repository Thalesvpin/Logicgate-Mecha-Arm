extends Control

@onready var area_2d: Area2D = $Area2D
@onready var input: Label = $PanelContainer/Input
var connections: Array = []

func set_value(value: bool):
	area_2d.set_active(value)
