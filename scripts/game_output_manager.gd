extends IOBar

@onready var drag_area: Area2D = $DragArea

func ready() -> void:
	pass

func process() -> void:
	pass

func prevent_click(value: bool):
	drag_area.input_pickable = !value

func _on_drag_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
				DragManager.drag_inputs_outputs(self)
				_get_offset()
