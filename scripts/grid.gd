extends Node2D

const STEP = 32

func _draw():
	var limite = 4000
	draw_circle(Vector2.ZERO, 5, 'red')
	for x in range(-limite, limite, STEP):
		draw_line(
			Vector2(x,-limite),
			Vector2(x,limite),
			Color(0.0, 0.0, 0.0, 0.08)
		)
	
	for y in range(-limite, limite, STEP):
		draw_line(
			Vector2(-limite,y),
			Vector2(limite,y),
			Color(0.0, 0.0, 0.0, 0.08)
		)
