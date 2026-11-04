extends Control

@onready var seed_container: HBoxContainer = $CanvasLayer/VBoxContainer/SeedContainer
@onready var line_edit: LineEdit = $CanvasLayer/VBoxContainer/SeedContainer/LineEdit
const TUTORIAL = preload("uid://ebj85qn4ud0i")
const GAME_BOARD = preload("uid://btv7b87fvwj4y")

func _ready() -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(GAME_BOARD)

func _on_add_seed_pressed() -> void:
	seed_container.show()

func _on_submit_seed_pressed() -> void:
	if line_edit.text != '':
		if is_only_numbers(line_edit.text):
			Global.seed = int(line_edit.text)
		else:
			Global.seed = line_edit.text.sha256_text().hex_to_int()
	seed_container.hide()

func is_only_numbers(text: String) -> bool:
	var regex = RegEx.new()
	regex.compile(r"^\d+$")
	return regex.search(text) != null

func _on_tutorial_button_up() -> void:
	get_tree().change_scene_to_packed(TUTORIAL)
