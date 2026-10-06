extends PanelContainer

@onready var healthbar: ProgressBar = $Health/Healthbar
@onready var health_label: Label = $Health/Healthbar/HealthLabel
#@onready var shield_bar: ColorRect = $Shield/ShieldBar
@onready var shield_bar_5: ColorRect = $Shield/ShieldHolder/ShieldBar5
@onready var shield_bar_4: ColorRect = $Shield/ShieldHolder/ShieldBar4
@onready var shield_bar_3: ColorRect = $Shield/ShieldHolder/ShieldBar3
@onready var shield_bar_2: ColorRect = $Shield/ShieldHolder/ShieldBar2
@onready var shield_bar_1: ColorRect = $Shield/ShieldHolder/ShieldBar1
@onready var shield_label_1: Label = $Shield/ShieldHolder/ShieldLabelsHolder/ShieldLabel1
@onready var shield_label_2: Label = $Shield/ShieldHolder/ShieldLabelsHolder/ShieldLabel2
@onready var shield_label_3: Label = $Shield/ShieldHolder/ShieldLabelsHolder/ShieldLabel3
@onready var shield_label_4: Label = $Shield/ShieldHolder/ShieldLabelsHolder/ShieldLabel4


@export var tween_duration: float = 0.4

var shield_bars: Array[ColorRect]
var shield_labels: Array[Label]

func _ready() -> void:
	Global.player_stats_bar = self
	config_vars()
	set_values()
	#EventBus.damage_taken.connect(take_damage)
	#EventBus.healed.connect(heal)

func config_vars() -> void:
	shield_bars = [shield_bar_1, shield_bar_2, shield_bar_3, shield_bar_4, shield_bar_5]
	shield_labels = [shield_label_1, shield_label_2, shield_label_3, shield_label_4]

func animate(value: int) -> void:
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(healthbar, 'value', value, tween_duration)
	tween.tween_method(func(v): health_label.text = str(int(v)), int(health_label.text), value, tween_duration)

func take_damage(amount: int):
	var result
	if healthbar.value - amount >= 0:
		result = healthbar.value - amount
	else:
		result = 0
	
	animate(result)
	#healthbar.value = result
	#health_label.text = str(result)

func heal(amount: int):
	var result
	if healthbar.value + amount <= Global.run_stats.player_stats[Stats.List.MAX_HEALTH]:
		result = healthbar.value + amount
	else:
		result = Global.run_stats.player_stats[Stats.List.MAX_HEALTH]
	
	animate(result)
	#healthbar.value = result
	#health_label.text = str(result)

func repair_shield(amount: int) -> void:
	var curr_shield = Stats.List.CURRENT_SHIELD
	var curr_shield_count = Stats.List.CURRENT_SHIELD_COUNT
	var max_shield = Stats.List.MAX_SHIELD
	var max_shield_count = Stats.List.MAX_SHIELD_COUNT
	var new_value = Global.run_stats.player_stats[curr_shield] + amount
	
	if new_value > Global.run_stats.player_stats[max_shield]:
		if Global.run_stats.player_stats[curr_shield_count] == Global.run_stats.player_stats[max_shield_count]:
			Global.run_stats.player_stats[curr_shield] = Global.run_stats.player_stats[max_shield]
			return
		new_value -= Global.run_stats.player_stats[max_shield]
		Global.run_stats.player_stats[curr_shield] = new_value
		Global.run_stats.player_stats[curr_shield_count] += 1

func set_values() -> void:
	healthbar.value = Global.run_stats.player_stats[Stats.List.CURRENT_HEALTH]
	health_label.text = str(Global.run_stats.player_stats[Stats.List.CURRENT_HEALTH])
	adjust_shield()
	

func adjust_shield():
	var shield_count = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT]
	var curr_shield = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD]
	var shield_size = Global.run_stats.player_stats[Stats.List.MAX_SHIELD]
	var curr_shield_percent = 0
	if shield_count > 0:
		curr_shield_percent = curr_shield/(shield_count*shield_size)
	
	shield_bar_1.hide()
	shield_bar_2.hide()
	shield_bar_3.hide()
	shield_bar_4.hide()
	shield_bar_5.hide()
	match shield_count:
		0:
			pass
		1:
			shield_bar_1.show()
			shield_bar_1.material.set_shader_parameter('pour_fill_amount', curr_shield_percent)
		2:
			shield_bar_2.show()
			shield_bar_2.material.set_shader_parameter('pour_fill_amount', curr_shield_percent)
		3:
			shield_bar_3.show()
			shield_bar_3.material.set_shader_parameter('pour_fill_amount', curr_shield_percent)
		4:
			shield_bar_4.show()
			shield_bar_5.show()
			var curr_4
			var curr_5
			if curr_shield > shield_size * 3:
				curr_4 = 1
				curr_5 = (curr_shield-(shield_size * 3))/shield_size
			else:
				curr_4 = curr_shield/(shield_size*3)
				curr_5 = 0
			shield_bar_4.material.set_shader_parameter('pour_fill_amount', curr_4)
			shield_bar_5.material.set_shader_parameter('pour_fill_amount', curr_5)
	
	for i in shield_count:
		shield_labels[i].show()
		if curr_shield > shield_size:
			shield_labels[i].text = str(shield_size)
			curr_shield -= shield_size
		else:
			shield_labels[i].text = str(curr_shield)
