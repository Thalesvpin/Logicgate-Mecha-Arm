extends Node

var dragging := false
var gate_type := ""
var original_node

func _process(delta: float) -> void:
	if original_node && original_node.get_class() == "Area2D":
		original_node.scale_gate(Global.circuit_editor.circuit_camera.zoom)

func setup(node: Node) -> void:
	dragging = true
	original_node = node

func reset() -> void:
	dragging = false
	original_node = null

func drag_gate(node: Node2D, from_inv: bool = false) -> void:
	setup(node)
	if from_inv:
		Global.circuit_editor.gate_layer.add_child(node)
		Global.circuit_editor.gate_layer.remove_child(node)
	
	if !from_inv:
		Global.circuit_editor.gate_layer.remove_child(node)
		Global.gates_selector.sell_overlay.show()
	
	#guardar a scale original antes de trocar
	
	#print(node.sprite.scale)
	#print(Global.circuit_editor.circuit_camera.zoom)
	#node.scale_gate(Global.circuit_editor.circuit_camera.zoom)
	
	#sandbox only
	#Global.circuit_editor.drag_layer.add_child(node)
	
	#game board
	get_tree().current_scene.add_child(node)

func drop_gate(cursor_in: bool) -> void:
	original_node.scale_gate()
	get_tree().current_scene.remove_child(original_node)
	original_node.position = get_tree().current_scene.find_child("Sandbox").get_global_mouse_position() - original_node.cursor_offset
	
	if !cursor_in:
		if Global.sell_gate:
			original_node.delete_gate()
		elif original_node.last_position:
			original_node.position = original_node.last_position
		else:
			Global.gates_selector.gate_sold(original_node.type)
			original_node.queue_free()
	Global.circuit_editor.gate_layer.add_child(original_node)
	Global.gates_selector.sell_overlay.hide()
	reset()

func drag_inputs_outputs(node: Control) -> void:
	setup(node)

func drop_inputs_outputs() -> void:
	var is_inside_sandbox = Global.circuit_editor.sandbox.cursor_in
	if !is_inside_sandbox:
		if original_node.last_position:
			original_node.position = original_node.last_position
		else:
			original_node.position = Vector2.ZERO
			original_node.last_position = Vector2.ZERO
	reset()

func drag_output_preview(node: Control) -> void:
	setup(node)

func drop_output_preview() -> void:
	var is_inside_sandbox = Global.circuit_editor.sandbox.cursor_in
	if !is_inside_sandbox:
		if original_node.last_position:
			original_node.position = original_node.last_position
		else:
			original_node.position = Vector2.ZERO
			original_node.last_position = Vector2.ZERO
	reset()

func am_i_dragged(node: Node) -> bool:
	return dragging && original_node == node
