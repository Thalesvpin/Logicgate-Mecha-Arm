extends Camera2D
@onready var circuit_editor: PanelContainer = $"../../../.."

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var rect: RectangleShape2D = collision_shape_2d.shape
var camera_drag: bool = false
const X: int = 0
const Y: int = 1
@export var zoom_factor: float = 0.1
##Parameters x and y will be used as:
##[br]
##X limit: -x to x
##[br]
##Y limit: -y to y
@export var area_limit: Vector2 = Vector2(1000, 1000)

func _ready() -> void:
	area_limit = get_viewport_rect().size*1000
	anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER

func _process(delta: float) -> void:
	update_shape_to_viewport()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			camera_drag = event.pressed
	
	if event is InputEventMouseMotion && camera_drag:
		if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			camera_drag = false
			return
		
		var new_range: Vector2 = position - event.relative / zoom
		var new_limit = (circuit_editor.size/zoom)/2
		
		if new_range.x <= area_limit.x-new_limit.x && new_range.x >= new_limit.x-area_limit.x:
			position.x = new_range.x
		if new_range.y <= area_limit.y-new_limit.y && new_range.y >= new_limit.y-area_limit.y:
			position.y = new_range.y
	
	if event.is_action_pressed("scroll_up"):
		zoom += Vector2(zoom_factor, zoom_factor)
		#print('zoom: ', collision_shape_2d.shape.size)
		is_out_of_bounds(position)
		is_out_of_bounds(position)
	
	if event.is_action_pressed("scroll_down"):
		if zoom - Vector2(zoom_factor, zoom_factor) > Vector2(0.3, 0.3):
			zoom -= Vector2(zoom_factor, zoom_factor)
			is_out_of_bounds(position)
			is_out_of_bounds(position)

func is_out_of_bounds(curr_pos):
	var viewport = (get_viewport_rect().size/zoom)/2
	if curr_pos.x > area_limit.x-viewport.x:
		position.x = area_limit.x-viewport.x
	if curr_pos.x < viewport.x-area_limit.x:
		position.x = viewport.x-area_limit.x
	
	if curr_pos.y > area_limit.y-viewport.y:
		position.y = area_limit.y-viewport.y
	if curr_pos.y < viewport.y-area_limit.y:
		position.y = viewport.y-area_limit.y

func update_shape_to_viewport() -> void:
	var viewport_size := get_viewport_rect().size
	var visible_size := viewport_size / zoom
	collision_shape_2d.shape.size = visible_size
	collision_shape_2d.position = Vector2.ZERO
