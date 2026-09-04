extends Node

const RARITY_PLACEHOLDER = preload("uid://b8l68f41218q5")



#radial menu textures
const SELL = preload("uid://dvxmvtj7hrqrw")
const CLEAR_CONNECTIONS = preload("uid://jjqybhx6ejot")
const INFO = preload("uid://3dcqftonh2pd")
const CANCEL = preload("uid://dmewb6qo64t7g")

#self assigned variables
var circuit_editor
var gates_selector
var input_manager
var output_manager
var combat_screen
var run_stats

#control variables
var sell_gate: bool = false
var seed: int = 0
var random = PcgRandom.new()
var execution_sequence: Array[int]
enum Rarity {COMMON, RARE, ULTRA_RARE, LEGENDARY}
signal _null

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

var action_attack: Dictionary = new_action(0, true, _null)
var action_heal_shield: Dictionary = new_action(0, true, _null)
var action_self_damage: Dictionary = new_action(0, true, _null)
var action_charge_charged_attack: Dictionary = new_action(0, true, _null)
var action_charged_attack: Dictionary = new_action(0, true, _null)
var action_heal_life: Dictionary = new_action(0, true, _null)
##Duplicate to edit (no signal linked yet)
var all_actions: Dictionary = {
	'attack': action_attack,
	'heal_shield': action_heal_shield,
	'self_damage': action_self_damage,
	'charge_charged_attack': action_charge_charged_attack,
	'charged_attack': action_charged_attack,
	'heal_life': action_heal_life,
}

func new_action(id: int, active: bool, _signal: Signal) -> Dictionary:
	var template: Dictionary = {
		'id': id,
		'active': active,
		'signal': _signal,
	}
	return template

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
