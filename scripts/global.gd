extends Node

const RARITY_PLACEHOLDER = preload("uid://b8l68f41218q5")



#radial menu textures
const SELL = preload("uid://dvxmvtj7hrqrw")
const CLEAR_CONNECTIONS = preload("uid://jjqybhx6ejot")
const INFO = preload("uid://3dcqftonh2pd")
const CANCEL = preload("uid://dmewb6qo64t7g")

#region SELF ASSIGNED VARIABLES
var circuit_editor
var gates_selector
var input_manager
var output_manager
var combat_screen
var run_stats
var player_stats_bar
var heavy_attack_panel
var implant_manager
var tech_mods_container
var bio_hacks_container
#endregion

#control variables
var sell_gate: bool = false
var seed: int = 0
var random = PcgRandom.new()
var execution_sequence: Array[int]
enum Rarity {COMMON, RARE, ULTRA_RARE, LEGENDARY}
#signal _null

#radial menu presets
#display order: ↑ → ↓ ←
var gate_options = [
	{
		'texture': INFO, 
		'title': 'Informações', 
		'id': 'idx_1'
	},
	{
		'texture': CLEAR_CONNECTIONS, 
		'title': 'Limpar Conexões', 
		'id': 'idx_0'
	},
	{
		'texture': CANCEL, 
		'title': 'Cancelar', 
		'id': 'idx_3'
	},
	{
		'texture': SELL, 
		'title': 'Vender porta', 
		'id': 'idx_2'
	},
]
var inventory_options = [
	{
		'texture': INFO, 
		'title': 'Informações', 
		'id': 'idx_1'
	},
	{
		'texture': CLEAR_CONNECTIONS, 
		'title': 'Limpar Conexões', 
		'id': 'idx_0'
	},
	{
		'texture': CANCEL, 
		'title': 'Cancelar', 
		'id': 'idx_3'
	},
	{
		'texture': SELL, 
		'title': 'Vender portas', 
		'id': 'idx_2'
	},
]

var rarity_textures: Dictionary[Rarity, Texture2D] = {
	Rarity.COMMON: RARITY_PLACEHOLDER,
	Rarity.RARE: RARITY_PLACEHOLDER,
	Rarity.ULTRA_RARE: RARITY_PLACEHOLDER,
	Rarity.LEGENDARY: RARITY_PLACEHOLDER,
}

#var action_attack: Dictionary = new_action(0, true, _null)
#var action_heal_shield: Dictionary = new_action(0, true, _null)
#var action_self_damage: Dictionary = new_action(0, true, _null)
#var action_charge_charged_attack: Dictionary = new_action(0, true, _null)
#var action_charged_attack: Dictionary = new_action(0, true, _null)
#var action_heal_life: Dictionary = new_action(0, true, _null)
###Duplicate to edit (no signal linked yet)
#var all_actions: Dictionary = {
	#'attack': action_attack,
	#'heal_shield': action_heal_shield,
	#'self_damage': action_self_damage,
	#'charge_charged_attack': action_charge_charged_attack,
	#'charged_attack': action_charged_attack,
	#'heal_life': action_heal_life,
#}

#func new_action(id: int, active: bool, _signal: Signal) -> Dictionary:
	#var template: Dictionary = {
		#'id': id,
		#'active': active,
		#'signal': _signal,
	#}
	#return template

func _ready() -> void:
	#load_implants()
	pass

func dec_to_bin(decimal: int) -> int:
	var result := 0
	var place := 1
	var bit := 0
	
	while decimal > 0:
		bit = decimal & 1
		result += bit * place
		place *= 10
		decimal >>= 1
	
	return result

##bits_size is the max number of bits each number may have aka the random max range
##[br]
##bits_size = 4 -> range(0, 15) inclusive
func unique_random_list(list_size: int, bits_size: int) -> Array[int]:
	var prev: Array[int] = []
	var num
	while prev.size() < list_size:
		num = random.next() % (2**bits_size)
		if num not in prev:
			prev.append(num)
	return prev

func rand_binary(size: int) -> int:
	var num = random.next()
	var result = Global.dec_to_bin(num%(2**size))
	return result

func set_new_seed():
	seed = randi()
	random.set_seed(seed)

func change_wires_color(color: Color) -> void:
	for child in circuit_editor.wire_layer.get_children():
		if child.get_child(0).get_class() == 'Line2D':
			child.change_color(color)

func reset_wires_color() -> void:
	for child in circuit_editor.wire_layer.get_children():
		if child.get_child(0).get_class() == 'Line2D':
			child.default_color()

var all_commom: Array[Implant] = []
var all_rare: Array[Implant] = []
var all_ultra_rare: Array[Implant] = []
var all_legendary: Array[Implant] = []
var tm_commom: Array[Implant] = []
var tm_rare: Array[Implant] = []
var tm_ultra_rare: Array[Implant] = []
var tm_legendary: Array[Implant] = []
var bh_commom: Array[Implant] = []
var bh_rare: Array[Implant] = []
var bh_ultra_rare: Array[Implant] = []
var bh_legendary: Array[Implant] = []
func load_implants() -> void:
	var tech_mods_path: String = "res://resources/techmods/"
	var bio_hacks_path: String = "res://resources/biohacks/"
	
	sort(tech_mods_path)
	sort(bio_hacks_path)

func sort(path: String) -> void:
	sort_rarity(path)
	sort_type()

func sort_rarity(path: String) -> void:
	var dir := DirAccess.open(path)
	
	if dir == null:
		return
	dir.list_dir_begin()
	
	var file := (dir.get_next())
	var implant
	while file != "":
		if !dir.current_is_dir() && file.ends_with(".tres"):
			implant = load(path.path_join(file))
			if implant is Implant:
				match implant.rarity:
					Rarity.COMMON:
						all_commom.append(implant)
					Rarity.RARE:
						all_rare.append(implant)
					Rarity.ULTRA_RARE:
						all_ultra_rare.append(implant)
					Rarity.LEGENDARY:
						all_legendary.append(implant)
		file = dir.get_next()
	dir.list_dir_end()

##Do not call before sort_rarity()
func sort_type() -> void:
	for implant in all_commom:
		match implant.type:
			Implant.Type.TECH_MOD:
				tm_commom.append(implant)
			Implant.Type.BIO_HACK:
				bh_commom.append(implant)
	for implant in all_rare:
		match implant.type:
			Implant.Type.TECH_MOD:
				tm_rare.append(implant)
			Implant.Type.BIO_HACK:
				bh_rare.append(implant)
	for implant in all_ultra_rare:
		match implant.type:
			Implant.Type.TECH_MOD:
				tm_ultra_rare.append(implant)
			Implant.Type.BIO_HACK:
				bh_ultra_rare.append(implant)
	for implant in all_legendary:
		match implant.type:
			Implant.Type.TECH_MOD:
				tm_legendary.append(implant)
			Implant.Type.BIO_HACK:
				bh_legendary.append(implant)
