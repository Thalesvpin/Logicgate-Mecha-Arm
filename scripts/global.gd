extends Node

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

#control variables
var sell_gate: bool = false
var seed: int = 0
var random = PcgRandom.new()

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

func unique_random_binary_list(amount: int, size: int) -> Array[int]:
	var prev: Array[int] = []
	var num
	while prev.size() < amount:
		num = Global.rand_binary(size)
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
