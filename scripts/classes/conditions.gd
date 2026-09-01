extends Resource
class_name Condition_

@export var if_value: String = ""
enum ConditionOperator {
	EQUAL = 0,
	DIFFERENT = 1,
	GREATER = 2,
	LESS = 3,
	GREATER_EQUAL = 4,
	LESS_EQUAL = 5
}
@export_enum('=', '!=', '>', '<', '>=', '<=') var condition: int = ConditionOperator.EQUAL
@export var comparator: String = ""
