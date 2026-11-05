extends PanelContainer
class_name Pack

enum Content {ANY, TECH_MOD, BIO_HACK, CORRUPTED}

@export var price: int
@export var items_amount: int = 3
@export var choices_amount: int = 1
@export var content: Content
var chosen: Array[Implant]

func randomize_options() -> void:
	var type: Implant.Type
	chosen = []
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
		chosen.append(Global.get_random_implant(chosen, type))

func _on_buy_btn_button_up() -> void:
	var effect = AddMoneyEffect.new()
	effect.amount = -price
	effect.apply()
	owner.chose_pack(self)
