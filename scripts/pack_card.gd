extends PanelContainer
class_name Pack

@onready var price_label: RichTextLabel = $MarginContainer/VBoxContainer/PanelContainer2/Price
@onready var title: RichTextLabel = $MarginContainer/VBoxContainer/PanelContainer/Title
@onready var name_label: RichTextLabel = $MarginContainer/VBoxContainer/Name
@onready var background: PanelContainer = $Background
@onready var icon_holder: PanelContainer = $MarginContainer/VBoxContainer/IconHolder
const PACK_BACKGROUND_TEMPLATE = "uid://baptggk6ejtp7"
const PACK_ICON_TEMPLATE = "uid://0ysjvolv0vqk"
@export var packs_price: Dictionary[Type, int]
@export var implants_amount: Dictionary[Type, int]
@export var choices_amount: Dictionary[Type, int]
@export var pack_title: Dictionary[Type, String]
@export var pack_name: Dictionary[Type, String]
@export var pack_icon: Dictionary[Type, PackedScene]
@export var pack_background: Dictionary[Type, PackedScene]

enum Content {ANY, TECH_MOD, BIO_HACK, CORRUPTED}
#enum Type2 {BIG, MINI, CORRUPTED}
enum Type {MINI_MIX, BIG_MIX, CORRUPTED_MIX, MINI_TM, BIG_TM, MINI_BH, BIG_BH}

var price: int
var items_amount: int = 3
var _choices_amount: int = 1
var content: Content
var drawn: Array[Implant]
var _theme
var bg_shader: ShaderMaterial

func _ready() -> void:
	#bg_shader = background.material.duplicate() as ShaderMaterial
	#background.material = bg_shader
	pass

func randomize_pack() -> void:
	var chance = Global.random.next() % 100
	if chance < 15:
		_theme = Type.MINI_MIX
	elif chance < 30:
		_theme = Type.MINI_TM
	elif chance < 45:
		_theme = Type.MINI_BH
	elif chance < 57:
		_theme = Type.BIG_MIX
	elif chance < 69:
		_theme = Type.BIG_TM
	elif chance < 81:
		_theme = Type.BIG_BH
	else:
		_theme = Type.CORRUPTED_MIX
	
	price = packs_price[_theme]
	items_amount = implants_amount[_theme]
	_choices_amount = choices_amount[_theme]
	title.text = pack_title[_theme]
	name_label.text = pack_name[_theme]
	price_label.text = '$%d' % price
	background.add_child(pack_background[_theme].instantiate())
	icon_holder.add_child(pack_icon[_theme].instantiate())
	randomize_options()

func randomize_options() -> void:
	if [Type.MINI_MIX, Type.BIG_MIX].has(_theme):
		for i in range(items_amount):
			drawn.append(Global.get_random_implant(drawn))
	if [Type.MINI_TM, Type.BIG_TM].has(_theme):
		for i in range(items_amount):
			drawn.append(Global.get_random_implant(drawn, Implant.Type.TECH_MOD))
	if [Type.MINI_BH, Type.BIG_BH].has(_theme):
		for i in range(items_amount):
			drawn.append(Global.get_random_implant(drawn, Implant.Type.BIO_HACK))
	if [Type.CORRUPTED_MIX].has(_theme):
		for i in range(items_amount):
			drawn.append(Global.get_random_corrupted_implant(drawn))

func _on_buy_btn_button_up() -> void:
	if Global.run_stats.player_stats[Stats.List.CURRENT_MONEY] >= price:
		var effect = AddMoneyEffect.new()
		effect.amount = -price
		effect.apply()
		owner.chose_pack(self)
