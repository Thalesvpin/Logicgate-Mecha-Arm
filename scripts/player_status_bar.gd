extends PanelContainer

@onready var healthbar: ProgressBar = $Health/Healthbar
@onready var health_label: RichTextLabel = $Health/Healthbar/HealthLabel
#@onready var shield_bar: ColorRect = $Shield/ShieldBar
@onready var shield_bar_5: ColorRect = $Shield/ShieldHolder/ShieldBar5
@onready var shield_bar_4: ColorRect = $Shield/ShieldHolder/ShieldBar4
@onready var shield_bar_3: ColorRect = $Shield/ShieldHolder/ShieldBar3
@onready var shield_bar_2: ColorRect = $Shield/ShieldHolder/ShieldBar2
@onready var shield_bar_1: ColorRect = $Shield/ShieldHolder/ShieldBar1
@onready var shield_label_1: RichTextLabel = $Shield/ShieldHolder/ShieldLabelsHolder/ShieldLabel1
@onready var shield_label_2: RichTextLabel = $Shield/ShieldHolder/ShieldLabelsHolder/ShieldLabel2
@onready var shield_label_3: RichTextLabel = $Shield/ShieldHolder/ShieldLabelsHolder/ShieldLabel3
@onready var shield_label_4: RichTextLabel = $Shield/ShieldHolder/ShieldLabelsHolder/ShieldLabel4

@export var bar_tween_duration: float
@export var tween_duration: float = 0.4

var shield_bars: Array[ColorRect]
var shield_labels: Array[RichTextLabel]
var tween

func _ready() -> void:
	Global.player_stats_bar = self
	config_vars()
	update()

func config_vars() -> void:
	shield_bars = [shield_bar_1, shield_bar_2, shield_bar_3, shield_bar_4, shield_bar_5]
	shield_labels = [shield_label_1, shield_label_2, shield_label_3, shield_label_4]

func check_health() -> void:
	if Global.run_stats.player_stats[Stats.List.CURRENT_HEALTH] == 0:
		EventBus.battle_ended.emit(false)

func animate_health(value: int) -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(healthbar, 'value', value, tween_duration)
	tween.tween_method(func(v): health_label.text = str(int(v)), int(health_label.text), value, tween_duration)
	tween.chain().tween_callback(check_health)

func take_damage(amount: int):
	var result
	if healthbar.value - amount >= 0:
		result = healthbar.value - amount
	else:
		result = 0
		EventBus.player_defeated.emit()
	
	animate_health(result)
	#healthbar.value = result
	#health_label.text = str(result)

func heal(amount: int):
	var result = min(healthbar.value + amount, Global.run_stats.player_stats[Stats.List.MAX_HEALTH])
	animate_health(result)

func repair_shield(amount: int) -> void:
	var curr_shield = Stats.List.CURRENT_SHIELD
	var curr_shield_count = Stats.List.CURRENT_SHIELD_COUNT
	var shield_strength = Stats.List.SHIELD_STRENGTH
	var max_shield_count = Stats.List.MAX_SHIELD_COUNT
	var new_value = Global.run_stats.player_stats[curr_shield] + amount
	
	
	if new_value > Global.run_stats.player_stats[shield_strength]*Global.run_stats.player_stats[curr_shield_count]:
		new_value = Global.run_stats.player_stats[shield_strength]*Global.run_stats.player_stats[curr_shield_count]
	
	
	
	
	
	
	
	if new_value > Global.run_stats.player_stats[shield_strength]*Global.run_stats.player_stats[curr_shield_count]:
		if Global.run_stats.player_stats[curr_shield_count] == Global.run_stats.player_stats[max_shield_count]:
			Global.run_stats.player_stats[curr_shield] = Global.run_stats.player_stats[shield_strength]*Global.run_stats.player_stats[max_shield_count]
		else:
			Global.run_stats.player_stats[curr_shield_count] += 1
			#new_value -= Global.run_stats.player_stats[shield_strength]
			Global.run_stats.player_stats[curr_shield] = new_value
	else:
		print('agr aqi: ', new_value)
		Global.run_stats.player_stats[curr_shield] = new_value
	adjust_shield()

func update() -> void:
	healthbar.max_value = int(Global.run_stats.player_stats[Stats.List.MAX_HEALTH])
	healthbar.value = int(Global.run_stats.player_stats[Stats.List.CURRENT_HEALTH])
	health_label.text = str(int(Global.run_stats.player_stats[Stats.List.CURRENT_HEALTH]))
	adjust_shield()

func adjust_shield():
	var max_shield_count = Global.run_stats.player_stats[Stats.List.MAX_SHIELD_COUNT]
	var shield_count = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD_COUNT]
	var curr_shield = Global.run_stats.player_stats[Stats.List.CURRENT_SHIELD]
	var shield_size = Global.run_stats.player_stats[Stats.List.SHIELD_STRENGTH]
	
	print('SHIELD DUMP ----------------------')
	print('max_shield_count: ', max_shield_count)
	print('shield_count: ', shield_count)
	print('curr_shield: ', curr_shield)
	print('shield_size: ', shield_size)
	
	var curr_shield_percent: float = 0.0
	if shield_count > 0:
		curr_shield_percent = float(curr_shield) / (shield_count * shield_size)
	
	shield_bar_1.hide()
	shield_bar_2.hide()
	shield_bar_3.hide()
	shield_bar_4.hide()
	shield_bar_5.hide()
	shield_label_1.hide()
	shield_label_2.hide()
	shield_label_3.hide()
	shield_label_4.hide()
	
	var label_targets: Array[int] = []
	var remaining = curr_shield
	for i in max_shield_count:
		var v = min(remaining, shield_size)
		label_targets.append(int(v))
		remaining -= v
		shield_labels[i].show()
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	print('aqui né?')
	match int(max_shield_count):
		0:
			return
		1, 2, 3:
			var bar = [null, shield_bar_1, shield_bar_2, shield_bar_3][max_shield_count]
			bar.show()
			print('BARRA: ', bar)
			tween.tween_property(bar.material, 'shader_parameter/pour_fill_amount', curr_shield_percent, tween_duration)
			for i in max_shield_count:
				_tween_label(tween, shield_labels[i], label_targets[i])
		4:
			shield_bar_4.show()
			shield_bar_5.show()
			
			var curr_4: float
			var curr_5: float
			if curr_shield > shield_size * 3:
				curr_4 = 1
				curr_5 = float(curr_shield - shield_size * 3) / shield_size
			else:
				curr_4 = float(curr_shield) / (shield_size * 3)
				curr_5 = 0
			
			tween.tween_property(shield_bar_4.material, 'shader_parameter/pour_fill_amount', curr_4, tween_duration)
			for i in 3:
				_tween_label(tween, shield_labels[i], label_targets[i])
			
			tween.chain().tween_property(shield_bar_5.material, 'shader_parameter/pour_fill_amount', curr_5, tween_duration)
			_tween_label(tween, shield_labels[3], label_targets[3])


func _tween_label(tween: Tween, label: RichTextLabel, target: int):
	tween.tween_method(
		func(v): label.text = str(int(v)),
		int(label.text),
		target,
		tween_duration)
