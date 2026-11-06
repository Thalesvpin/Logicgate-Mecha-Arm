extends PanelContainer

@onready var price_label: Label = $MarginContainer/VBoxContainer/PanelContainer2/Price

@export var base_price = 100
@export var start_price = 200
var price: int
var idx: int = 3

func _ready() -> void:
	EventBus.open_shop.connect(reset)
	price = start_price

func reset() -> void:
	idx = 3
	price = start_price
	price_label.text = str(price)

func fib(n: int) -> int:
	var a := 0
	var b := 1
	for i in n:
		var tmp := a + b
		a = b
		b = tmp
	return a

func _on_texture_button_button_up() -> void:
	if Global.run_stats.player_stats[Stats.List.CURRENT_MONEY] >= price:
		var ef = AddMoneyEffect.new()
		ef.amount -= price
		ef.apply()
		idx += 1
		price = fib(idx) * base_price
		price_label.text = str(price)
		EventBus.reroll_shop.emit()
