extends Button

@onready var normal: Control = $Normal
@onready var hover: Control = $Hover
@onready var _pressed: Control = $Pressed
@onready var _disabled: Control = $Disabled

func _ready() -> void:
	disable(disabled)

func disable(value: bool = true):
	disabled = value
	if value: 
		_disabled.show()
	else:
		_disabled.hide()


func _on_mouse_entered() -> void:
	normal.hide()
	hover.show()
	_pressed.hide()
	_disabled.hide()

func _on_mouse_exited() -> void:
	normal.show()
	hover.hide()
	_pressed.hide()
	_disabled.hide()

func _on_button_down() -> void:
	normal.hide()
	hover.hide()
	_pressed.show()
	_disabled.hide()

func _on_button_up() -> void:
	normal.hide()
	hover.show()
	_pressed.hide()
	_disabled.hide()
