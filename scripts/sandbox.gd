extends Node2D

@onready var gate_layer: Node2D = $GateLayer
@onready var wire_layer: Node2D = $WireLayer
@onready var drag_layer: Node2D = $DragLayer

var was_pressed := false

func _process(delta):
	update_drag()
	if DragManager.dragging:
		var is_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		if was_pressed && !is_pressed:
			end_drag()
		was_pressed = is_pressed

func update_drag():
	if !DragManager.dragging:
		return
	
	if DragManager.preview == null:
		DragManager.preview = DragManager.dragged_scene.instantiate()
		drag_layer.add_child(DragManager.preview)
	
	DragManager.preview.global_position = get_global_mouse_position()

func end_drag():
	DragManager.dragging = false
	
	if DragManager.preview == null:
		return
	
	drag_layer.remove_child(DragManager.preview)
	gate_layer.add_child(DragManager.preview)
	DragManager.preview = null
