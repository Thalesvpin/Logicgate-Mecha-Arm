#@tool
extends PanelContainer

@onready var modifier_texture: TextureRect = $MarginContainer/RarityOutline/HBoxContainer/PanelContainer/ModifierTexture
@onready var modifier_name_label: Label = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/Name
@onready var h_separator_2: HSeparator = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/PanelContainer/HSeparator2
@onready var rarity_texture: TextureRect = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/RarityAndCorruptedHolder/RarityTexture
@onready var corrupted_texture: TextureRect = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/RarityAndCorruptedHolder/CorruptedTexture
@onready var activation_uses: TextureRect = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/ActivatorHolder/ActivationUses
@onready var activator_btn: TextureButton = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/ActivatorHolder/ActivatorBtn
@onready var compact_version: GridContainer = $MarginContainer/RarityOutline/HBoxContainer/CompactVersion
@onready var extended_versions: VBoxContainer = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions
@onready var rarity_outline: PanelContainer = $MarginContainer/RarityOutline
@onready var activator_holder: HBoxContainer = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/ActivatorHolder
@onready var activation_count: Label = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/ActivatorHolder/ActivationUses/ActivationCount
@onready var rarity_texture_compact: TextureRect = $MarginContainer/RarityOutline/HBoxContainer/CompactVersion/RarityTextureCompact
@onready var corrupted_texture_compact: TextureRect = $MarginContainer/RarityOutline/HBoxContainer/CompactVersion/CorruptedTextureCompact
@onready var activation_uses_compact: TextureRect = $MarginContainer/RarityOutline/HBoxContainer/CompactVersion/ActivationUsesCompact
@onready var activation_count_compact_label: Label = $MarginContainer/RarityOutline/HBoxContainer/CompactVersion/ActivationUsesCompact/ActivationCountCompact
@onready var activator_btn_compact: TextureButton = $MarginContainer/RarityOutline/HBoxContainer/CompactVersion/ActivatorBtnCompact

const BIOHACK_BG_STYLEBOX_FLAT = preload("uid://dm33npd24kf11")
const TECHMOD_BG_STYLEBOX_FLAT = preload("uid://dlegihcropccf")
const ACTIVATOR = preload("uid://bb84g5o4b08f3")
const RARITY_PLACEHOLDER = preload("uid://b8l68f41218q5")

@export var resource: Modifier
var type: int
var texture: Texture2D
var modifier_name: String
var rarity: Global.Rarity
var is_corrupted: bool
var is_consumable: bool = false
var uses_amount: int

var is_loaded: bool = false

func _ready() -> void:
	is_loaded = true
	load_resource()
	apply_resource()
	_on_resized()

func load_resource() -> void:
	type = resource.type
	modifier_name = resource.name
	rarity = resource.rarity
	is_corrupted = resource.corrupted
	is_consumable = resource.consumable
	uses_amount = resource.uses_amount
	texture = resource.texture

func apply_resource() -> void:
	add_theme_stylebox_override("panel", BIOHACK_BG_STYLEBOX_FLAT if type else TECHMOD_BG_STYLEBOX_FLAT)
	rarity_outline.add_theme_stylebox_override("panel", rarity_stylebox())
	modifier_texture.texture = texture
	modifier_name_label.text = modifier_name
	modifier_name_label.add_theme_color_override('font_color', LivePalette.BIOHACK.MODTEXT if type else LivePalette.TECHMOD.MODTEXT)
	rarity_texture.texture = Global.rarity_textures[rarity as Global.Rarity]
	rarity_texture_compact.texture = Global.rarity_textures[rarity as Global.Rarity]
	
	if is_corrupted:
		corrupted_texture.show()
		corrupted_texture_compact.show()
	else:
		corrupted_texture.hide()
		corrupted_texture_compact.hide()
	if is_consumable:
		activator_holder.show()
		activation_count.text = str(uses_amount)
		activation_uses_compact.show()
		activator_btn_compact.show()
		activation_count_compact_label.text = str(uses_amount)
	else:
		activator_holder.hide()
		activation_uses_compact.hide()
		activator_btn_compact.hide()

func rarity_stylebox() -> StyleBox:
	var new_style = StyleBoxFlat.new()
	new_style.set_border_width_all(3)
	new_style.border_color = Color(LivePalette.RARITY[Global.Rarity.keys()[rarity]])
	new_style.bg_color = Color(0,0,0,0)
	return new_style

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
			print('deveria: ', size.x)
			set_template(2)
		if size.x <= 278:
			print('ue: ', size.x)
			set_template(3)
