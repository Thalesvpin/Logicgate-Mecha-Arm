extends ModifierEffect
class_name AddGateCostEffect

@export var gate: Gates.Type
##To subtract, insert a negative value
@export var amount: float
var result

func apply() -> void:
	result = Global.run_stats.gates_price[gate] + amount
	if result > 0:
		Global.run_stats.gates_price[gate] = result


func revert() -> void:
	if !is_permanent:
		Global.run_stats.gates_price[gate] -= amount
