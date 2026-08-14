extends PanelContainer

@onready var sell_overlay: Control = $SellOverlay
const RADIAL_MENU = preload("uid://iopwhmejcr8b")

func _ready() -> void:
	Global.gates_selector = self

func _gui_input(event: InputEvent) -> void:
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		var radial_menu = RADIAL_MENU.instantiate()
		radial_menu.set_items(Global.inventory_options)
		radial_menu.item_selected.connect(handle_radial_menu_selection)
		get_tree().current_scene.add_child(radial_menu)
		var m = get_tree().current_scene.get_global_mouse_position()
		radial_menu.open_menu(m)
		get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	if DragManager.dragging:
		if get_global_rect().has_point(get_viewport().get_mouse_position()):
			Global.sell_gate = true
		else:
			Global.sell_gate = false

func handle_radial_menu_selection(id: String, position: Vector2):
	match id:
		'idx_0':	#Clear wiring
			var gate_layer = Global.circuit_editor.gate_layer
			for gate in gate_layer.get_children():
				gate.disconnect_wires()
		'idx_1':	#Info/Help
			pass
		'idx_2':	#Sell gate
			var gate_layer = Global.circuit_editor.gate_layer
			for gate in gate_layer.get_children():
				gate.delete_gate()
		'idx_3':	#Cancel
			pass
