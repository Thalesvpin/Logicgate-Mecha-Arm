extends PanelContainer

@onready var price_container: PanelContainer = $MarginContainer/VBoxContainer/HBoxContainer/PriceContainer
@onready var price_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/PriceContainer/Price
@onready var buy_btn: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/BuyBtn
@onready var implant_card: PanelContainer = $MarginContainer/VBoxContainer/ImplantCard

const BIOHACK_TEST = preload("uid://dd06rohyycdlt")

var implant: Implant = BIOHACK_TEST
var price: int = 0
var rarity: Global.Rarity

func _ready() -> void:
	set_up()

func set_up() -> void:
	show()
	set_implant()
	get_price()
	get_rarity()

func set_implant() -> void:
	implant_card.resource = implant
	implant_card.load_resource()

func get_price() -> void:
	pass

func get_rarity() -> void:
	rarity = implant.rarity
	get_theme_stylebox("panel").border_color = LivePalette.RARITY.BY_NAME[Global.Rarity.keys()[rarity]]
	price_container.get_theme_stylebox("panel").border_color = LivePalette.RARITY.BY_NAME[Global.Rarity.keys()[rarity]]

func _on_buy_btn_button_up() -> void:
	if Global.implant_manager.active_bio_hacks.size() >= 5:
		return
	var curr_money = Global.run_stats.player_stats[Stats.List.CURRENT_MONEY]
	if curr_money >= price:
		var effect = AddMoneyEffect.new()
		effect.amount = -price
		effect.apply()
		Global.implant_manager.add_bio_hack(implant)
		buy_btn.disabled = true
		hide()
