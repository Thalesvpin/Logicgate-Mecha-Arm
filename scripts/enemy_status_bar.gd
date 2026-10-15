extends PanelContainer
#region BACKGROUND
@onready var background: TextureRect = $Background

@export var background_texture: Texture2D
@export var defeat_background_texture: Texture2D
#endregion

#region HEALTH
@onready var health_bar: TextureProgressBar = $Health/HealthBar
@onready var health_counter: RichTextLabel = $Health/HealthBarPlaceholder/HealthCounter
@onready var health_bar_placeholder: ProgressBar = $Health/HealthBarPlaceholder
var health_aux: int
#endregion

#region SHIELD
@onready var shield_vertical_l_bar: TextureProgressBar = $Shield/ShieldVerticalLBar
@onready var shield_vertical_r_bar: TextureProgressBar = $Shield/ShieldVerticalRBar
@onready var shield_curve_l_bar: TextureProgressBar = $Shield/ShieldCurveLBar
@onready var shield_curve_r_bar: TextureProgressBar = $Shield/ShieldCurveRBar
@onready var shield_horizontal_l_bar: TextureProgressBar = $Shield/ShieldHorizontalLBar
@onready var shield_horizontal_r_bar: TextureProgressBar = $Shield/ShieldHorizontalRBar
@onready var shield_counter: RichTextLabel = $Shield/ShieldCounter

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
@export var progress_bar_tween_duration: float = 0.8
var original_position: Vector2
var stats
var config: EnemyConfig

func _ready() -> void:
	original_position = position
	#EventBus.enemy_defeated.connect(defeated)
	background.texture = background_texture
	config = enemy.config
	#update()
	setup()

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("test"):
		#subtract_from_shield(10)

func setup() -> void:
	health_bar_placeholder.value = 100
	health_counter.text = str(config.health)

func update(animate: bool = false) -> void:
	stats = enemy.stats
	set_health_value(stats[Stats.List.CURRENT_HEALTH], animate)
	set_shield_value(stats[Stats.List.CURRENT_SHIELD])
	
	#set_afflicted_element(stats[Stats.List.CURRENT_AFFLICTED_ELEMENT], enemy['afflicted_count'])
	#set_elemental(stats[Stats.List.CURRENT_ELEMENTALS], enemy['elemental_lvl'])

func enemy_swap() -> void:
	var tween = create_tween()
	tween.set_parallel(false)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, 'position', Vector2(position.x, original_position.y-size.y), swap_bar_tween_duration)
	
	tween.tween_callback(update)
	
	tween.tween_property(self, 'position', Vector2(position.x, original_position.y), swap_bar_tween_duration)

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

func progress_bar_animation(bar: Node, new_value: int, callback = null) -> void:
	var tween = create_tween()
	tween.set_parallel(false)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(bar, 'value', new_value, progress_bar_tween_duration)
	if callback != null:
		tween.tween_callback(callback)

func set_health_value(value: float, animate: bool = false) -> void:
	var percentage = (value/stats[Stats.List.MAX_HEALTH])*100
	progress_bar_animation(health_bar, percentage)
	#health_bar.value = percentage
	#health_counter.text = str(value)
	health_aux = int(value)
	if animate:
		progress_bar_animation(health_bar_placeholder, percentage, alive_check)
	else:
		health_bar_placeholder.value = percentage
		alive_check()
	
	#health_bar_placeholder.value = percentage

func alive_check():
	if health_aux <= 0:
		defeated(enemy)
	else:
		revive(enemy)

func add_to_health(value: int) -> void:
	stats[Stats.List.CURRENT_HEALTH] += value
	stats[Stats.List.CURRENT_HEALTH] = max(stats[Stats.List.CURRENT_HEALTH], stats[Stats.List.MAX_HEALTH])
	set_health_value(stats[Stats.List.CURRENT_HEALTH])

func subtract_from_health(value: int) -> void:
	stats[Stats.List.CURRENT_HEALTH] -= value
	stats[Stats.List.CURRENT_HEALTH] = max(stats[Stats.List.CURRENT_HEALTH], 0)
	set_health_value(stats[Stats.List.CURRENT_HEALTH])

func set_shield_value(value: float) -> void:
	var percentage = (value/stats[Stats.List.MAX_SHIELD])*100
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
	stats[Stats.List.CURRENT_SHIELD] += value
	stats[Stats.List.CURRENT_SHIELD] = max(stats[Stats.List.CURRENT_SHIELD], stats[Stats.List.MAX_SHIELD])
	set_shield_value(stats[Stats.List.CURRENT_SHIELD])

func subtract_from_shield(value: int) -> void:
	stats[Stats.List.CURRENT_SHIELD] -= value
	stats[Stats.List.CURRENT_SHIELD] = max(stats[Stats.List.CURRENT_SHIELD], 0)
	set_shield_value(stats[Stats.List.CURRENT_SHIELD])

#region ELEMENTAL
#rever
#func set_afflicted_label(value: int) -> void:
	#afflicted_counter_label.text = str(value)
	#check_elemental_counters()

#rever
#func add_to_afflicted(value: int, element) -> void:
	#if element == afflicted_element:
		#afflicted_counter += value
		#set_afflicted_label(afflicted_counter)

#func subtract_from_afflicted(value: int) -> void:
	#afflicted_counter -= value
	#set_afflicted_label(afflicted_counter)
#
#func set_afflicted_element(element, count: int):
	#pass
#
#func set_elemental(element, lvl: int):
	#pass
#endregion

func defeated(who) -> void:
	if who != enemy:
		return
	for child in get_children():
		if child != background:
			child.hide()
		else:
			child.texture = defeat_background_texture
	Global.combat_screen.enemy_defeated(enemy)

func revive(who) -> void:
	if who != enemy:
		return
	for child in get_children():
		if child != background:
			child.show()
		else:
			child.texture = background_texture
