extends PanelContainer
class_name ActionElementalContainer

@onready var _title: Label = $MarginContainer/HBoxContainer/VBoxContainer/Title
@onready var current_value: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/CurrentValue
@onready var element_button: TextureButton = $MarginContainer/HBoxContainer/ElementButton

@export var title: String = 'Elemental do Ataque'
@export var icon: Texture2D
@export var icon_hover: Texture2D
@export var icon_pressed: Texture2D
@export var icon_focused: Texture2D
@export var action: CombatActions.List

func _ready() -> void:
	_title.text = title
	element_button.texture_normal = icon
	element_button.texture_hover = icon_hover
	element_button.texture_pressed = icon_pressed
	element_button.texture_focused = icon_focused
	current_value.text = get_status()

func get_status() -> String:
	var lvl = 0
	var elemental = 'None'
	
	#usar 'action' pra saber em q slot está
	return elemental+' Nv.'+str(lvl)
