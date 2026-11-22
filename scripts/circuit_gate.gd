extends Area2D

@export var type: Gates.Type
const gate_scene := preload("uid://vyyk4mr2crhe")
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var output: Area2D = $Output
const RADIAL_MENU = preload("uid://iopwhmejcr8b")
##Not ideal, but circuit_gate can only be created as a Sandbox's grandchild
@onready var sandbox: Node2D = $"./../.."
@onready var outline_sprite: Sprite2D = $Outline
@onready var fill_sprite: Sprite2D = $Fill
const INPUT_TERMINAL = preload("uid://dp56i4t15i1de")
@export var input_terminals: int = 4

##Stores the last dropped position inside sandbox
var last_position: Vector2
##Inputs and output array
var connectors: Array[Node2D]
##Gate's internal input nodes
var input_nodes: Array[Node2D]
##Signals beign inputed in top-down order
var input_values: Array[bool]
var connected_wires: Array
var was_pressed: bool = false
var cursor_offset: Vector2
var original_scale: Vector2 = Vector2.ZERO
var gate_hover: bool = false
var terminal_hover: bool = false

func _ready() -> void:
	add_terminals()
	EventBus.gate_added_to_sandbox.emit(type)

func _process(delta):
	output.set_active(calculate_output())
	handle_drag()
	if check_submit_requirements():
		outline_sprite.hide() 
		fill_sprite.show()
	else:
		outline_sprite.show() 
		fill_sprite.hide()
	
	#if terminal_hover:
		#Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	#elif gate_hover:
		#Input.set_default_cursor_shape(Input.CURSOR_DRAG)
	#else:
		#Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed :
			if is_topmost_gate_at(get_global_mouse_position()):
				get_viewport().set_input_as_handled()
				cursor_offset = get_global_mouse_position() - global_position
				DragManager.drag_gate(self)
				DragManager.original_node.global_position = get_tree().current_scene.get_global_mouse_position() - cursor_offset
	
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		open_radial_menu()

func open_radial_menu() -> void:
	var radial_menu = RADIAL_MENU.instantiate()
	radial_menu.set_items(Global.gate_options)
	radial_menu.set_center_ring_text(Gates.Type.keys()[type])
	radial_menu.item_selected.connect(handle_radial_menu_selection)
	get_tree().current_scene.add_child(radial_menu)
	var m = get_tree().current_scene.get_global_mouse_position()
	radial_menu.open_menu(m)
	get_viewport().set_input_as_handled()

##Leave value empty to reset the scale to it's default
func scale_gate(value: Vector2 = Vector2.ZERO):
	if original_scale == Vector2.ZERO:
		original_scale = scale
		scale *= value
	elif value != Vector2.ZERO:
		scale = original_scale * value
	else:
		scale = original_scale
		original_scale = Vector2.ZERO

func handle_drag() -> void:
	if DragManager.am_i_dragged(self):
		DragManager.original_node.global_position = get_tree().current_scene.get_global_mouse_position() - cursor_offset
		var is_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		if was_pressed && !is_pressed:
			DragManager.drop_gate(sandbox.cursor_in)
		was_pressed = is_pressed

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

func add_terminals() -> void:
	var terminal
	for i in range(input_terminals):
		terminal = INPUT_TERMINAL.instantiate()
		v_box_container.add_child(terminal)
		connectors.append(terminal.get_child(0))
		if type == Gates.Type.NOT:
			break
	input_nodes = connectors.duplicate()
	connectors.append(output)

#func map_terminals():
	#for child in v_box_container.get_children():
		#if child.name == "Spacing":
			#continue
		#connectors.append(child.get_child(0))
	#input_nodes = connectors.duplicate()
	#connectors.append(output)

func get_bit_from_execution_sequence(execution_number: int, bit_idx: int) -> bool:
	var bin = Global.dec_to_bin(execution_number)
	return bool(int(str(bin).substr(bit_idx, 1)))

func precalculate_output() -> Array[bool]:
	var inputs: Array[Array]= []
	var sequence_bits: Array[int]
	for inp in input_nodes:
		if inp.connected_gate != null:
			if inp.connected_gate.owner.owner && inp.connected_gate.owner.owner.name.to_lower() == "gameinputmanager":
				var sequence = Global.circuit_editor.execution_sequence
				sequence_bits = []
				for ex in sequence:
					sequence_bits.append(!!get_bit_from_execution_sequence(ex, inp.connected_gate.owner.get_index()))
				inputs.append(sequence_bits.duplicate())
			else:
				inputs.append(inp.connected_gate.owner.precalculate_output())
	
	var parcial_result := []
	var result := []
	for bit in inputs[0].size():
		parcial_result = []
		for i in inputs:
			parcial_result.append(i[bit])
		result.append(apply_gate_logic(parcial_result))
	return result

func calculate_output() -> bool:
	input_values = []
	for inp in input_nodes:
		if inp.connected_gate != null:
			input_values.append(inp.connected_gate.is_active)
	return apply_gate_logic(input_values)

func apply_gate_logic(_input_values: Array) -> bool:
	match type:
		Gates.Type.AND:
			if !_input_values:
				return false
			for i in _input_values:
				if !i:
					return false
			return true
		Gates.Type.OR:
			for i in _input_values:
				if i:
					return true
			return false
		Gates.Type.NOT:
			if !_input_values:
				return true
			return !_input_values[0]
		Gates.Type.NAND:
			if !_input_values:
				return true
			for i in _input_values:
				if !i:
					return true
			return false
		Gates.Type.NOR:
			for i in _input_values:
				if i:
					return false
			return true
		Gates.Type.XOR:
			var count = 0
			for i in _input_values:
				if i:
					count += 1
			
			if count > 1:
				return false
			return true
		Gates.Type.XNOR:
			var count = 0
			for i in _input_values:
				if i:
					count += 1
			
			if count == 1:
				return false
			return true
	
	return false

func disconnect_wires() -> void:
	while connected_wires.size() != 0:
		connected_wires[0].self_delete()

func delete_gate() -> void:
	disconnect_wires()
	EventBus.gate_removed_from_sandbox.emit(type)
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

func disconnect_wire(wire: Node2D):
	connected_wires.erase(wire)

func check_submit_requirements() -> bool:
	var sum = 0
	for input in input_nodes:
		if input.connected_gate != null:
			sum += 1
	if output.connections.size() == 0:
		return false
	if type == Gates.Type.NOT:
		return sum == 1
	else:
		return sum >= 2
