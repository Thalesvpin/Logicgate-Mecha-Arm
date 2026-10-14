extends PanelContainer
class_name StatUpgrade

@onready var _icon: TextureRect = $MarginContainer/HBoxContainer/Icon
@onready var price: Label = $MarginContainer/HBoxContainer/Price
@onready var _title: Label = $MarginContainer/HBoxContainer/VBoxContainer/Title
@onready var current_value: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/CurrentValue

@export var stat: Stats.List
@export var title: String
@export var icon: Texture2D
@export var inicial_price: int
@export var price_escalation: float
@export var amount_per_upgrade: float
var upgrades: int = 0

##How much the "Run" btn must be held to submit
@export_custom(PROPERTY_HINT_NONE, "suffix: s") var hold_run_duration: float = 0.35
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
	if upgrades == 0:
		price.text = '$ '+str(inicial_price)
	else:
		price.text = '$ '+str(inicial_price+(upgrades*amount_per_upgrade))

func get_current_price() -> int:
	return int(inicial_price+(upgrades*amount_per_upgrade))

func withdraw_money() -> void:
	Global.run_stats.player_stats[Stats.List.CURRENT_MONEY] -= get_current_price()
	EventBus.stat_changed.emit(Stats.List.CURRENT_MONEY)

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
