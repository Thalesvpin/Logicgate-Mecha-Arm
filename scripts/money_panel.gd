extends PanelContainer

@export var money_tween_duration: float = 0.8
var label: Label

func _ready() -> void:
	label = find_child('Label', true)
	update()
	EventBus.enemy_defeated.connect(enemy_defeated)
	pass

func update() -> void:
	var money = Global.run_stats.player_stats[Stats.List.CURRENT_MONEY]
	var tween = create_tween()
	tween.tween_method(
		func(v):
			label.text = '$%05d' % v,
		int(label.text), money, money_tween_duration
	)
	#label.text = '$%05d' % Global.run_stats.player_stats[Stats.List.CURRENT_MONEY]

func enemy_defeated(enemy) -> void:
	if self.name != 'CombatMoneyPanel':
		return
	var ef = AddMoneyEffect.new()
	ef.amount = Enemy.reward[enemy.type]
	ef.apply()
	await get_tree().create_timer(1).timeout
	update()
