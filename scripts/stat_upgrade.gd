extends PanelContainer
class_name StatUpgrade

@onready var _icon: TextureRect = $MarginContainer/HBoxContainer/Icon
@onready var price: Label = $MarginContainer/HBoxContainer/Price
@onready var _title: Label = $MarginContainer/HBoxContainer/VBoxContainer/Title
@onready var current_value: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/CurrentValue

@export var stat: Stats.List
@export_multiline() var title: String
@export var icon: Texture2D
@export var preset_prices: Array[int]
@export var action_after_preset: PriceAction
@export var after_preset_value: int
@export var amount_per_upgrade: float
var upgrades: int = 0
var current_price: int = 0

##How much the "Run" btn must be held to submit
@export_custom(PROPERTY_HINT_NONE, "suffix: s") var hold_run_duration: float = 0.35
enum PriceAction {ADD, MULTIPLY}
var timer: float = 0.0
var holding_run: bool = false
var buy_btn: TextureButton

func _process(delta: float) -> void:
	if timer > 0:
		timer -= delta
		buy_btn.material.set_shader_parameter("progress", 1 - timer/hold_run_duration)
	if holding_run && timer <= 0:
		stop_timer()
		upgrade()

func _ready() -> void:
	setup()
	update_value()

func upgrade() -> void:
	pass

func setup() -> void:
	buy_btn = find_child('BuyButton')
	_icon.texture = icon
	_title.text = title
	update_price()

func update_price() -> void:
	if upgrades < preset_prices.size():
		current_price = preset_prices[upgrades]
	else:
		if action_after_preset == PriceAction.ADD:
			current_price += after_preset_value
		if action_after_preset == PriceAction.MULTIPLY:
			current_price *= after_preset_value
	price.text = '$ %d' % current_price

func withdraw_money() -> bool:
	if Global.run_stats.player_stats[Stats.List.CURRENT_MONEY] < current_price:
		return false
	var ef = AddMoneyEffect.new()
	ef.amount = -current_price
	ef.apply()
	return true

func update_value() -> void:
	print('update_value not implemented in ', self)

##Duration in seconds
func start_timer() -> void:
	timer = hold_run_duration
	holding_run = true

func stop_timer() -> void:
	timer = 0.0
	holding_run = false
	buy_btn.material.set_shader_parameter("progress", 1)
