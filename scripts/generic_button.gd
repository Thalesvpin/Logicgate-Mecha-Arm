extends Button

@onready var normal: Control = $Normal
@onready var hover: Control = $Hover
@onready var _pressed: Control = $Pressed

func _on_mouse_entered() -> void:
	normal.hide()
	hover.show()
	_pressed.hide()

func _on_mouse_exited() -> void:
	normal.show()
	hover.hide()
	_pressed.hide()

func _on_button_down() -> void:
	normal.hide()
	hover.hide()
	_pressed.show()

func _on_button_up() -> void:
	normal.hide()
	hover.show()
	_pressed.hide()
