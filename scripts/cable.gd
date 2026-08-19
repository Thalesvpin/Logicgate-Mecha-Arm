extends Node2D
class_name Wire2D

## Fio 2D que liga dois objetos com uma curva suave (estilo "cabo" de node graph).
## SEM física, SEM simulação — é uma curva Bézier recalculada a cada frame,
## então segue os objetos instantaneamente e nunca sofre efeito de gravidade.


## Os dois objetos que o fio conecta.
var point_a: Node2D
var point_b: Node2D
var point_c: Node2D
const LINE_POINT_C = preload("uid://d3cka70ni1duu")

## O quanto a curva "estica" para os lados, em fração da distância entre os
## pontos (0 = linha reta, 0.5 = curva bem pronunciada, como no Blueprint).
@export_range(0.0, 1.0, 0.01) var curve_strength: float = 0.5

## Direção para a qual a curva se estica em cada ponta.
## Ex: (1,0) faz sair para a direita de point_a e chegar pela direita em point_b
## (efeito clássico de cabo de node graph, veja a imagem de referência).
@export var direction_a: Vector2 = Vector2.RIGHT
@export var direction_b: Vector2 = Vector2.LEFT

@export var width: float = 4.0
#@export var color: Color = Color(0.65, 0.35, 0.9)

var _line: Line2D
var is_active: bool = false

func _ready() -> void:
	_line = Line2D.new()
	_line.width = width
	_line.default_color = Color('red')
	#_line.default_color = Color(randf(),randf(),randf())
	_line.joint_mode = Line2D.LINE_JOINT_ROUND
	_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	_line.antialiased = true
	add_child(_line)

func _process(_delta: float) -> void:
	if point_a != null && point_b != null:
		_update_curve()
	
	handle_drag()
	check_input_value()

func handle_drag() -> void:
	if point_c:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			point_c.position = get_global_mouse_position()
		else:
			if (Global.circuit_editor.hovered_pin == null) || \
					(point_a != point_c && Global.circuit_editor.hovered_pin.type.to_lower() == "output") || \
					(point_b != point_c && Global.circuit_editor.hovered_pin.type.to_lower() == "input") || \
					(point_a != point_c && Global.circuit_editor.hovered_pin.owner == point_a.owner) || \
					(point_b != point_c && Global.circuit_editor.hovered_pin.owner == point_b.owner) || \
					(Global.circuit_editor.hovered_pin.type.to_lower() == "input" && Global.circuit_editor.hovered_pin.connected_gate != null):
				self_delete()
				return
			
			var point
			if (point_a == point_c):
				set_point_a(Global.circuit_editor.hovered_pin)
				point = point_a
			if (point_b == point_c):
				set_point_b(Global.circuit_editor.hovered_pin)
				point = point_b
			
			if point.owner is Area2D:
				point.owner.connected_wires.append(self)
			else:
				point.connected_wires.append(self)
	
	if !point_c:
		if point_a && point_b == null:
			set_point_c()
			point_b = point_c
		if point_b && point_a == null:
			set_point_c()
			point_a = point_c

func set_point_a(node: Node2D):
	point_a = node
	if point_b && point_c:
		point_b.connected_gate = point_a
		set_point_c(true)

func set_point_b(node: Node2D):
	point_b = node
	node.unplug_wire.connect(unplug)
	if point_a && point_c:
		point_b.connected_gate = point_a
		set_point_c(true)

func set_point_c(reset: bool = false):
	if reset:
		point_c.queue_free()
		point_c = null
		return
	point_c = LINE_POINT_C.instantiate()
	point_c.position = get_global_mouse_position()
	Global.circuit_editor.wire_layer.add_child(point_c)

func reset_point_b():
	point_b.connected_gate = null
	point_b.owner.disconnect_wire(self)
	point_b.unplug_wire.disconnect(unplug)
	point_b = null

func unplug():
	print('UNPLUG')
	reset_point_b()

func check_input_value() -> void:
	set_active(point_a.is_active)
	
	if is_active:
		_line.default_color = Color("green")
	if !is_active:
		_line.default_color = Color("red")
	
func dragged_point_position(connector: Node2D):
	var gate := DragManager.original_node as Node2D
	var sandbox := get_tree().current_scene.find_child("Sandbox") as Node2D
	
	# offset do connector em relação ao gate (não muda durante o arrasto)
	var connector_in_gate := gate.global_transform.affine_inverse() * connector.global_transform.origin
	
	# onde o gate deveria estar: mouse no espaço do Sandbox
	var gate_at_mouse := sandbox.get_global_mouse_position()
	var gate_xform := gate.global_transform
	gate_xform.origin = gate_at_mouse
	var connector_global := gate_xform * connector_in_gate
	return to_local(connector_global)

func _update_curve() -> void:
	var p0: Vector2
	var p3: Vector2
	if DragManager.dragging && (DragManager.original_node == point_a.owner || DragManager.original_node == point_b.owner):
		if DragManager.original_node == point_a.owner:
			p0 = dragged_point_position(point_a)
			p3 = to_local(point_b.global_position)
		if DragManager.original_node == point_b.owner:
			p0 = to_local(point_a.global_position)
			p3 = dragged_point_position(point_b)
	else:
		p0 = to_local(point_a.global_position)
		p3 = to_local(point_b.global_position)
	
	var dist := p0.distance_to(p3)
	var offset := dist * curve_strength
	
	var curve := Curve2D.new()
	# out do primeiro ponto e in do segundo ponto controlam a curvatura
	curve.add_point(p0, Vector2.ZERO, direction_a.normalized() * offset)
	curve.add_point(p3, direction_b.normalized() * offset, Vector2.ZERO)
	
	_line.points = curve.get_baked_points()

func set_active(value: bool):
	is_active = value

func self_delete():
	if point_b != point_c:
		point_b.connected_gate = null
		if point_b.owner is Area2D:
			point_b.owner.connected_wires.erase(self)
		else:
			point_b.connected_wires.erase(self)
	
	if point_a != point_c:
		if point_a.owner is Area2D:
			point_a.owner.connected_wires.erase(self)
		else:
			point_a.connected_wires.erase(self)
	
	queue_free()
