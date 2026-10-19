@tool
extends ColorRect

func _process(_delta: float) -> void:
	if material != null:
		material.set_shader_parameter("rect_aspect", size.x / max(size.y, 1.0))
