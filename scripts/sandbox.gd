extends Node2D

@onready var gate_layer: Node2D = $GateLayer
@onready var wire_layer: Node2D = $WireLayer
@onready var drag_layer: Node2D = $DragLayer
@onready var collision_shape_2d: CollisionShape2D = $CircuitCamera/Area2D/CollisionShape2D

var line := preload("res://scenes/cable.tscn")

var was_pressed := false
var cursor_in: bool = false

func _process(delta):
	update_drag()
	if DragManager.dragging:
		var is_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		if was_pressed && !is_pressed:
			end_drag()
		was_pressed = is_pressed

func update_drag():
	if !DragManager.dragging:
		return
	
	DragManager.original_node.global_position = get_global_mouse_position()

func end_drag():
	DragManager.drop(cursor_in)

var point_a = null
var point_b = null
func trace_line(point):
	if point.type.to_lower() == "output":
		point_a = point
	if point.type.to_lower() == "input":
		point_b = point
	
	if point_a && point_b:
		if point_a.owner != point_b.owner:
			print('Line drawn')
			var _line = line.instantiate()
			_line.point_a = point_a
			_line.point_b = point_b
			wire_layer.add_child(_line)
			
			point_a = null
			point_b = null
		else:
			if point == point_a:
				point_a = null
			if point == point_b:
				point_b = null

func _on_area_2d_mouse_entered() -> void:
	cursor_in = true

func _on_area_2d_mouse_exited() -> void:
	cursor_in = false

func _on_gate_layer_child_entered_tree(node: Node) -> void:
	node.last_position = node.global_position
	for connector in node.connectors:
		print('connected')
		connector.clicked.connect(trace_line)
