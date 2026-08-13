extends Node2D
class_name Wire2D

## Fio 2D que liga dois objetos com uma curva suave (estilo "cabo" de node graph).
## SEM física, SEM simulação — é uma curva Bézier recalculada a cada frame,
## então segue os objetos instantaneamente e nunca sofre efeito de gravidade.


## Os dois objetos que o fio conecta.
var point_a: Node2D
var point_b: Node2D

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
	print(_line.default_color)
	add_child(_line)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		set_active(!is_active)

func _process(_delta: float) -> void:
	if point_a != null and point_b != null:
		_update_curve()
	
	check_input_value()

func check_input_value() -> void:
	set_active(point_a.is_active)
	
	if is_active:
		_line.default_color = Color("green")
	if !is_active:
		_line.default_color = Color("red")
	

func _update_curve() -> void:
	var p0 := to_local(point_a.global_position)
	var p3 := to_local(point_b.global_position)
	var dist := p0.distance_to(p3)
	var offset := dist * curve_strength

	var curve := Curve2D.new()
	# out do primeiro ponto e in do segundo ponto controlam a curvatura
	curve.add_point(p0, Vector2.ZERO, direction_a.normalized() * offset)
	curve.add_point(p3, direction_b.normalized() * offset, Vector2.ZERO)

	_line.points = curve.get_baked_points()

## Chame isso se trocar point_a/point_b em tempo de execução
## (ex.: quando o jogador cria o fio clicando em dois objetos).
func setup(a: Node2D, b: Node2D) -> void:
	point_a = a
	point_b = b

func set_active(value: bool):
	is_active = value
