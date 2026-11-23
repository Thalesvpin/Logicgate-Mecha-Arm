extends ImplantEffect
class_name AddMaxTokensEffect

##To subtract, insert a nagative value
@export var amount: int = 0

func apply(_context = null) -> void:
	add_to_player_stats(Stats.List.MAX_TOKENS_AMOUNT, amount, lesser, 1)
	Global.gates_selector.set_tokens_label()

func revert() -> void:
	if !is_permanent:
		add_to_player_stats(Stats.List.MAX_TOKENS_AMOUNT, -amount, lesser, 1)
		Global.gates_selector.set_tokens_label()
