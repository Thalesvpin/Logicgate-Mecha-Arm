extends PanelContainer

@onready var sell_overlay: Control = $SellOverlay

func _ready() -> void:
	Global.gates_selector = self

func _process(delta: float) -> void:
	if DragManager.dragging:
		if get_global_rect().has_point(get_viewport().get_mouse_position()):
			Global.sell_gate = true
		else:
			Global.sell_gate = false
