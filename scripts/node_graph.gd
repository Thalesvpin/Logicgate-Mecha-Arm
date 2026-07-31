extends Control

#var and_gate = preload("res://scenes/and_gate.tscn")
@onready var graph_edit: GraphEdit = $GraphEdit

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		#var node := GraphNode.new()
		var node : GraphNode = get_node("AndGate").duplicate()
		node.show()
		get_node("GraphEdit").add_child(node)
		var local := graph_edit.get_local_mouse_position()
		print('zoom: ', graph_edit.zoom)
		node.position_offset = local / graph_edit.zoom + graph_edit.scroll_offset
