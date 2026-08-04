extends PanelContainer

@onready var sell_overlay: Control = $SellOverlay

func _ready() -> void:
	Global.gates_selector = self

#func _process(delta: float) -> void:
	#for a: Button in get_children():
		#var pos := a.position
		#var mouse := get_global_mouse_position()
		#var dist := pos.distance_to(mouse)
		#
		#var s := 1.0 + maxf(0.0, 0.6 - dist / 32)
		#var scale := Vector2(s,s)
		#a.offset_transform_scale = scale
