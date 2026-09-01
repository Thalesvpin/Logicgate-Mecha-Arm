extends PanelContainer

@onready var healthbar: ProgressBar = $Health/Healthbar
@onready var health_label: Label = $Health/Healthbar/HealthLabel

@export var tween_duration: float = 0.4

func _ready() -> void:
	EventBus.damage_taken.connect(take_damage)
	EventBus.healed.connect(heal)

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
	if healthbar.value + amount <= Global.run_stats.max_health:
		result = healthbar.value + amount
	else:
		result = Global.run_stats.max_health
	
	animate(result)
	#healthbar.value = result
	#health_label.text = str(result)
