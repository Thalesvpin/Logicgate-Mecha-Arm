extends ModifierEffect
class_name DuplicatePulseEffect

@export_range(1, 3, 1) var pulse_index: int = 1:
	set(value):
		pulse_index = value-1
@export_range(0, 100, 1, 'suffix:%') var chance: float:
	set(value):
		chance = value/100

var count = 0
var is_set: bool = true

func apply() -> void:
	print('pidx: ', pulse_index)
	EventBus.pulse.connect(duplicate_pulse)
	count += 1

func duplicate_pulse(idx: int) -> void:
	print('count: ', count, 'is set: ', is_set)
	if is_set && pulse_index == idx && take_chance():
		is_set = false
		EventBus.pulse.emit(pulse_index)
		is_set = true

func take_chance() -> bool:
	var rand = Global.random.next()/0xFFFFFFFF
	return rand <= chance

func revert() -> void:
	pass
