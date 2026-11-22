extends PanelContainer
class_name Pack

@onready var price_label: RichTextLabel = $MarginContainer/VBoxContainer/PanelContainer2/Price
@onready var title: RichTextLabel = $MarginContainer/VBoxContainer/PanelContainer/Title
@onready var name_label: RichTextLabel = $MarginContainer/VBoxContainer/Name
@onready var background: PanelContainer = $Background
@onready var icon_holder: PanelContainer = $MarginContainer/VBoxContainer/IconHolder
const PACK_BACKGROUND_TEMPLATE = "uid://baptggk6ejtp7"
const PACK_ICON_TEMPLATE = "uid://0ysjvolv0vqk"
@export var packs_price: Dictionary[Type2, int]
@export var implants_amount: Dictionary[Type2, int]
@export var choices_amount: Dictionary[Type2, int]
@export var pack_title: Dictionary[Type2, String]
@export var pack_name: Dictionary[Type2, String]
@export var pack_icon: Dictionary[Type2, PackedScene]
@export var pack_background: Dictionary[Type2, PackedScene]

enum Content {ANY, TECH_MOD, BIO_HACK, CORRUPTED}
enum Type {BIG, MINI, CORRUPTED}
enum Type2 {MINI_MIX, BIG_MIX, CORRUPTED_MIX, MINI_TM, BIG_TM, MINI_BH, BIG_BH}

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
		_theme = Type2.MINI_MIX
	elif chance < 30:
		_theme = Type2.MINI_TM
	elif chance < 45:
		_theme = Type2.MINI_BH
	elif chance < 57:
		_theme = Type2.BIG_MIX
	elif chance < 69:
		_theme = Type2.BIG_TM
	elif chance < 81:
		_theme = Type2.BIG_BH
	else:
		_theme = Type2.CORRUPTED_MIX
	
	price = packs_price[_theme]
	items_amount = implants_amount[_theme]
	_choices_amount = choices_amount[_theme]
	title.text = pack_title[_theme]
	name_label.text = pack_name[_theme]
	price_label.text = '$%d' % price
	background.add_child(pack_background[_theme].instantiate())
	icon_holder.add_child(pack_icon[_theme].instantiate())

func randomize_pack2() -> void:
	var chance = Global.random.next() % 100
	if chance < 45:
		_theme = Type.MINI
		price = 200
		items_amount = 2
		_choices_amount = 1
		title.text = 'PACOTE'
		title.add_theme_color_override('default_color', Color.BLACK)
		name_label.text = 'minipack\n.zip'
		price_label.text = '$%d' % price
		#bg_shader.set_shader_parameter('start_color', LivePalette.SHOP.PACKOUTLINE)
		var style: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
		style.border_color = LivePalette.SHOP.PACKOUTLINE
		add_theme_stylebox_override("panel", style)
	elif chance < 75:
		_theme = Type.BIG
		price = 300
		items_amount = 5
		_choices_amount = 2
		title.text = 'PACOTÃO'
		title.add_theme_color_override('default_color', Color.BLACK)
		name_label.text = 'megapack\n.zip'
		price_label.text = '$%d' % price
		#bg_shader.set_shader_parameter('start_color', LivePalette.SHOP.PACKOUTLINE)
		var border_style: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
		border_style.border_color = LivePalette.SHOP.PACKOUTLINE
		add_theme_stylebox_override("panel", border_style)
	else:
		_theme = Type.CORRUPTED
		price = 300
		items_amount = 3
		_choices_amount = 1
		title.text = 'P̴͉̘̞̃̓̀Ą̴̛̯͈̋̌͑̈C̵̮͓̣̭̋̽̔̕ͅO̷̜̟̓̔́T̶̛̰͓̦͂̏Ę̷͎̎́'
		title.add_theme_color_override('default_color', LivePalette.GLOBAL.REDDARK)
		name_label.text = 'pack_corrompido'
		price_label.text = '$%d' % price
		#bg_shader.set_shader_parameter('start_color', LivePalette.GLOBAL.REDHEALTH)
		var style: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
		style.border_color = LivePalette.GLOBAL.REDDARK
		add_theme_stylebox_override("panel", style)
	randomize_options()

func randomize_options() -> void:
	var implant_count = 0
	match _theme:
		Type.MINI:
			implant_count = 3
		Type.BIG:
			implant_count = 5
		Type.CORRUPTED:
			implant_count = 3
			for i in range(implant_count):
				drawn.append(Global.get_random_corrupted_implant(drawn))
			return
	for i in range(implant_count):
		drawn.append(Global.get_random_implant(drawn))

func randomize_options2() -> void:
	var type: Implant.Type
	drawn = []
	match type:
		Content.ANY:
			type = -1
		Content.TECH_MOD:
			type = Implant.Type.TECH_MOD
		Content.BIO_HACK:
			type = Implant.Type.BIO_HACK
		#Content.CORRUPTED:
			#type = Implant.Type
	for i in range(items_amount):
		drawn.append(Global.get_random_implant(drawn, type))

func _on_buy_btn_button_up() -> void:
	if Global.run_stats.player_stats[Stats.List.CURRENT_MONEY] >= price:
		var effect = AddMoneyEffect.new()
		effect.amount = -price
		effect.apply()
		owner.chose_pack(self)
