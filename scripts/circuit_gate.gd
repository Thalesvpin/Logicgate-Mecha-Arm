extends Area2D

@export var type := ""

var arrastando := false

func _input_event(viewport,event,shape):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			arrastando = event.pressed

func _process(delta):
	if arrastando:
		global_position = get_global_mouse_position()
