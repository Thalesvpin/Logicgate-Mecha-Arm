extends PanelContainer

@onready var price_container: PanelContainer = $MarginContainer/VBoxContainer/HBoxContainer/PriceContainer
@onready var buy_btn: Button = $MarginContainer/VBoxContainer/HBoxContainer/BuyBtn
@onready var implant_card: PanelContainer = $MarginContainer/VBoxContainer/ImplantCard
@onready var price_label: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer/PriceContainer/MarginContainer/Price
@onready var background: PanelContainer = $Control/Background

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
	set_outline_color(self)
	set_outline_color(price_container)
	set_gradient_color('gradient_texture', Color(LivePalette.RARITY[Global.Rarity.keys()[implant.rarity]]))
	set_gradient_color('outline_gradient_texture', Color(LivePalette.RARITY[Global.Rarity.keys()[implant.rarity]]))

func set_gradient_color(parameter: String, color: Color) -> void:
	var param = background.material.get_shader_parameter(parameter)
	var gradient = param.gradient
	gradient.colors = [color, Color.BLACK]
	

func set_outline_color(node: Node) -> void:
	var style: StyleBoxFlat = node.get_theme_stylebox("panel").duplicate()
	style.border_color = Color(LivePalette.RARITY[Global.Rarity.keys()[implant.rarity]])
	node.add_theme_stylebox_override("panel", style)

func get_price() -> void:
	price = Implant.PRICES[rarity]
	price_label.text = '$%d' % price

func get_rarity() -> void:
	rarity = implant.rarity
	#get_theme_stylebox("panel").border_color = LivePalette.RARITY.BY_NAME[Global.Rarity.keys()[rarity]]
	#price_container.get_theme_stylebox("panel").border_color = LivePalette.RARITY.BY_NAME[Global.Rarity.keys()[rarity]]

func _on_buy_btn_button_up() -> void:
	if Global.implant_manager.active_bio_hacks.size() >= 5:
		print('limite de bio hacks atingido')
		return
	var curr_money = Global.run_stats.player_stats[Stats.List.CURRENT_MONEY]
	if curr_money >= price:
		var effect = AddMoneyEffect.new()
		effect.amount = -price
		effect.apply()
		#Global.implant_manager.add_bio_hack(implant)
		EventBus.bio_hack_added.emit(implant)
		buy_btn.disabled = true
		hide()
