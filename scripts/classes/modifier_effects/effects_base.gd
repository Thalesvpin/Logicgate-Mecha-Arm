extends Resource
class_name ModifierEffect

@export var is_permanent: bool = false
enum Operator { LESSER, GREATER, RANGE, NULL }
var lesser = Operator.LESSER
var greater = Operator.GREATER
var range = Operator.RANGE

## Classe base — todo efeito, básico ou especial, herda daqui
func apply() -> void:
	push_error("apply() não implementado em %s" % get_script().resource_path)

# opcional, útil pra buffs temporários que precisam ser desfeitos
func revert() -> void:
	push_error("revert() não implementado em %s" % get_script().resource_path)

func add_to_player_stats(stat: Stats.List, amount: float, operator: Operator = Operator.NULL, case: float = 0, case2: float = 0) -> Variant:
	var result = Global.run_stats.player_stats[stat] + amount
	if operator != Operator.NULL:
		match operator:
			Operator.LESSER:
				if result < case:
					result = case
			Operator.GREATER:
				if result > case:
					result = case
			Operator.RANGE:
				if result >= case && result <= case2:
					result = case
				elif result < case:
					result = case
				elif result > case2:
					result = case2
	Global.run_stats.player_stats[stat] = result
	return result

func set_player_stat(stat: Stats.List, amount: float) -> void:
	Global.run_stats.player_stats[stat] = amount

func get_player_stat(stat: Stats.List) -> Variant:
	return Global.run_stats.player_stats[stat]
