extends IOBar

@onready var drag_area: Area2D = $DragArea

var output: int
var output_nodes: Array[Control]

func ready() -> void:
	Global.output_manager = self
	get_output_nodes()

func get_output_nodes():
	for child in get_children():
		if child.get_class() == "Control":
			output_nodes.append(child)

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

func precalculate_output():
	var results := []
	var aux
	var execution_list_size = output_nodes[0].get_child(0).precalculate_output().size()
	for bit in execution_list_size:
		aux = 0
		for out in output_nodes:
			aux = aux << 1 | int(out.get_child(0).precalculate_output()[bit])
		results.append(aux)
	
	print('precalculou: ', results)
	return results
