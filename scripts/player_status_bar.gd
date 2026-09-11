extends PanelContainer

@onready var healthbar: ProgressBar = $Health/Healthbar
@onready var health_label: Label = $Health/Healthbar/HealthLabel
@onready var shield_bar: ColorRect = $Shield/ShieldBar

@export var tween_duration: float = 0.4

var shield_labels: Array[Label]

func _ready() -> void:
	Global.player_stats_bar = self
	#EventBus.damage_taken.connect(take_damage)
	#EventBus.healed.connect(heal)
	for label in shield_bar.get_child(0).get_children():
		shield_labels.append(label)

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
		
