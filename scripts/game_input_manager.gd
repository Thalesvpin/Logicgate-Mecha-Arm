extends IOBar

@onready var drag_area: Area2D = $DragArea

func ready() -> void:
	Global.input_manager = self
	EventBus.submit_circuit.connect(submit)

func process() -> void:
	pass

func submit(queue_idx: int) -> void:
	print('input_mngr sequence: ', Global.circuit_editor.execution_sequence)
	var value: int = Global.dec_to_bin(Global.circuit_editor.execution_sequence[queue_idx])
	print('value: %04d' % value)
	var str = '%04d' % value
	var aux
	
	for child in children:
		child.set_value(false)
	
	for i in children.size():
		await get_tree().create_timer(0.8).timeout
		aux = int(str[i])
		children[i].set_value(bool(aux))
	
	await get_tree().create_timer(0.1).timeout
	Global.output_manager.submit()

func prevent_click(value: bool):
	drag_area.input_pickable = !value

func _on_drag_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
				DragManager.drag_inputs_outputs(self)
				_get_offset()
