extends PanelContainer

@export var money_tween_duration: float = 0.8
var labels: Array[RichTextLabel]

func _ready() -> void:
	print('to rodando: ', name)
	if name == 'CombatMoneyPanel':
		Global.combat_money_panel = self
	if name == 'ShopMoneyPanel':
		Global.shop_money_panel = self
	labels = [
		find_child('Label', true),
		find_child('Label2', true),
		find_child('Label3', true)
	]
	update()
	EventBus.enemy_defeated.connect(enemy_defeated)
	pass

func update() -> void:
	var money = Global.run_stats.player_stats[Stats.List.CURRENT_MONEY]
	var start_val = 0
	if not labels.is_empty() and labels[0] and labels[0].text != "":
		start_val = int(labels[0].text)
	
	var tween = create_tween()
	tween.tween_method(
		func(v):
			var formatted_text = '$%05d' % v
			for lbl in labels:
				if lbl:
					lbl.text = formatted_text,
		start_val, money, money_tween_duration
	)
	#label.text = '$%05d' % Global.run_stats.player_stats[Stats.List.CURRENT_MONEY]

func enemy_defeated(enemy) -> void:
	if self.name == 'CombatMoneyPanel':
		var ef = AddMoneyEffect.new()
		ef.amount = Enemy.reward[enemy.type]
		await ef.apply(true)
		#await get_tree().create_timer(1).timeout
	#update()
