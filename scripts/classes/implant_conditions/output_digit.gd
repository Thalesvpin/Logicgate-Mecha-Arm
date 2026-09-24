extends ImplantCondition
class_name OutputDigitCondition

##From right to left
@export_range(1, 4, 1) var digit_position: int
##The value in digit_position must be equal to expected_value to meet the condition
@export_range(0, 1, 1) var expected_value: int

func is_met() -> bool:
	var bin = str(Global.dec_to_bin(Global.output_manager.output))
	var digit = bin.substr(digit_position, 1)
	return digit == expected_value
