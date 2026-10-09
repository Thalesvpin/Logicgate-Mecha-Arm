extends PanelContainer

var label: Label

func _ready() -> void:
	label = find_child('Label', true)
	update()
	#EventBus..connect(uptdate)
	pass

func update() -> void:
	label.text = '$%05d' % Global.run_stats.player_stats[Stats.List.CURRENT_MONEY]
