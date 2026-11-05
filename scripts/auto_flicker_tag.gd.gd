@tool
extends RichTextLabel

func _ready() -> void:
	bbcode_enabled = true
	process_priority = 100

func _process(_delta: float) -> void:
	if not text.begins_with("[nixie]") and text != "":
		text = "[nixie]" + text + "[/nixie]"
