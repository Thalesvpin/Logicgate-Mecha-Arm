extends PanelContainer

@onready var game_over_label: Label = $GameOverLabel
@onready var vitory_label: Label = $VitoryLabel

var is_victory: Variant = null

func victory() -> void:
	vitory_label.show()

func defeat() -> void:
	game_over_label.show()

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		game_over_label.hide()
		vitory_label.hide()
		
		if is_victory == null:
			printerr('game_over_screen.is_vitory not set!')
		
		if is_victory:
			victory()
		else:
			defeat()
		
		is_victory = null
