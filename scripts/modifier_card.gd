@tool
extends PanelContainer

@onready var modifier_texture: TextureRect = $MarginContainer/PanelContainer/HBoxContainer/PanelContainer/ModifierTexture
@onready var modifier_name: Label = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/Name
@onready var h_separator_2: HSeparator = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/HSeparator2
@onready var rarity_texture: TextureRect = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/RarityAndCorruptedHolder/RarityTexture
@onready var corrupted_texture: TextureRect = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/RarityAndCorruptedHolder/CorruptedTexture
@onready var activation_uses: TextureRect = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/ActivatorHolder/ActivationUses
@onready var activator_btn: TextureButton = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/ActivatorHolder/ActivatorBtn

enum Rarity {COMMOM, RARE, ULTRA_RARE, LEGENDARY}
@export var texture: Texture2D
@export var _name: String
@export var rarity: Rarity = Rarity.COMMOM
@export var is_corrupted: bool
##If this value is false, uses_amount will be ignored
@export var is_consumable: bool = false:
	set(value):
		is_consumable = value
		notify_property_list_changed()
##If is_consumable is false, this value will be ignored
@export var uses_amount: int
@export var background_color: Color

#func _ready() -> void:
	#modifier_texture.texture = texture
	#modifier_name.text = _name
	#rarity_texture.texture = 

func _validate_property(property: Dictionary) -> void:
	if property.name == "uses_amount" and not is_consumable:
		property.usage &= ~PROPERTY_USAGE_EDITOR
