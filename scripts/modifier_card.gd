
extends PanelContainer

@onready var modifier_texture: TextureRect = $MarginContainer/PanelContainer/HBoxContainer/PanelContainer/ModifierTexture
@onready var modifier_name: Label = $MarginContainer/PanelContainer/HBoxContainer/ExtendedVersions/Name
@onready var h_separator_2: HSeparator = $MarginContainer/PanelContainer/HBoxContainer/ExtendedVersions/PanelContainer/HSeparator2
@onready var rarity_texture: TextureRect = $MarginContainer/PanelContainer/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/RarityAndCorruptedHolder/RarityTexture
@onready var corrupted_texture: TextureRect = $MarginContainer/PanelContainer/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/RarityAndCorruptedHolder/CorruptedTexture
@onready var activation_uses: TextureRect = $MarginContainer/PanelContainer/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/ActivatorHolder/ActivationUses
@onready var activator_btn: TextureButton = $MarginContainer/PanelContainer/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/ActivatorHolder/ActivatorBtn
@onready var compact_version: GridContainer = $MarginContainer/PanelContainer/HBoxContainer/CompactVersion
@onready var extended_versions: VBoxContainer = $MarginContainer/PanelContainer/HBoxContainer/ExtendedVersions

const ACTIVATOR = preload("uid://bb84g5o4b08f3")
const RARITY_PLACEHOLDER = preload("uid://b8l68f41218q5")
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

var is_loaded: bool = false

func _ready() -> void:
	is_loaded = true
	#modifier_texture.texture = texture
	#modifier_name.text = _name
	#rarity_texture.texture = 

func _validate_property(property: Dictionary) -> void:
	if property.name == "uses_amount" and not is_consumable:
		property.usage &= ~PROPERTY_USAGE_EDITOR


func set_template(template: int):
	if template == 1:
		activator_btn.texture_normal = ACTIVATOR
		compact_version.hide()
		extended_versions.show()
	if template == 2:
		activator_btn.texture_normal = RARITY_PLACEHOLDER
		compact_version.hide()
		extended_versions.show()
	if template == 3:
		compact_version.show()
		extended_versions.hide()

func _on_resized() -> void:
	if is_loaded:
		if size.x > 325:
			set_template(1)
		if size.x <= 325:
			set_template(2)
		if size.x <= 278:
			set_template(3)
