extends PanelContainer

@onready var bio_hack_main: ColorRect = $PanelContainer/BioHackMain
@onready var tech_mod_main: ColorRect = $PanelContainer/TechModMain
@onready var implant_card: PanelContainer = $MarginContainer/VBoxContainer/ImplantCard
@onready var implant_type_animated: PanelContainer = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/ImplantTypeAnimated



const ICON_MINI_BIOHACKS = preload("uid://byrpiwaihcjtv")
const ICON_MINI_TECHMODS = preload("uid://s0uva87wtgws")

var rarity: Global.Rarity

func _ready() -> void:
	pass

func load_implant(implant: Implant) -> void:
	set_rarity(implant.rarity)
	implant_card.resource = implant
	implant_card.load_resource()
	if implant.type == Implant.Type.TECH_MOD:
		implant_type_animated.set_techmod()
		bio_hack_main.visible = false
		tech_mod_main.visible = true
	if implant.type == Implant.Type.BIO_HACK:
		implant_type_animated.set_biohack()
		bio_hack_main.visible = true
		tech_mod_main.visible = false

func set_rarity(rarity) -> void:
	var style: StyleBoxFlat = get_theme_stylebox('panel').duplicate()
	add_theme_stylebox_override('panel', style)
	style.border_color = LivePalette.RARITY[Global.Rarity.keys()[rarity]]

func _on_choose_btn_button_up() -> void:
	var implant = implant_card.resource
	var type = implant.type
	EventBus.pack_item_chosen.emit()
	if type == Implant.Type.TECH_MOD && Global.implant_manager.active_tech_mods.size() < 5:
		EventBus.tech_mod_added.emit(implant)
		hide()
		return
	if type == Implant.Type.BIO_HACK && Global.implant_manager.active_bio_hacks.size() < 5:
		EventBus.bio_hack_added.emit(implant)
		hide()
		return
	print('limite de ', Implant.Type.keys()[type], ' atingido')
