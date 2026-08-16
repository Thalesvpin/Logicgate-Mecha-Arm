extends Node

var dragging := false
var gate_type := ""
var original_node

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
	
	#sandbox only
	#Global.circuit_editor.drag_layer.add_child(node)
	
	#game board
	get_tree().current_scene.add_child(node)

func drop_gate(cursor_in: bool) -> void:
	#sandbox only
	#Global.circuit_editor.drag_layer.remove_child(original_node)
	
	#game board
	get_tree().current_scene.remove_child(original_node)
	
	#original_node.position = get_global_mouse_position()
	original_node.position = get_tree().current_scene.find_child("Sandbox").get_global_mouse_position() - original_node.cursor_offset
	#original_node.position = get_tree().current_scene.find_child("Sandbox").get_viewport().get_mouse_position()
	
	if !cursor_in:
		if Global.sell_gate:
			original_node.delete_gate()
		elif original_node.last_position:
			original_node.position = original_node.last_position
		else:
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

func am_i_dragged(node: Node) -> bool:
	return dragging && original_node == node
