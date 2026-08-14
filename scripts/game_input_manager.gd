extends VBoxContainer

@onready var drag_bar: ColorRect = $DragBar

var _dragging := false
var _drag_offset := Vector2.ZERO

func _ready() -> void:
	for child in get_children():
		child.size_flags_vertical = Control.SIZE_EXPAND
	
	drag_bar.gui_input.connect(_on_drag_handle_gui_input)
func _on_drag_handle_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_dragging = true
			_drag_offset = get_global_mouse_position() - global_position
		else:
			_dragging = false
	elif event is InputEventMouseMotion and _dragging:
		global_position = get_global_mouse_position() - _drag_offset
		
