@tool
extends ColorRect

func _process(_delta: float) -> void:
	var mat := material as ShaderMaterial
	if not mat: return
	
	# Safe fetch: Prevents crashes during editor startup/scene loading
	var vp := get_viewport()
	if not vp: return 
	
	var local_mouse := get_local_mouse_position()
	var sz := size
	
	# Zero-allocation bounds check (replaces Rect2 creation)
	var is_inside_rect := local_mouse.x >= 0.0 and local_mouse.x <= sz.x and local_mouse.y >= 0.0 and local_mouse.y <= sz.y
	
	var vp_mouse := vp.get_mouse_position()
	var vp_bounds := vp.get_visible_rect()
	var is_inside_viewport := vp_bounds.has_point(vp_mouse)
	
	if is_inside_rect and is_inside_viewport:
		mat.set_shader_parameter("mouse_global_pos", get_global_mouse_position())
	else:
		mat.set_shader_parameter("mouse_global_pos", Vector2(-100000.0, -100000.0))
