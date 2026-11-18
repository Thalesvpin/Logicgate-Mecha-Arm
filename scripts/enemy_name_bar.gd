extends Control

@onready var name_label: Label = $PanelContainer/Name
@export var swap_speed: float = 0.4

func set_display_name(_name: String) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, 'offset_transform_position:y', 45, swap_speed)
	name_label.text = _name
	tween.tween_property(self, 'offset_transform_position:y', 0, swap_speed)
