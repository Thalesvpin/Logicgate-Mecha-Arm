extends Node2D

@export var color: Color

func _draw():
	draw_rect(
		Rect2(-100000,-100000,200000,200000),
		color
	)
