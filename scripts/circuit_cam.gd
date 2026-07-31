extends Camera2D

const SPEED = 500
var camera_drag: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			camera_drag = event.pressed
	
	if event is InputEventMouseMotion && camera_drag:
		position -= event.relative

func _process(delta):
	pass
