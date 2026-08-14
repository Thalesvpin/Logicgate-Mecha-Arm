extends Node

var dragging := false
#var dragged_scene : PackedScene
var preview : Node2D
var gate_type := ""
var source_icon
var original_node

func drag(node: Node2D, from_inv: bool = false):
	dragging = true
	original_node = node
	if !from_inv:
		Global.circuit_editor.gate_layer.remove_child(node)
		Global.gates_selector.sell_overlay.show()
	
	#sandbox only
	#Global.circuit_editor.drag_layer.add_child(node)
	
	#game board
	get_tree().current_scene.add_child(node)

func drop(cursor_in: bool):
	#sandbox only
	#Global.circuit_editor.drag_layer.remove_child(original_node)
	
	#game board
	get_tree().current_scene.remove_child(original_node)
	
	#original_node.position = get_global_mouse_position()
	original_node.position = get_tree().current_scene.find_child("Sandbox").get_global_mouse_position()
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
	dragging = false
	original_node = null
