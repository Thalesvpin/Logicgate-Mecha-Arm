@tool
extends ColorRect

const MAX_CLICK_INSTANCES: int = 8

@export_group("Grid Themes")
@export_enum("Custom (No Override)", "Blueprint", "Cyberpunk", "Minimalist", "Tactical", "Dark Mode") var theme_preset: int = 0:
	set(val):
		theme_preset = val
		_apply_theme()

@export_group("Ripple / Shockwave")
@export var ripple_speed: float = 800.0
@export var ripple_max_radius: float = 1200.0

@export_group("Click Repulsion Impulse")
@export var click_repulsion_speed: float = 1000.0
@export var click_repulsion_max_radius: float = 1000.0

var _viewport: Viewport = null
var _was_mouse_pressed: bool = false
var _ripples: Array[Dictionary] = []
var _click_repulsions: Array[Dictionary] = []

func _apply_theme() -> void:
	var mat := material as ShaderMaterial
	if not mat or theme_preset == 0: return
	match theme_preset:
		1: # Blueprint
			mat.set_shader_parameter("bg_color", Color(0.04, 0.15, 0.45))
			mat.set_shader_parameter("grid_color", Color(0.9, 0.9, 1.0, 0.8))
			mat.set_shader_parameter("subgrid_color", Color(0.6, 0.7, 0.9, 0.4))
			mat.set_shader_parameter("main_grid_style", 0)
			mat.set_shader_parameter("subgrid_style", 0)
			mat.set_shader_parameter("invert_colors", false)
		2: # Cyberpunk
			mat.set_shader_parameter("bg_color", Color(0.05, 0.01, 0.1))
			mat.set_shader_parameter("grid_color", Color(1.0, 0.0, 0.5, 0.9))
			mat.set_shader_parameter("subgrid_color", Color(0.0, 1.0, 1.0, 0.4))
			mat.set_shader_parameter("invert_colors", false)
		3: # Minimalist
			mat.set_shader_parameter("bg_color", Color(0.95, 0.95, 0.95))
			mat.set_shader_parameter("grid_color", Color(0.2, 0.2, 0.2, 0.6))
			mat.set_shader_parameter("subgrid_color", Color(0.5, 0.5, 0.5, 0.3))
			mat.set_shader_parameter("main_grid_style", 1)
			mat.set_shader_parameter("subgrid_style", 1)
			mat.set_shader_parameter("invert_colors", false)
		4: # Tactical
			mat.set_shader_parameter("bg_color", Color(0.02, 0.05, 0.02))
			mat.set_shader_parameter("grid_color", Color(0.2, 1.0, 0.2, 0.7))
			mat.set_shader_parameter("subgrid_color", Color(0.1, 0.5, 0.1, 0.3))
			mat.set_shader_parameter("main_grid_style", 3)
			mat.set_shader_parameter("subgrid_style", 2)
			mat.set_shader_parameter("invert_colors", false)
		5: # Dark Mode
			mat.set_shader_parameter("bg_color", Color(0.02, 0.02, 0.02))
			mat.set_shader_parameter("grid_color", Color(1.0, 1.0, 1.0, 0.15))
			mat.set_shader_parameter("subgrid_color", Color(1.0, 1.0, 1.0, 0.05))
			mat.set_shader_parameter("invert_colors", false)

func _process(delta: float) -> void:
	var mat := material as ShaderMaterial
	if not mat: return
	
	var vp := get_viewport()
	if not vp: return 
	
	var local_mouse := get_local_mouse_position()
	var sz := size
	
	mat.set_shader_parameter("rect_size", sz)
	
	var is_inside_rect := local_mouse.x >= 0.0 and local_mouse.x <= sz.x and local_mouse.y >= 0.0 and local_mouse.y <= sz.y
	var vp_mouse := vp.get_mouse_position()
	var vp_bounds := vp.get_visible_rect()
	var is_inside_viewport := vp_bounds.has_point(vp_mouse)
	var is_valid = is_inside_rect and is_inside_viewport
	
	if is_valid:
		mat.set_shader_parameter("mouse_global_pos", get_global_mouse_position())
	else:
		mat.set_shader_parameter("mouse_global_pos", Vector2(-100000.0, -100000.0))
		
	var is_pressed := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if is_pressed and not _was_mouse_pressed and is_valid:
		var click_pos = get_global_mouse_position()
		
		_ripples.append({"pos": click_pos, "radius": 0.0})
		if _ripples.size() > MAX_CLICK_INSTANCES:
			_ripples.pop_front()
			
		_click_repulsions.append({"pos": click_pos, "radius": 0.0})
		if _click_repulsions.size() > MAX_CLICK_INSTANCES:
			_click_repulsions.pop_front()

	_was_mouse_pressed = is_pressed
	
	var active_ripple_vectors: Array[Vector4] = []
	var ripple_decay_rate: float = mat.get_shader_parameter("ripple_decay") if mat.get_shader_parameter("ripple_decay") != null else 1.0
	
	var i = _ripples.size() - 1
	while i >= 0:
		_ripples[i]["radius"] += ripple_speed * delta
		if _ripples[i]["radius"] > ripple_max_radius:
			_ripples.remove_at(i)
		else:
			var r = _ripples[i]
			var precalc_decay = exp(-r["radius"] * (ripple_decay_rate / 1000.0))
			active_ripple_vectors.append(Vector4(r["pos"].x, r["pos"].y, r["radius"], precalc_decay))
		i -= 1
		
	var active_repulsion_vectors: Array[Vector4] = []
	i = _click_repulsions.size() - 1
	while i >= 0:
		_click_repulsions[i]["radius"] += click_repulsion_speed * delta
		if _click_repulsions[i]["radius"] > click_repulsion_max_radius:
			_click_repulsions.remove_at(i)
		else:
			var c = _click_repulsions[i]
			var precalc_decay = exp(-c["radius"] * 0.001)
			active_repulsion_vectors.append(Vector4(c["pos"].x, c["pos"].y, c["radius"], precalc_decay))
		i -= 1
		
	while active_ripple_vectors.size() < MAX_CLICK_INSTANCES:
		active_ripple_vectors.append(Vector4(-100000.0, -100000.0, 0.0, 0.0))
	while active_repulsion_vectors.size() < MAX_CLICK_INSTANCES:
		active_repulsion_vectors.append(Vector4(-100000.0, -100000.0, 0.0, 0.0))
		
	mat.set_shader_parameter("active_ripple_count", _ripples.size())
	mat.set_shader_parameter("ripple_sources_v4", active_ripple_vectors)
	
	mat.set_shader_parameter("active_click_repulsion_count", _click_repulsions.size())
	mat.set_shader_parameter("repulsion_click_sources_v4", active_repulsion_vectors)
	
	if _ripples.size() > 0 or _click_repulsions.size() > 0:
		queue_redraw()
