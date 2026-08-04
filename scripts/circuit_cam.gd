extends Camera2D

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var rect: RectangleShape2D = collision_shape_2d.shape
var camera_drag: bool = false
@export var zoom_factor = 0.1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			camera_drag = event.pressed
	
	if event is InputEventMouseMotion && camera_drag:
		position -= event.relative
	
	if event.is_action_pressed("scroll_up"):
		zoom += Vector2(zoom_factor, zoom_factor)
		print('+', zoom)
		_update_shape_to_viewport()
	
	if event.is_action_pressed("scroll_down"):
		zoom -= Vector2(zoom_factor, zoom_factor)
		print('-', zoom)
		_update_shape_to_viewport()

func _update_shape_to_viewport() -> void:
	var viewport_size := get_viewport_rect().size
	var visible_size := viewport_size / zoom
	collision_shape_2d.shape.size = visible_size

	collision_shape_2d.position = Vector2.ZERO
