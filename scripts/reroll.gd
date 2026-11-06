extends PanelContainer

@onready var price_label: Label = $MarginContainer/VBoxContainer/PanelContainer2/Price

@export var price_list: Array[int]
var price: int = 200
var idx: int = 0

func _on_texture_button_button_up() -> void:
	if Global.run_stats.player_stats[Stats.List.CURRENT_MONEY] >= price:
		var ef = AddMoneyEffect.new()
		ef.amount -= price
		ef.apply()
		idx += 1
		price = price_list[idx]
		price_label.text = str(price)
		EventBus.reroll_shop.emit()
	
