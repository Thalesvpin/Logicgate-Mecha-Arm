extends PanelContainer

@onready var modifier_texture: TextureRect = $MarginContainer/RarityOutline/HBoxContainer/PanelContainer/ModifierTexture
@onready var modifier_name_label: Label = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/Name
@onready var h_separator_2: HSeparator = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/PanelContainer/HSeparator2
@onready var rarity_texture: TextureRect = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/RarityAndCorruptedHolder/RarityTexture
@onready var corrupted_texture: TextureRect = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/RarityAndCorruptedHolder/CorruptedTexture
@onready var activation_uses: TextureRect = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/ActivatorHolder/ActivationUses
@onready var activator_btn: Button = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/ActivatorHolder/ActivatorBtn
@onready var compact_version: GridContainer = $MarginContainer/RarityOutline/HBoxContainer/CompactVersion
@onready var extended_versions: VBoxContainer = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions
@onready var rarity_outline: PanelContainer = $MarginContainer/RarityOutline
@onready var activator_holder: HBoxContainer = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/ActivatorHolder
@onready var activation_count: RichTextLabel = $MarginContainer/RarityOutline/HBoxContainer/ExtendedVersions/PanelContainer2/HBoxContainer/ActivatorHolder/ActivationUses/ActivationCount
@onready var rarity_texture_compact: TextureRect = $MarginContainer/RarityOutline/HBoxContainer/CompactVersion/RarityTextureCompact
@onready var corrupted_texture_compact: TextureRect = $MarginContainer/RarityOutline/HBoxContainer/CompactVersion/CorruptedTextureCompact
@onready var activation_uses_compact: TextureRect = $MarginContainer/RarityOutline/HBoxContainer/CompactVersion/ActivationUsesCompact
@onready var activation_count_compact_label: RichTextLabel = $MarginContainer/RarityOutline/HBoxContainer/CompactVersion/ActivationUsesCompact/ActivationCountCompact
@onready var activator_btn_compact: Button = $MarginContainer/RarityOutline/HBoxContainer/CompactVersion/ActivatorBtnCompact
@onready var sell_overlay: PanelContainer = $SellOverlay
@onready var confirm_btn: Button = $SellOverlay/VBoxContainer/HBoxContainer/ConfirmBtn
@onready var cancel_btn: Button = $SellOverlay/VBoxContainer/HBoxContainer/CancelBtn
@onready var confirm_sell_label: RichTextLabel = $SellOverlay/VBoxContainer/HBoxContainer2/ConfirmSellLabel
@onready var activation_count_compact: RichTextLabel = $MarginContainer/RarityOutline/HBoxContainer/CompactVersion/ActivationUsesCompact/ActivationCountCompact

const BIOHACK_BG_STYLEBOX_FLAT = preload("uid://dm33npd24kf11")
const TECHMOD_BG_STYLEBOX_FLAT = preload("uid://dlegihcropccf")
const ACTIVATOR = preload("uid://bb84g5o4b08f3")
const RARITY_PLACEHOLDER = preload("uid://b8l68f41218q5")
const RADIAL_MENU = preload("uid://iopwhmejcr8b")
enum Type {TECH_MOD, BIO_HACK}

@export var tooltip := preload("uid://bus2twh8u8sjx")
var resource: Implant
var type: int
var texture: Texture2D
var modifier_name: String
var rarity: Global.Rarity
var is_corrupted: bool
var is_consumable: bool = false
var uses_amount: int

var is_owned: bool = false
var is_loaded: bool = false

func _ready() -> void:
	is_loaded = true
	#load_resource()
	#apply_resource()
	_on_resized()

func load_resource() -> void:
	type = resource.type
	modifier_name = resource.name
	rarity = resource.rarity
	is_corrupted = resource.corrupted
	is_consumable = resource.consumable
	uses_amount = resource.uses_amount
	texture = resource.texture
	apply_resource()

func apply_resource() -> void:
	add_theme_stylebox_override("panel", BIOHACK_BG_STYLEBOX_FLAT if type else TECHMOD_BG_STYLEBOX_FLAT)
	rarity_outline.add_theme_stylebox_override("panel", rarity_stylebox())
	modifier_texture.texture = texture
	modifier_name_label.text = modifier_name
	modifier_name_label.add_theme_color_override('font_color', LivePalette.BIOHACK.MODTEXT if type else LivePalette.TECHMOD.MODTEXT)
	rarity_texture.texture = Global.rarity_textures[rarity as Global.Rarity]
	rarity_texture_compact.texture = Global.rarity_textures[rarity as Global.Rarity]
	tooltip_text = resource.description
	
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
		compact_version.hide()
		extended_versions.show()
	if template == 2:
		compact_version.hide()
		extended_versions.show()
	if template == 3:
		compact_version.show()
		extended_versions.hide()

func open_radial_menu() -> void:
	var radial_menu = RADIAL_MENU.instantiate()
	if is_owned:
		radial_menu.set_items(Global.implant_options)
	else:
		return
		radial_menu.set_items(Global.shop_implant_options)
	radial_menu.set_center_ring_text(Gates.Type.keys()[type])
	radial_menu.item_selected.connect(handle_radial_menu_selection)
	get_tree().current_scene.add_child(radial_menu)
	var m = get_tree().current_scene.get_global_mouse_position()
	radial_menu.open_menu(m)
	get_viewport().set_input_as_handled()

func handle_radial_menu_selection(id: String, position: Vector2):
	match id:
		'idx_0':	#Info/Help
			print('ajuda')
			pass
		'idx_1':	#Sell implant
			sell_overlay.show()
			confirm_sell_label.text = 'Vender por $%d?' % get_sell_value()
		'idx_2':	#Cancel
			print('cancela')
			pass
		'idx_3':	#
			pass

func get_sell_value() -> int:
	return Implant.PRICES[resource.rarity]*0.4

func sell() -> void:
	var ef = AddMoneyEffect.new()
	ef.amount = get_sell_value()
	ef.apply()
	if type == Type.TECH_MOD:
		Global.implant_manager.remove_tech_mod(self)
	if type == Type.BIO_HACK:
		Global.implant_manager.remove_bio_hack(self)

func activate() -> void:
	if uses_amount > 0:
		uses_amount -= 1
		activation_count.text = str(uses_amount)
		activation_count_compact.text = str(uses_amount)
		for module in resource.config:
			for effect in module.effect:
				effect.apply()
	if uses_amount == 0:
		if type == Type.TECH_MOD:
			Global.implant_manager.remove_tech_mod(self)
		if type == Type.BIO_HACK:
			Global.implant_manager.remove_bio_hack(self)

func _make_custom_tooltip(for_text: String) -> Object:
	var _tooltip = tooltip.instantiate()
	_tooltip.config(for_text)
	return _tooltip

func _on_resized() -> void:
	if is_loaded:
		if size.x > 325:
			set_template(1)
		if size.x <= 325:
			set_template(2)
		if size.x <= 278:
			set_template(3)

func _on_activator_btn_button_up() -> void:
	activate()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT && event.is_released():
			open_radial_menu()

func _on_confirm_btn_button_up() -> void:
	sell()

func _on_cancel_btn_button_up() -> void:
	sell_overlay.hide()

func _on_activator_btn_compact_button_up() -> void:
	activate()
