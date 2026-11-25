extends PanelContainer

@onready var name_label: RichTextLabel = $MarginContainer/VBoxContainer/Header/Name
@onready var description: RichTextLabel = $MarginContainer/VBoxContainer/Description
@onready var description_corrupted: RichTextLabel = $MarginContainer/VBoxContainer/DescriptionCorrupted
@onready var type: RichTextLabel = $MarginContainer/VBoxContainer/Header/Type
@onready var context: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer/Context
@onready var power: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer/Power

var _implant: Implant

func _ready() -> void:
	apply()

func config(implant: Implant) -> void:
	_implant = implant

func apply() -> void:
	name_label.text = _implant.name
	description.text = '\t'+_implant.description
	type.text = Implant.Type.keys()[_implant.type]
	context.text = 'Venda: %d' % int(Implant.PRICES[_implant.rarity]*0.4)
	power.text = Global.Rarity.keys()[_implant.rarity]
	if _implant.corrupted:
		description_corrupted.show()
		description_corrupted.text = '\t'+_implant.description_corrupted
	
