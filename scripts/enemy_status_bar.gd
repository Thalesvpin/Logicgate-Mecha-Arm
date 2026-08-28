extends PanelContainer

#region HEALTH
@onready var health_bar: TextureProgressBar = $Health/HealthBar
@onready var health_counter: Label = $Health/HealthCounter

@export var max_health: int = 100
##Must be converted to % in the graph display
var current_health_value: int
#endregion

#region SHIELD
@onready var shield_vertical_l_bar: TextureProgressBar = $Shield/ShieldVerticalLBar
@onready var shield_vertical_r_bar: TextureProgressBar = $Shield/ShieldVerticalRBar
@onready var shield_curve_l_bar: TextureProgressBar = $Shield/ShieldCurveLBar
@onready var shield_curve_r_bar: TextureProgressBar = $Shield/ShieldCurveRBar
@onready var shield_horizontal_l_bar: TextureProgressBar = $Shield/ShieldHorizontalLBar
@onready var shield_horizontal_r_bar: TextureProgressBar = $Shield/ShieldHorizontalRBar
@onready var shield_counter: Label = $Shield/ShieldCounter

@export var max_shield: int = 100
##Must be converted to % in the graph display
var current_shield_value: int = 100
@export var shield_tween_duration := 0.8
#endregion

#region AFFLICTED
@onready var afflicted_number_bg: PanelContainer = $AfflictedElement/AfflictedNumberBg
@onready var afflicted_texture: TextureRect = $AfflictedElement/PanelContainer/AfflictedTexture
@onready var afflicted_counter_label: Label = $AfflictedElement/NumberBg/AfflictedCounter
var afflicted_counter: int = 0
var afflicted_element
#endregion

#region SELF ELEMENT
@onready var element_number_bg: PanelContainer = $SelfElement/ElementNumberBg
@onready var element_level: Label = $SelfElement/ElementNumberBg/ElementLevel
@onready var element_texture: TextureRect = $SelfElement/PanelContainer/ElementTexture
var element
#endregion

var enemy = null
@export var swap_bar_tween_duration: float = 0.8 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		subtract_from_shield(10)

func update() -> void:
	var tween = create_tween()
	tween.set_parallel(false)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, 'position', Vector2(position.x, position.y-size.y), swap_bar_tween_duration)
	#set_health_value(enemy['health'])
	#set_shield_value(enemy['shield'])
	#set_afflicted_element(enemy['afflicted_element'], enemy['afflicted_count'])
	#set_elemental(enemy['elemental'], enemy['elemental_lvl'])
	tween.tween_property(self, 'position', Vector2(position.x, position.y), swap_bar_tween_duration)
	

func check_elemental_counters() -> void:
	if afflicted_counter < 10:
		afflicted_number_bg.position.x = 32
		afflicted_number_bg.size.x = 10
	elif afflicted_counter < 100:
		afflicted_number_bg.position.x = 23
		afflicted_number_bg.size.x = 19
	elif afflicted_counter < 1000:
		afflicted_number_bg.position.x = 14
		afflicted_number_bg.size.x = 28

func set_health_value(value: float) -> void:
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

func set_shield_value(value: float) -> void:
	var percentage = (value/max_shield)*100
	var array = [shield_vertical_l_bar
				,shield_vertical_r_bar
				,shield_curve_l_bar
				,shield_curve_r_bar
				,shield_horizontal_l_bar
				,shield_horizontal_r_bar]
	
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	for piece in array:
		tween.tween_property(piece, "value", percentage, shield_tween_duration)
	
	tween.tween_method(func(v): shield_counter.text = str(int(v)), int(shield_counter.text), value, shield_tween_duration)

func add_to_shield(value: int) -> void:
	current_shield_value += value
	current_shield_value = max(current_shield_value, max_shield)
	set_shield_value(current_shield_value)

func subtract_from_shield(value: int) -> void:
	current_shield_value -= value
	current_shield_value = max(current_shield_value, 0)
	set_shield_value(current_shield_value)

func set_afflicted_label(value: int) -> void:
	afflicted_counter_label.text = str(value)
	check_elemental_counters()

#rever
func add_to_afflicted(value: int, element) -> void:
	if element == afflicted_element:
		afflicted_counter += value
		set_afflicted_label(afflicted_counter)

func subtract_from_afflicted(value: int) -> void:
	afflicted_counter -= value
	set_afflicted_label(afflicted_counter)

func set_afflicted_element(element, count: int):
	pass

func set_elemental(element, lvl: int):
	pass
