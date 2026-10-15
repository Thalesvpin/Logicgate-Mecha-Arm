extends PanelContainer

@export var price: int


func _on_buy_btn_button_up() -> void:
	var effect = AddMoneyEffect.new()
	effect.amount = -price
	effect.apply()
