extends PanelContainer

@onready var type_biohack: ColorRect = $TypeBiohack
@onready var type_techmod: ColorRect = $TypeTechmod

func set_techmod() -> void:
	type_biohack.visible = false
	type_techmod.visible = true

func set_biohack() -> void:
	type_biohack.visible = true
	type_techmod.visible = false
