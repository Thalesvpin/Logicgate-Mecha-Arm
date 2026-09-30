extends ModifierEffect
class_name AddGateCostEffect

##Use ANY for random gate
@export var gate: Gates.Type
##To subtract, insert a negative value
@export var amount: float
var result
var is_applied: bool = false

func apply(context = null) -> void:
	var aux: Gates.Type
	if !is_applied:
		if gate == Gates.Type.ANY:
			aux = Gates.Type.ANY
			gate = Global.random.next()%7 as Gates.Type
		
		result = Global.run_stats.gates_price[gate] + amount
		if result > 0:
			Global.run_stats.gates_price[gate] = result
		elif aux && aux == Gates.Type.ANY:
			gate = Gates.Type.ANY
			apply()
			return
		else:
			return
		is_applied = true


func revert() -> void:
	if !is_permanent:
		Global.run_stats.gates_price[gate] -= amount
		is_applied = false
