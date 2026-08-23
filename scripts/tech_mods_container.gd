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
	pass
	#print(size.x/aux.get_child(0).size.x)
	#if aux.get_child(0):
		#if size.x < 347:
			#aux.get_child(0).set_template(1)
		#if size.x/aux.get_child(0).size.x > 1.067:
			#change_to_next(-1)

var template_idx: int = 1
func change_to_next(amount: int):
	template_idx += amount
	if template_idx > 3:
		template_idx = 3
	if template_idx < 1:
		template_idx = 1
	
	aux.get_child(0).set_template(template_idx)

@onready var aux: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
func _process(delta: float) -> void:
	#print(size.x,' -  ', aux.get_child(0).size.x)
	check_h_size()
	
	
