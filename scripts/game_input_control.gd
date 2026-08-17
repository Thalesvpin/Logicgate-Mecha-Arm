extends Control

@onready var area_2d: Area2D = $Area2D

func set_value(value: bool):
	area_2d.set_active(value)
