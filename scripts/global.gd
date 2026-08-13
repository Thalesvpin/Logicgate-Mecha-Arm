extends Node
const SELL = preload("uid://dvxmvtj7hrqrw")
const CLEAR_CONNECTIONS = preload("uid://jjqybhx6ejot")
const INFO = preload("uid://3dcqftonh2pd")
const CANCEL = preload("uid://dmewb6qo64t7g")

#self assigned variables
var circuit_editor
var gates_selector

#control variables
var sell_gate: bool = false

#radial menu presets
#display order: ↑ → ↓ ←
var gate_options = [
	{
		'texture': CLEAR_CONNECTIONS, 
		'title': 'Limpar Conexões', 
		'id': 'idx_0'
	},
	{
		'texture': INFO, 
		'title': 'Informações', 
		'id': 'idx_1'
	},
	{
		'texture': SELL, 
		'title': 'Vender porta', 
		'id': 'idx_2'
	},
	{
		'texture': CANCEL, 
		'title': 'Cancelar', 
		'id': 'idx_3'
	},
]
var inventory_options = [
	{
		'texture': CLEAR_CONNECTIONS, 
		'title': 'Limpar Conexões', 
		'id': 'idx_0'
	},
	{
		'texture': INFO, 
		'title': 'Informações', 
		'id': 'idx_1'
	},
	{
		'texture': SELL, 
		'title': 'Vender portas', 
		'id': 'idx_2'
	},
	{
		'texture': CANCEL, 
		'title': 'Cancelar', 
		'id': 'idx_3'
	},
]
