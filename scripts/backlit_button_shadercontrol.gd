@tool
extends Button

@export var enable_interactive_mouse_light: bool = false:
	set(value):
		enable_interactive_mouse_light = value
		set_process(enable_interactive_mouse_light)
		if material is ShaderMaterial:
			material.set_shader_parameter("enable_mouse_light", enable_interactive_mouse_light)

func _ready() -> void:
	if not resized.is_connected(_update_shader_size):
		resized.connect(_update_shader_size)
	
	_update_shader_size()
	set_process(enable_interactive_mouse_light)
	if material is ShaderMaterial:
		material.set_shader_parameter("enable_mouse_light", enable_interactive_mouse_light)

func _process(_delta: float) -> void:
	if material is ShaderMaterial:
		material.set_shader_parameter("mouse_position", get_local_mouse_position())

func _update_shader_size() -> void:
	if material is ShaderMaterial:
		material.set_shader_parameter("rect_size", size)

func _gui_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if material is ShaderMaterial and not toggle_mode:
			material.set_shader_parameter("is_active", event.pressed)

func _toggled(toggled_on: bool) -> void:
	if not Engine.is_editor_hint() and material is ShaderMaterial:
		material.set_shader_parameter("is_active", toggled_on)
