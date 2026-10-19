@tool
extends ColorRect

func _process(_delta: float) -> void:
	if material is ShaderMaterial:
		# Grabs the true 2D world space coordinate of the mouse
		material.set_shader_parameter("mouse_global_pos", get_global_mouse_position())
