extends Area2D

@export_enum("AND", "OR", "DEF") var type: String = "DEF"
#@export var gate_scene : PackedScene
const gate_scene := preload("res://scenes/gates/and_gate.tscn")
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var output: Area2D = $Output
@onready var radial_menu: Control = $RadialMenu

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
	radial_menu.item_selected.connect(handle_radial_menu_selection)

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position()
	
	output.set_active(calculate_output())

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if is_topmost_gate_at(get_global_mouse_position()):
				DragManager.drag(self)
	
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		radial_menu.set_items(Global.gate_options)
		var m = get_local_mouse_position()
		# Pass the center position to open_menu as a Vector2!
		radial_menu.open_menu(m)
		# Make sure we don't handle the click again anywhere else...
		get_viewport().set_input_as_handled()

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
	input_nodes = connectors.duplicate()
	connectors.append(output)

func calculate_output() -> bool:
	input_values = []
	for inp in input_nodes:
		if inp.connected_gate != null:
			input_values.append(inp.connected_gate.is_active)
	
	match type.to_upper():
		"AND":
			if !input_values:
				return false
			for i in input_values:
				print('inp val: ', i)
				if !i:
					return false
			return true
		"OR":
			for i in input_values:
				if i:
					return true
			return false
		"NOT":
			if !input_values:
				return true
			return !input_values[0]
		"NAND":
			if !input_values:
				return true
			for i in input_values:
				if !i:
					return true
			return false
		"NOR":
			for i in input_values:
				if i:
					return false
			return true
		"XOR":
			var count = 0
			
			for i in input_values:
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
				wire.point_b.owner.connected_wires = wire.point_b.owner.connected_wires.filter(func(element): return element != wire)
			else:
				wire.point_b.connected_wires = wire.point_b.connected_wires.filter(func(element): return element != wire)
		else:
			if wire.point_a.owner is Area2D:
				wire.point_a.owner.connected_wires = wire.point_a.owner.connected_wires.filter(func(element): return element != wire)
			else:
				wire.point_a.connected_wires = wire.point_a.connected_wires.filter(func(element): return element != wire)
				wire.point_a.connected_gate = wire.point_a.connected_gate.filter(func(element): return element != wire)
		
		wire.queue_free()
	connected_wires = []

func delete_gate() -> void:
	disconnect_wires()
	queue_free()

func handle_radial_menu_selection(id: String, position: Vector2):
	match id:
		'idx_0':	#Clear wiring
			disconnect_wires()
		'idx_1':	#Info/Help
			pass
		'idx_2':	#Sell gate
			delete_gate()
		'idx_3':	#Cancel
			pass
