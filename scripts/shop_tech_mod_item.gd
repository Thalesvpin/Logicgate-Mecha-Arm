extends PanelContainer

@onready var price_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/Price
@onready var price_container: PanelContainer = $MarginContainer/VBoxContainer/HBoxContainer/PriceContainer
@onready var buy_btn: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/BuyBtn
@onready var modifier_card: PanelContainer = $MarginContainer/VBoxContainer/ModifierCard

const TECHMOD_TEST = preload("uid://3gmr422layic")

var implant: Implant = TECHMOD_TEST
var price: int = 0
var rarity: Global.Rarity

func _ready() -> void:
	set_up()

func set_up() -> void:
	show()
	get_price()
	get_rarity()

func set_implant() -> void:
	modifier_card.resource = implant

func get_price() -> void:
	pass

func get_rarity() -> void:
	rarity = implant.rarity
	get_theme_stylebox("panel").border_color = LivePalette.RARITY.BY_NAME[Global.Rarity.keys()[rarity]]
	price_container.get_theme_stylebox("panel").border_color = LivePalette.RARITY.BY_NAME[Global.Rarity.keys()[rarity]]

func _on_buy_btn_button_up() -> void:
	var curr_money = Global.run_stats.player_stats[Stats.List.CURRENT_MONEY]
	if curr_money >= price:
		var effect = AddMoneyEffect.new()
		effect.amount = -price
		effect.apply()
		Global.modifier_manager.add_tech_mod(implant)
		buy_btn.disabled = true
		hide()
