extends IOBar

@onready var drag_area: Area2D = $DragArea
@onready var final_output: Control = $FinalOutput
@onready var final_output_2: Control = $FinalOutput2
@onready var final_output_3: Control = $FinalOutput3
@onready var final_output_4: Control = $FinalOutput4

var output: int
var output_nodes: Array[Control]
var connections: Array = []

func ready() -> void:
	Global.output_manager = self
	output_nodes = [final_output, final_output_2, final_output_3, final_output_4]

func process() -> void:
	pass

func submit(queue_idx: int) -> void:
	var result := 0
	for child in children:
		result = result << 1 | int(child.output)
	
	output = result
	print('output: ', output)
	Global.change_wires_color(Color('purple'))
	await get_tree().create_timer(1).timeout
	Global.circuit_editor.compare_output(output)
	await get_tree().create_timer(1).timeout
	Global.reset_wires_color()
	EventBus.tick.emit()
	if queue_idx == 2:
		EventBus.turn_ended.emit('player')

func prevent_click(value: bool) -> void:
	drag_area.input_pickable = !value

func check_submit_requirements() -> bool:
	for output in output_nodes:
		if output.connections.size() == 0:
			return false
	return true

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
