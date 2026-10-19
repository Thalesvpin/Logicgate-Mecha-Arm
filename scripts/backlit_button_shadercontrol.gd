@tool
extends Button

func _ready() -> void:
	# Safely connect the resized signal in both the editor and running game
	if not resized.is_connected(_update_shader_size):
		resized.connect(_update_shader_size)
	
	# Initial size push
	_update_shader_size()

func _update_shader_size() -> void:
	if material is ShaderMaterial:
		material.set_shader_parameter("rect_size", size)

# Click handling for runtime (only fires when not in-editor)
func _gui_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if material is ShaderMaterial and not toggle_mode:
			material.set_shader_parameter("is_active", event.pressed)

func _toggled(toggled_on: bool) -> void:
	if not Engine.is_editor_hint() and material is ShaderMaterial:
		material.set_shader_parameter("is_active", toggled_on)
