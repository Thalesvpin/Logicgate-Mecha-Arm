extends Control

func _ready() -> void:
	custom_minimum_size.x = (get_child(0).get_child(1).size.x * 3) + 30
