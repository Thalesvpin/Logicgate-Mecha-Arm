extends PanelContainer

@onready var health_bar: TextureProgressBar = $Health/HealthBar
@onready var health_counter: Label = $Health/HealthCounter

@onready var shield_vertical_l_bar: TextureProgressBar = $Shield/ShieldVerticalLBar
@onready var shield_vertical_r_bar: TextureProgressBar = $Shield/ShieldVerticalRBar
@onready var shield_curve_l_bar: TextureProgressBar = $Shield/ShieldCurveLBar
@onready var shield_curve_r_bar: TextureProgressBar = $Shield/ShieldCurveRBar
@onready var shield_horizontal_l_bar: TextureProgressBar = $Shield/ShieldHorizontalLBar
@onready var shield_horizontal_r_bar: TextureProgressBar = $Shield/ShieldHorizontalRBar
@onready var shield_counter: Label = $Shield/ShieldCounter

@export var max_health: int = 100
##Must be converted to % in the graph display
var current_health_value: int

@export var max_shield: int = 100
##Must be converted to % in the graph display
var current_shield_value: int

func set_health_value(value: int) -> void:
	@warning_ignore("integer_division")
	var percentage = (value/max_health)*100
	health_bar.value = percentage
	health_counter.text = str(value)

func add_to_health(value: int) -> void:
	current_health_value += value
	current_health_value = max(current_health_value, max_health)
	set_health_value(current_health_value)

func subtract_from_health(value: int) -> void:
	current_health_value -= value
	current_health_value = max(current_health_value, 0)
	set_health_value(current_health_value)

func set_shield_value(value: int) -> void:
	@warning_ignore("integer_division")
	var percentage = (value/max_shield)*100
	shield_vertical_l_bar.value = percentage
	shield_vertical_r_bar.value = percentage
	shield_curve_l_bar.value = percentage
	shield_curve_r_bar.value = percentage
	shield_horizontal_l_bar.value = percentage
	shield_horizontal_r_bar.value = percentage
	shield_counter.text = str(value)

func add_to_shield(value: int) -> void:
	current_shield_value += value
	current_shield_value = max(current_shield_value, max_shield)
	set_shield_value(current_shield_value)

func subtract_from_shield(value: int) -> void:
	current_shield_value -= value
	current_shield_value = max(current_shield_value, 0)
	set_shield_value(current_shield_value)
