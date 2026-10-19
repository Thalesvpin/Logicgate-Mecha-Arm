@tool
extends ColorRect

func _process(_delta: float) -> void:
	if material is ShaderMaterial:
		# 1. Check ColorRect bounds
		var local_mouse = get_local_mouse_position()
		var rect_bounds = Rect2(Vector2.ZERO, size)
		var is_inside_rect = rect_bounds.has_point(local_mouse)
		
		# 2. Check SubViewport bounds
		var vp = get_viewport()
		var vp_mouse = vp.get_mouse_position()
		var vp_bounds = vp.get_visible_rect()
		var is_inside_viewport = vp_bounds.has_point(vp_mouse)
		
		# 3. Only show highlight if the mouse is inside BOTH
		if is_inside_rect and is_inside_viewport:
			material.set_shader_parameter("mouse_global_pos", get_global_mouse_position())
		else:
			material.set_shader_parameter("mouse_global_pos", Vector2(-100000.0, -100000.0))
