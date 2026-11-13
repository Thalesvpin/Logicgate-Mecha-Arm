extends PanelContainer

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel

func config(for_text: String) -> void:
	if !rich_text_label:
		await self.ready
	rich_text_label.text = for_text
