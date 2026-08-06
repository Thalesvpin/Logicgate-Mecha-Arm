extends Area2D

@export_enum("AND", "OR", "DEF") var type: String = "DEF"
#@export var gate_scene : PackedScene
const gate_scene := preload("res://scenes/gates/and_gate.tscn")
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var output: Area2D = $Output

var dragging := false
##Stores the last dropped position inside sandbox
var last_position: Vector2
##Inputs and output array
var connectors: Array[Node2D]
##Gate's internal input nodes
var input_nodes: Array[Node2D]
##Signals beign inputed in top-down order
var input_values: Array[bool]
var connected_wires: Array

func _ready() -> void:
	map_pins()

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if is_topmost_gate_at(get_global_mouse_position()):
				DragManager.drag(self)

func is_topmost_gate_at(point: Vector2) -> bool:
	var params := PhysicsPointQueryParameters2D.new()
	params.position = point
	params.collide_with_areas = true
	params.collide_with_bodies = false
	var hits := get_world_2d().direct_space_state.intersect_point(params)
	var top_gate: Area2D = null
	var top_rank := -1
	for hit in hits:
		var area := hit.collider as Area2D
		if area == null || area == Global.circuit_editor.circuit_camera.area_2d:
			continue
		var rank := draw_rank(area)
		if rank > top_rank:
			top_rank = rank
			top_gate = area
	return top_gate == self

func draw_rank(node: Node2D) -> int:
	var parent := node.get_parent()
	var sibling_idx := parent.get_children().find(node) if parent else 0
	return node.z_index * 100000 + sibling_idx

func map_pins():
	for child in v_box_container.get_children():
		if child.name == "Spacing":
			continue
		connectors.append(child.get_child(0))
	input_nodes = connectors
	connectors.append(output)

func calculate_output() -> bool:
	for inp in input_nodes:
		if inp.connected_gate != null:
			input_values.append(inp.connected_gate.calculate_output())
		else:
			input_values.append(null)
	
	var null_free_array = input_values.filter(func(element): return element != null)
	match type.to_upper():
		"AND":
			for i in null_free_array:
				if !i:
					return false
			return true
		"OR":
			for i in null_free_array:
				if i:
					return true
			return false
		"NOT":
			return !null_free_array[0]
		"NAND":
			for i in null_free_array:
				if !i:
					return true
			return false
		"NOR":
			for i in null_free_array:
				if i:
					return false
			return true
		"XOR":
			var count = 0
			
			for i in null_free_array:
				if i:
					count += 1
			
			if count > 1:
				return false
			return true
		"XNOR":
			pass
	
	return false

func disconnect_wires() -> void:
	for wire in connected_wires:
		if self == wire.point_a.owner:
			wire.point_b.connected_gate = null
			if wire.point_b.owner is Area2D:
				wire.point_b.owner.connected_wires.filter(func(element): return element != wire)
			else:
				wire.point_b.connected_wires.filter(func(element): return element != wire)
		else:
			if wire.point_a.owner is Area2D:
				wire.point_a.owner.connected_wires.filter(func(element): return element != wire)
			else:
				wire.point_a.connected_wires.filter(func(element): return element != wire)
		
		wire.queue_free()

func delete_gate() -> void:
	disconnect_wires()
	queue_free()
