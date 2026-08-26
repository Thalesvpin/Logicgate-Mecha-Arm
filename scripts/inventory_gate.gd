extends Panel

@onready var texture_rect: TextureRect = $TextureRect

#enum Types: String {"AND", "OR", "DEF"} 

@export_enum("AND", "OR", "NOT", "NAND", "NOR", "XOR", "XNOR", "DEF") var type: String
@export_group('Sprites')
@export var and_icon: Texture2D
@export var or_icon: Texture2D
@export var not_icon: Texture2D
@export var nand_icon: Texture2D
@export var nor_icon: Texture2D
@export var xor_icon: Texture2D
@export var xnor_icon: Texture2D
@export var def_icon: Texture2D
var icon: Texture2D
@export_group('')

@export_group('Scenes')
@export var and_scene: PackedScene
@export var or_scene: PackedScene
@export var not_scene: PackedScene
@export var nand_scene: PackedScene
@export var nor_scene: PackedScene
@export var xor_scene: PackedScene
@export var xnor_scene: PackedScene
@export var def_scene: PackedScene
var scene: PackedScene
@export_group('')

func _ready() -> void:
	load_data()

func load_data():
	match type.to_lower():
		"and":
			icon = and_icon
			scene = and_scene
		"or":
			icon = or_icon
			scene = or_scene
		"not":
			icon = not_icon
			scene = not_scene
		"nand":
			icon = nand_icon
			scene = nand_scene
		"nor":
			icon = nor_icon
			scene = nor_scene
		"xor":
			icon = xor_icon
			scene = xor_scene
		"xnor":
			icon = xnor_icon
			scene = xnor_scene
		"def":
			icon = def_icon
			scene = def_scene
	texture_rect.texture = icon

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				#DragManager.drag(null, scene, type)
				DragManager.drag_gate(scene.instantiate(), true)
				pass

#Ensure the selected gate will display over everything
func _get_drag_data(at_position):
	var root := Control.new()
	var preview := TextureRect.new()
	preview.texture = icon
	root.add_child(preview)
	preview.position = -icon.get_size() / 2.0
	set_drag_preview(root)
	
	return type
