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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		print(Global.circuit_editor.hovered_pin)

func _process(_delta: float) -> void:
	if point_a != null && point_b != null:
		_update_curve()
	
	if point_c:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			point_c.position = get_global_mouse_position()
		else:
			if (Global.circuit_editor.hovered_pin == null) || \
					(point_a != point_c && Global.circuit_editor.hovered_pin.type.to_lower() == "output") || \
					(point_b != point_c && Global.circuit_editor.hovered_pin.type.to_lower() == "input") || \
					(point_a != point_c && Global.circuit_editor.hovered_pin.owner == point_a.owner) || \
					(point_b != point_c && Global.circuit_editor.hovered_pin.owner == point_b.owner):
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
				point.owner.connected_wires.append(_line)
			else:
				point.connected_wires.append(_line)
	
	if !point_c:
		if point_a && point_b == null:
			set_point_c()
			point_b = point_c
		if point_b && point_a == null:
			set_point_c()
			point_a = point_c
	
	check_input_value()

func set_point_c(reset: bool = false):
	if reset:
		point_c.queue_free()
		point_c = null
		return
	point_c = LINE_POINT_C.instantiate()
	point_c.position = get_global_mouse_position()
	Global.circuit_editor.wire_layer.add_child(point_c)

func set_point_a(node: Node2D):
	point_a = node
	if point_b && point_c:
		point_b.connected_gate = point_a
		set_point_c(true)

func set_point_b(node: Node2D):
	point_b = node
	if point_a && point_c:
		point_b.connected_gate = point_a
		set_point_c(true)

func connect_to_cursor():
	pass

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
			point_b.owner.connected_wires.erase(_line)
		else:
			point_b.connected_wires.erase(_line)
	
	if point_a != point_c:
		if point_a.owner is Area2D:
			point_a.owner.connected_wires.erase(_line)
		else:
			point_a.connected_wires.erase(_line)
	
	queue_free()





































#extends Node2D
#class_name Wire2D
### Fio 2D que liga dois objetos com uma curva suave (estilo "cabo" de node graph).
### SEM física, SEM simulação — é recalculado a cada frame,
### então segue os objetos instantaneamente e nunca sofre efeito de gravidade.
#
### Os dois objetos que o fio conecta.
#var point_a: Node2D
#var point_b: Node2D
#
### O quanto a curva "estica" para os lados, em fração da distância entre os
### pontos (0 = linha reta, 0.5 = curva bem pronunciada, como no Blueprint).
#@export_range(0.0, 1.0, 0.01) var curve_strength: float = 0.5
#
### Direção para a qual a curva se estica em cada ponta.
#@export var direction_a: Vector2 = Vector2.RIGHT
#@export var direction_b: Vector2 = Vector2.LEFT
#@export var width: float = 4.0
#var tipo_de_cabo = 0
#
#var _line: Line2D
#var is_active: bool = false
#var rand: float
#
#func add_rand(p0, p3, mid) -> float:
	#if mid+rand > p3.x:
		#rand = randf_range(-rand, rand)
		#print('novo rand: ', rand)
		#return add_rand(p0, p3, mid)
	#return rand
#
#func _ready() -> void:
	##rand = randf_range(-100, 100)
#
	#var min_step := int(ceil(float(-150) / 30.0))
	#var max_step := int(floor(float(150) / 30.0))
	#rand = randi_range(min_step, max_step) * 30
#
#
#
	#_line = Line2D.new()
	#_line.width = width
	#_line.default_color = Color('red')
	#_line.joint_mode = Line2D.LINE_JOINT_ROUND
	#_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	#_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	#_line.antialiased = true
	#add_child(_line)
#
#func _process(_delta: float) -> void:
	#if point_a != null and point_b != null:
		#if tipo_de_cabo == 0:
			#_update_curve()
		#else:
			#_update_orthogonal()
#
	#check_input_value()
#
#func check_input_value() -> void:
	#set_active(point_a.is_active)
#
	#if is_active:
		#_line.default_color = Color("green")
	#if !is_active:
		#_line.default_color = Color("red")
#
#func dragged_point_position(connector: Node2D):
	#var gate := DragManager.original_node as Node2D
	#var sandbox := get_tree().current_scene.find_child("Sandbox") as Node2D
#
	#var connector_in_gate := gate.global_transform.affine_inverse() * connector.global_transform.origin
#
	#var gate_at_mouse := sandbox.get_global_mouse_position()
	#var gate_xform := gate.global_transform
	#gate_xform.origin = gate_at_mouse
	#var connector_global := gate_xform * connector_in_gate
	#return to_local(connector_global)
#
### Calcula p0 e p3 (levando em conta o drag ativo) e devolve como array [p0, p3].
#func _get_endpoints() -> Array:
	#var p0: Vector2
	#var p3: Vector2
	#if DragManager.dragging && (DragManager.original_node == point_a.owner || DragManager.original_node == point_b.owner):
		#if DragManager.original_node == point_a.owner:
			#p0 = dragged_point_position(point_a)
			#p3 = to_local(point_b.global_position)
		#if DragManager.original_node == point_b.owner:
			#p0 = to_local(point_a.global_position)
			#p3 = dragged_point_position(point_b)
	#else:
		#p0 = to_local(point_a.global_position)
		#p3 = to_local(point_b.global_position)
	#return [p0, p3]
#
#func _update_curve() -> void:
	#var ends := _get_endpoints()
	#var p0: Vector2 = ends[0]
	#var p3: Vector2 = ends[1]
#
	#var dist := p0.distance_to(p3)
	#var offset := dist * curve_strength
#
	#var curve := Curve2D.new()
	#curve.add_point(p0, Vector2.ZERO, direction_a.normalized() * offset)
	#curve.add_point(p3, direction_b.normalized() * offset, Vector2.ZERO)
#
	#_line.points = curve.get_baked_points()
#
### Roteamento ortogonal: no máximo 3 segmentos (retas puramente horizontais/verticais),
### respeitando o eixo de saída de cada ponta (direction_a / direction_b).
#func _update_orthogonal() -> void:
	#var ends := _get_endpoints()
	#var p0: Vector2 = ends[0]
	#var p3: Vector2 = ends[1]
#
	#var a_horizontal: bool = abs(direction_a.x) >= abs(direction_a.y)
	#var b_horizontal: bool = abs(direction_b.x) >= abs(direction_b.y)
#
	#var points: PackedVector2Array
#
	#if a_horizontal and b_horizontal:
		## Z horizontal: sai reto, quebra no meio em X, entra reto.
		#var mid_x := lerpf(p0.x, p3.x, 0.5)
		#mid_x = lerpf(p0.x+add_rand(p0,p3,mid_x), p3.x, 0.5)
		#points = [p0, Vector2(mid_x, p0.y), Vector2(mid_x, p3.y), p3]
#
	#elif (not a_horizontal) and (not b_horizontal):
		## Z vertical: sai reto, quebra no meio em Y, entra reto.
		#var mid_y := lerpf(p0.y, p3.y, 0.5)
		#points = [p0, Vector2(p0.x, mid_y), Vector2(p3.x, mid_y), p3]
#
	#elif a_horizontal and (not b_horizontal):
		## L: sai na horizontal, entra na vertical -> quebra em (p3.x, p0.y)
		#points = [p0, Vector2(p3.x, p0.y), p3]
#
	#else:
		## L: sai na vertical, entra na horizontal -> quebra em (p0.x, p3.y)
		#points = [p0, Vector2(p0.x, p3.y), p3]
#
	#_line.points = points
#
#func set_active(value: bool):
	#is_active = value
