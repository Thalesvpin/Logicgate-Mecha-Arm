extends VBoxContainer

@onready var drag_bar: ColorRect = $DragBar
@onready var area_2d: Area2D = $Area2D

var _dragging := false
var _drag_offset := Vector2.ZERO
##Stores the last dropped position inside sandbox
var last_position: Vector2

func _ready() -> void:
	for child in get_children():
		if child is Control: 
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
		

func _on_drag_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
				DragManager.drag_inputs_outputs(self)
