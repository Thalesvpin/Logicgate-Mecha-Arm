extends PanelContainer
class_name CustomTooltip

var description

func _ready() -> void:
	description = find_child('Description')

func config(for_text: String) -> void:
	if !description:
		await self.ready
	description.text = for_text #if crash on this line, make sure _ready() runs first
	
