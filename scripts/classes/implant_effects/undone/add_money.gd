extends ImplantEffect
class_name AddMoneyEffect

##To subtract, insert a negative value
@export var amount: int
##percent is based in current money
@export var mode: Mode = Mode.FLAT
##If set to 0, no limit will be applied
@export var limit: int = 0

enum Mode {FLAT, PERCENT}

func apply(_context = null) -> void:
	var result
	match mode:
		Mode.FLAT:
			if limit > 0:
				result = add_to_player_stats(Stats.List.CURRENT_MONEY, amount, Operator.GREATER, limit)
			else:
				result = add_to_player_stats(Stats.List.CURRENT_MONEY, amount)
		Mode.PERCENT:
			if limit > 0:
				result = add_to_player_stats(Stats.List.CURRENT_MONEY, Global.run_stats.player_stats[Stats.List.CURRENT_MONEY] * amount/100, Operator.GREATER, limit)
			else:
				result = add_to_player_stats(Stats.List.CURRENT_MONEY, Global.run_stats.player_stats[Stats.List.CURRENT_MONEY] * amount/100)
	#EventBus.stat_changed.emit(Stats.List.CURRENT_MONEY, result)
	if _context == true:
		var tree = Engine.get_main_loop() as SceneTree
		await tree.create_timer(1).timeout
	Global.combat_money_panel.update()
	Global.shop_money_panel.update()

func revert() -> void:
	pass
