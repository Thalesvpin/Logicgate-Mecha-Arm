extends Resource
class_name ActiveShieldCountCondition

##From right to left
@export var digit_position: int:
	set(value):
		digit_position = max(value, 4)
		digit_position = min(digit_position, 1)
		
@export var compared_value: int:
	set(value):
		compared_value = max(value, 0)
		compared_value = min(compared_value, 1)

func is_met() -> bool:
	
	return true
