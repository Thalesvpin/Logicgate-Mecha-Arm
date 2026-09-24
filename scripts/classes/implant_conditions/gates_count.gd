extends ImplantCondition
class_name GatesCountCondition

@export var gate_type: Gates.Type
@export var operator: Operators.Type
@export var compared_value: int
var gate_count: int

func is_met() -> bool:
	var result: bool
	match gate_type:
		Gates.Type.AND:
			gate_count = Global.circuit_editor.sandbox.and_count
		Gates.Type.OR:
			gate_count = Global.circuit_editor.sandbox.or_count
		Gates.Type.NOT:
			gate_count = Global.circuit_editor.sandbox.not_count
		Gates.Type.NAND:
			gate_count = Global.circuit_editor.sandbox.nand_count
		Gates.Type.NOR:
			gate_count = Global.circuit_editor.sandbox.nor_count
		Gates.Type.XOR:
			gate_count = Global.circuit_editor.sandbox.xor_count
		Gates.Type.XNOR:
			gate_count = Global.circuit_editor.sandbox.xnor_count
		Gates.Type.ANY:
			gate_count = Global.circuit_editor.sandbox.total_gates_count
	
	match operator:
		Operators.Type.LESSER:
			result = lesser()
		Operators.Type.GREATER:
			result = greater()
		Operators.Type.EQUAL:
			result = equal()
		Operators.Type.LESSER_EQUAL:
			result = le()
		Operators.Type.GREATER_EQUAL:
			result = ge()
	return result

func lesser():
	return gate_count < compared_value

func greater():
	return gate_count > compared_value

func equal():
	return gate_count == compared_value

func le():
	return gate_count <= compared_value

func ge():
	return gate_count >= compared_value
