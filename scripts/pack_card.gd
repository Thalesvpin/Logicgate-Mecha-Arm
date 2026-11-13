extends PanelContainer
class_name Pack

@onready var price_label: RichTextLabel = $MarginContainer/VBoxContainer/PanelContainer2/Price
@onready var title: RichTextLabel = $MarginContainer/VBoxContainer/PanelContainer/Title
@onready var name_label: RichTextLabel = $MarginContainer/VBoxContainer/Name
@onready var background: PanelContainer = $Background

enum Content {ANY, TECH_MOD, BIO_HACK, CORRUPTED}
enum Type {BIG, MINI, CORRUPTED}

var price: int
var items_amount: int = 3
var choices_amount: int = 1
var content: Content
var drawn: Array[Implant]
var _theme
var bg_shader: ShaderMaterial

func _ready() -> void:
	bg_shader = background.material.duplicate() as ShaderMaterial
	background.material = bg_shader

func randomize_pack() -> void:
	var chance = Global.random.next() % 100
	if chance < 45:
		_theme = Type.MINI
		price = 200
		items_amount = 2
		choices_amount = 1
		title.text = 'PACOTE'
		title.add_theme_color_override('default_color', Color.BLACK)
		name_label.text = 'minipack\n.zip'
		price_label.text = '$%d' % price
		bg_shader.set_shader_parameter('start_color', LivePalette.SHOP.PACKOUTLINE)
		var style: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
		style.border_color = LivePalette.SHOP.PACKOUTLINE
		add_theme_stylebox_override("panel", style)
	elif chance < 75:
		_theme = Type.BIG
		price = 300
		items_amount = 5
		choices_amount = 2
		title.text = 'PACOTÃO'
		title.add_theme_color_override('default_color', Color.BLACK)
		name_label.text = 'megapack\n.zip'
		price_label.text = '$%d' % price
		bg_shader.set_shader_parameter('start_color', LivePalette.SHOP.PACKOUTLINE)
		var border_style: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
		border_style.border_color = LivePalette.SHOP.PACKOUTLINE
		add_theme_stylebox_override("panel", border_style)
	else:
		_theme = Type.CORRUPTED
		price = 300
		items_amount = 3
		choices_amount = 1
		title.text = 'P̴͉̘̞̃̓̀Ą̴̛̯͈̋̌͑̈C̵̮͓̣̭̋̽̔̕ͅO̷̜̟̓̔́T̶̛̰͓̦͂̏Ę̷͎̎́'
		title.add_theme_color_override('default_color', LivePalette.GLOBAL.REDDARK)
		name_label.text = 'pack_corrompido'
		price_label.text = '$%d' % price
		bg_shader.set_shader_parameter('start_color', LivePalette.GLOBAL.REDHEALTH)
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
