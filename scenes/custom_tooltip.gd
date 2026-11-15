extends PanelContainer

@onready var description: RichTextLabel = $MarginContainer/VBoxContainer/Description

func config(for_text: String) -> void:
	if !description:
		await self.ready
	description.text = for_text
	
