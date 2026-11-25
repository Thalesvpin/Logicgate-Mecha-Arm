extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var input: Label = $"../PanelContainer/Input"

signal new_wire(pin)
signal unplug_wire

var type: String = "input"
var connected_gate
var connected_wires: Array
var is_active: bool = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		get_viewport().set_input_as_handled()
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if connected_gate != null:
				for wire in connected_wires:
					if wire.point_b == self:
						unplug_wire.emit()
			else:
				new_wire.emit(self)

func _process(delta: float) -> void:
	if connected_gate:
		owner.output = connected_gate.is_active
		input.text = str(int(connected_gate.is_active))
		return
	owner.output = false
	input.text = '0'
	

func _on_mouse_entered() -> void:
	sprite.scale = Vector2(0.02,0.02)
	owner.owner.prevent_click(true)
	Global.circuit_editor.hovered_pin = self

func _on_mouse_exited() -> void:
	sprite.scale = Vector2(0.007,0.007)
	owner.owner.prevent_click(false)
	if Global.circuit_editor.hovered_pin == self:
		Global.circuit_editor.hovered_pin = null

func get_bit_from_execution_sequence(execution_number: int, bit_idx: int) -> bool:
	var bin = Global.dec_to_bin(execution_number)
	return bool(int(('%04d' % bin).substr(bit_idx,1)))

func precalculate_output():
	if connected_gate.owner.owner && connected_gate.owner.owner.name.to_lower() == "gameinputmanager":
		var sequence = Global.circuit_editor.execution_sequence
		#print('sequence: ', sequence)
		var sequence_bits = []
		for ex in sequence:
			#sequence_bits.append(get_bit_from_execution_sequence(ex, connected_gate.owner.get_index()))
			var bit_idx = connected_gate.owner.owner.children.find(connected_gate.owner)
			sequence_bits.append(get_bit_from_execution_sequence(ex, bit_idx))
		#print('retornei: ', sequence_bits)
		return sequence_bits
	else:
		return connected_gate.owner.precalculate_output()
