extends PanelContainer

@onready var sell_overlay: Control = $SubViewportContainer/SubViewport/PanelContainer/SellOverlay
@onready var tokens_label: Label = $SubViewportContainer/SubViewport/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/TitleBar/TokensLabel
@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer
@onready var margin_container: MarginContainer = $SubViewportContainer/SubViewport/PanelContainer/MarginContainer

const RADIAL_MENU = preload("uid://iopwhmejcr8b")

func _ready() -> void:
	Global.gates_selector = self
	EventBus.gate_removed_from_sandbox.connect(gate_sold)
	set_tokens_label()
	sub_viewport_container.custom_minimum_size = margin_container.get_combined_minimum_size()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.is_released():
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
		'idx_0':	#Clear all wires
			var gate_layer = Global.circuit_editor.gate_layer
			for gate in gate_layer.get_children():
				gate.disconnect_wires()
			for wire in Global.circuit_editor.wire_layer.get_children():
				wire.self_delete()
		'idx_1':	#Info/Help
			pass
		'idx_2':	#Sell all gates
			var gate_layer = Global.circuit_editor.gate_layer
			for gate in gate_layer.get_children():
				gate.delete_gate()
		'idx_3':	#Cancel
			pass

func set_tokens_label() -> void:
	tokens_label.text = str(Global.run_stats.player_stats[Stats.List.CURRENT_TOKENS])+'/'+str(Global.run_stats.player_stats[Stats.List.MAX_TOKENS_AMOUNT])

func spend_tokens(amount: int) -> bool:
	var curr = Global.run_stats.player_stats[Stats.List.CURRENT_TOKENS]
	var max = Global.run_stats.player_stats[Stats.List.MAX_TOKENS_AMOUNT]
	
	if curr - amount < 0:
		return false
	Global.run_stats.player_stats[Stats.List.CURRENT_TOKENS] -= amount
	set_tokens_label()
	return true

func add_tokens(amount: int) -> void:
	var curr = Global.run_stats.player_stats[Stats.List.CURRENT_TOKENS]
	var max = Global.run_stats.player_stats[Stats.List.MAX_TOKENS_AMOUNT]
	
	if curr + amount > max:
		Global.run_stats.player_stats[Stats.List.CURRENT_TOKENS] = max
	else:
		Global.run_stats.player_stats[Stats.List.CURRENT_TOKENS] += amount
	set_tokens_label()

func gate_sold(type: Gates.Type) -> void:
	add_tokens(Global.run_stats.gates_price[type])

func gate_bought(type: Gates.Type) -> void:
	spend_tokens(Global.run_stats.gates_price[type])
