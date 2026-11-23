extends ImplantEffect
class_name HealEnemyEffect

enum Mode {PERCENT, FLAT}
@export var amount: float = 40.0
@export var mode: Mode

func apply(context = null) -> void:
	if context is String && context == "player":
		var healed
		if mode == Mode.PERCENT:
			healed = int(Global.run_stats.player_stats[Stats.List.MAX_HEALTH] * amount / 100.0)
		if mode == Mode.FLAT:
			healed = int(Global.run_stats.player_stats[Stats.List.MAX_HEALTH] + amount)
		add_to_player_stats(Stats.List.CURRENT_HEALTH, healed, greater, Global.run_stats.player_stats[Stats.List.MAX_HEALTH])
		return
	if context is Node and "stats" in context:
		var max_hp = context.stats[Stats.List.MAX_HEALTH]
		var healed
		if mode == Mode.PERCENT:
			healed = int(max_hp * amount / 100.0)
		if mode == Mode.FLAT:
			healed = int(max_hp + amount)
		context.stats[Stats.List.CURRENT_HEALTH] = mini(context.stats[Stats.List.CURRENT_HEALTH] + healed, max_hp)
		context.status_bar.set_health_value(context.stats[Stats.List.CURRENT_HEALTH], true)

func revert() -> void:
	pass
