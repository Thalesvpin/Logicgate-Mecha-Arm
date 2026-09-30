extends ImplantCondition
class_name SpecificGateCondition

@export var gate: Gates.Type

func is_met(context = null) -> bool:
	return gate == context as Gates.Type
