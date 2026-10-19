extends PanelContainer

@onready var background: ColorRect = $Mask/Background
@onready var implant_card: PanelContainer = $MarginContainer/VBoxContainer/ImplantCard

var rarity: Global.Rarity

func _ready() -> void:
	print('open ready: ', implant_card)

func load_implant(implant: Implant) -> void:
	set_rarity(implant.rarity)
	print('OPEN PACK ITEM: ', implant_card)
	implant_card.resource = implant
	implant_card.load_resource()

func set_rarity(rarity) -> void:
	var style: StyleBoxFlat = get_theme_stylebox('panel').duplicate()
	add_theme_stylebox_override('panel', style)
	style.border_color = LivePalette.RARITY[Global.Rarity.keys()[rarity]]
