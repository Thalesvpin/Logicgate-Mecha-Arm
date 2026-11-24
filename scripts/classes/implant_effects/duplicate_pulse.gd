extends ImplantEffect
class_name DuplicatePulseEffect

@export_range(1, 3, 1) var pulse_index: int
@export_range(0, 100, 1, 'suffix:%') var chance: int

var is_set: bool = true

func apply(_context = null) -> void:
	#EventBus.pulse.connect(duplicate_pulse)
	pass

func duplicate_pulse(idx: int) -> void:
	if EventBus.pulse_replay:
		return
	if pulse_index-1 == idx && take_chance():
		EventBus.repeat_pulse_idx = idx

func take_chance() -> bool:
	var rand = Global.random.next() % 100
	return rand <= chance

func revert() -> void:
	pass
