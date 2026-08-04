extends VBoxContainer

func _ready() -> void:
	for child in get_children():
		child.size_flags_vertical = Control.SIZE_EXPAND
