extends IOBar

@onready var drag_area: Area2D = $DragArea

var output: int

func ready() -> void:
	Global.output_manager = self

func process() -> void:
	pass

func submit() -> void:
	var result := 0
	for child in children:
		result = result << 1 | int(child.output)
	
	output = result
	print('output: ', output)
	Global.circuit_editor.compare_output(output)

func prevent_click(value: bool) -> void:
	drag_area.input_pickable = !value

func _on_drag_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
				DragManager.drag_inputs_outputs(self)
				_get_offset()
