extends PanelContainer

@onready var scroll_container: ScrollContainer = $MarginContainer/VBoxContainer/ScrollContainer

#func _process(delta: float) -> void:
	##check_h_size()
	#var content := get_child(0)
#
	#if content.get_combined_minimum_size().x > size.x:
		#print("Conteúdo maior que o ScrollContainer")
	#else:
		#print("cabe")

func check_h_size():
	if scroll_container.get_h_scroll_bar().visible:
		scroll_container.get_h_scroll_bar().visible = false
		print('maior')
