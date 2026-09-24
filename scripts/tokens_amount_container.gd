extends PanelContainer
@onready var label: Label = $MarginContainer/HBoxContainer/VBoxContainer/Title
@onready var texture: TextureRect = $MarginContainer/HBoxContainer/Icon
@onready var current_value: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/CurrentValue

@export var title: String = 'Tokens de Portas Lógicas'
@export var icon: Texture2D

func _ready() -> void:
	label.text = title
	texture.texture = icon
	get_info()

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		get_info()

func get_info() -> void:
	return
	current_value.text = str(Global.run_stats.player_stats[Stats.List.CURRENT_TOKENS])
