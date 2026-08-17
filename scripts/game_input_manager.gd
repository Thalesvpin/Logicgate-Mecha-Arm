extends IOBar

@onready var drag_area: Area2D = $DragArea

@export var generated_inputs: Array[int]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		submit(0)

func ready() -> void:
	Global.input_manager = self

func process() -> void:
	pass

func submit(queue_idx: int) -> void:
	var value: int = generated_inputs[queue_idx]
	var str = str(value)
	var aux
	#children.reverse()
	for i in children.size():
		await get_tree().create_timer(0.8).timeout
		aux = int(str[i])
		children[i].set_value(bool(aux))
		#children[i].set_value(bool(value%10))
		#value /= 10
	#children.reverse()
	
	await get_tree().create_timer(0.1).timeout
	Global.output_manager.submit()

func prevent_click(value: bool):
	drag_area.input_pickable = !value

func _on_drag_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
				DragManager.drag_inputs_outputs(self)
				_get_offset()
