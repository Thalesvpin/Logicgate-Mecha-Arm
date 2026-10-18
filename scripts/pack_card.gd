extends PanelContainer
class_name Pack

@export var price: int
var items_amount: int = 3
var choices_amount: int = 1
var chosen: Array[Implant]

func randomize_options() -> void:
	chosen = []
	for i in range(items_amount):
		chosen.append(Global.get_random_implant(chosen))

func _on_buy_btn_button_up() -> void:
	#var effect = AddMoneyEffect.new()
	#effect.amount = -price
	#effect.apply()
	owner.chose_pack(self)
