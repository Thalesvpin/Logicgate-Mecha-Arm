extends Node

@export var tooltip_scene: PackedScene

func _make_custom_tooltip(for_text: String) -> Object:
	var _tooltip = tooltip_scene.instantiate()
	_tooltip.config(for_text)
	return _tooltip
