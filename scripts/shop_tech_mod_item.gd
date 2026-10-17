extends PanelContainer

@onready var price_label: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer/PriceContainer/MarginContainer/Price
@onready var price_container: PanelContainer = $MarginContainer/VBoxContainer/HBoxContainer/PriceContainer
@onready var buy_btn: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/BuyBtn
@onready var implant_card: PanelContainer = $MarginContainer/VBoxContainer/ImplantCard
@onready var background: PanelContainer = $Background

const TECHMOD_TEST = preload("uid://3gmr422layic")

var implant: Implant = TECHMOD_TEST
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

func set_outline_color(node: Node) -> void:
	var style: StyleBoxFlat = node.get_theme_stylebox("panel").duplicate()
	style.border_color = Color(LivePalette.RARITY[Global.Rarity.keys()[implant.rarity]])
	node.add_theme_stylebox_override("panel", style)

func get_price() -> void:
	price = 100
	price_label.text = '$'+str(price)

func get_rarity() -> void:
	rarity = implant.rarity
	set_outline_color(self)
	set_outline_color(price_container)
	background.material = background.material.duplicate()
	background.material.set_shader_parameter('end_color', Color(LivePalette.RARITY[Global.Rarity.keys()[rarity]]))
	#get_theme_stylebox("panel").border_color = LivePalette.RARITY.BY_NAME[Global.Rarity.keys()[rarity]]
	#price_container.get_theme_stylebox("panel").border_color = LivePalette.RARITY.BY_NAME[Global.Rarity.keys()[rarity]]

func _on_buy_btn_button_up() -> void:
	if Global.implant_manager.active_tech_mods.size() >= 5:
		print('limite de tech mods atingido')
		return
	var curr_money = Global.run_stats.player_stats[Stats.List.CURRENT_MONEY]
	if curr_money >= price:
		var effect = AddMoneyEffect.new()
		effect.amount = -price
		effect.apply()
		#Global.implant_manager.add_tech_mod(implant)
		EventBus.tech_mod_added.emit(implant)
		buy_btn.disabled = true
		hide()
