extends VBoxContainer
class_name IOBar

##Stores the last dropped position inside sandbox
var last_position: Vector2
var was_pressed
var cursor_offset: Vector2
var children: Array[Control]

func _ready() -> void:
	ready()
	setup()

func _process(delta: float) -> void:
	handle_drag()
	process()

func setup():
	for child in get_children():
		if child is Control: 
			child.size_flags_vertical = Control.SIZE_EXPAND
			children.append(child)
	
	last_position = position

func _get_offset() -> void:
	cursor_offset = get_global_mouse_position() - global_position

func handle_drag():
	if DragManager.am_i_dragged(self):
		global_position = get_global_mouse_position() - cursor_offset
		var is_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		if was_pressed && !is_pressed:
			DragManager.drop_inputs_outputs()
			last_position = position
		was_pressed = is_pressed

func ready():
	pass

func process():
	pass
