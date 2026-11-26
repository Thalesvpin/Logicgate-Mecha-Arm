extends Panel

@onready var texture_rect: TextureRect = $TextureRect
@onready var cost_label: Label = $CostLabel
@onready var name_label: Label = $NameLabel

#enum Types: String {"AND", "OR", "DEF"} 

@export var type: Gates.Type
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
var cost: int
@export_group('')

func _ready() -> void:
	load_data()
	EventBus.toggle_hint_name.connect(toggle_hint)

func toggle_hint() -> void:
	name_label.visible = !name_label.visible
	var style: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	style.border_color.a = 155 if name_label.visible else 0
	add_theme_stylebox_override("panel", style)

func load_data():
	name_label.text = Gates.Type.keys()[type]
	match type:
		Gates.Type.AND:
			icon = and_icon
			scene = and_scene
			cost = Global.run_stats.gates_price[Gates.Type.AND]
		Gates.Type.OR:
			icon = or_icon
			scene = or_scene
			cost = Global.run_stats.gates_price[Gates.Type.OR]
		Gates.Type.NOT:
			icon = not_icon
			scene = not_scene
			cost = Global.run_stats.gates_price[Gates.Type.NOT]
		Gates.Type.NAND:
			icon = nand_icon
			scene = nand_scene
			cost = Global.run_stats.gates_price[Gates.Type.NAND]
		Gates.Type.NOR:
			icon = nor_icon
			scene = nor_scene
			cost = Global.run_stats.gates_price[Gates.Type.NOR]
		Gates.Type.XOR:
			icon = xor_icon
			scene = xor_scene
			cost = Global.run_stats.gates_price[Gates.Type.XOR]
		Gates.Type.XNOR:
			icon = xnor_icon
			scene = xnor_scene
			cost = Global.run_stats.gates_price[Gates.Type.XNOR]
	texture_rect.texture = icon
	cost_label.text = str(cost)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed && Global.run_stats.gates_price[type] <= Global.run_stats.player_stats[Stats.List.CURRENT_TOKENS]:
				DragManager.drag_gate(scene.instantiate(), true)
				Global.gates_selector.gate_bought(type)

#Ensure the selected gate will display over everything
#func _get_drag_data(at_position):
	#var root := Control.new()
	#var preview := TextureRect.new()
	#preview.texture = icon
	#root.add_child(preview)
	#preview.position = -icon.get_size() / 2.0
	#set_drag_preview(root)
	#
	#return type
