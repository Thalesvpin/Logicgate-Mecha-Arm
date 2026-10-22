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

# Zero-Allocation Ring Buffers
var _ripples := PackedVector4Array()
var _reps := PackedVector4Array()
var _rip_idx: int = 0
var _rep_idx: int = 0

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
	
	# Initialize Ring Buffers safely once
	if _ripples.size() != MAX_CLICK_INSTANCES:
		_ripples.resize(MAX_CLICK_INSTANCES)
		_ripples.fill(Vector4(-100000.0, 0.0, 0.0, 0.0))
		_reps.resize(MAX_CLICK_INSTANCES)
		_reps.fill(Vector4(-100000.0, 0.0, 0.0, 0.0))
	
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
		var c_pos = get_global_mouse_position()
		
		# Write to Ring Buffer instantly (No Memory Allocation)
		_rip_idx = (_rip_idx + 1) % MAX_CLICK_INSTANCES
		_ripples[_rip_idx] = Vector4(c_pos.x, c_pos.y, 0.01, 1.0)
		
		_rep_idx = (_rep_idx + 1) % MAX_CLICK_INSTANCES
		_reps[_rep_idx] = Vector4(c_pos.x, c_pos.y, 0.01, 1.0)

	_was_mouse_pressed = is_pressed
	
	var needs_redraw := false
	var decay_rate: float = mat.get_shader_parameter("ripple_decay") if mat.get_shader_parameter("ripple_decay") != null else 1.0
	var active_rip_count := 0
	var active_rep_count := 0
	
	# Evaluate Fixed Buffer In-Place
	for i in MAX_CLICK_INSTANCES:
		if _ripples[i].z > 0.0:
			_ripples[i].z += ripple_speed * delta
			if _ripples[i].z > ripple_max_radius:
				_ripples[i].z = 0.0
				_ripples[i].x = -100000.0
			else:
				# Precompute decay on CPU
				_ripples[i].w = exp(-_ripples[i].z * (decay_rate / 1000.0))
				active_rip_count += 1
				needs_redraw = true
				
		if _reps[i].z > 0.0:
			_reps[i].z += click_repulsion_speed * delta
			if _reps[i].z > click_repulsion_max_radius:
				_reps[i].z = 0.0
				_reps[i].x = -100000.0
			else:
				_reps[i].w = exp(-_reps[i].z * 0.001)
				active_rep_count += 1
				needs_redraw = true
				
	mat.set_shader_parameter("active_ripple_count", active_rip_count)
	mat.set_shader_parameter("ripple_sources_v4", _ripples)
	mat.set_shader_parameter("active_click_repulsion_count", active_rep_count)
	mat.set_shader_parameter("repulsion_click_sources_v4", _reps)
	
	if needs_redraw:
		queue_redraw()
