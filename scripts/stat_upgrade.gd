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

func _ready() -> void:
	setup()
	update_value()

func upgrade() -> void:
	pass

func setup() -> void:
	_icon.texture = icon
	_title.text = title
	update_price()

func update_price() -> void:
	if upgrades == 0:
		price.text = '$ '+str(inicial_price)
	else:
		price.text = '$ '+str(inicial_price+(upgrades*amount_per_upgrade))

func get_current_price() -> int:
	return inicial_price+(upgrades*amount_per_upgrade)

func withdraw_money() -> void:
	Global.run_stats.player_stats[Stats.List.CURRENT_MONEY] -= get_current_price()
	EventBus.stat_changed.emit(Stats.List.CURRENT_MONEY)

func update_value() -> void:
	print('update_value not implemented in ', self)
