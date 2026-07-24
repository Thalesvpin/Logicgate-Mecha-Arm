extends Panel

var type = "AND"
@export var icon = preload("res://icon.svg")

@export var gate_scene : PackedScene

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				DragManager.dragging = true
				DragManager.dragged_scene = gate_scene
				DragManager.gate_type = type

#Ensure the selected gate will display over everything
func _get_drag_data(at_position):
	var root := Control.new()
	var preview := TextureRect.new()
	preview.texture = icon
	root.add_child(preview)
	preview.position = -icon.get_size() / 2.0
	set_drag_preview(root)
	
	return type
