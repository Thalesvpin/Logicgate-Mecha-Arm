@tool
extends ColorRect

@export_category("Shader Mouse Tracking")
## Adjust this to align the glow with the visual center of your cursor graphic (e.g. X: 6.0, Y: 8.0)
@export var cursor_visual_offset: Vector2 = Vector2(0.0, 0.0) 

func _process(_delta: float) -> void:
	if material and material is ShaderMaterial:
		if material.get_shader_parameter("enable_mouse"):
			# Grabs the mouse position in absolute Global Canvas space
			var global_mouse = get_global_mouse_position() + cursor_visual_offset
			
			material.set_shader_parameter("mouse_global_pos", global_mouse)
