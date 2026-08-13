extends PanelContainer

@onready var sell_overlay: Control = $SellOverlay
@onready var radial_menu: Control = $RadialMenu

func _ready() -> void:
	Global.gates_selector = self

func _gui_input(event: InputEvent) -> void:
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		radial_menu.set_items(Global.inventory_options)
		var m = get_local_mouse_position()
		# Pass the center position to open_menu as a Vector2!
		radial_menu.open_menu(m)
		# Make sure we don't handle the click again anywhere else...
		get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	if DragManager.dragging:
		if get_global_rect().has_point(get_viewport().get_mouse_position()):
			Global.sell_gate = true
		else:
			Global.sell_gate = false
