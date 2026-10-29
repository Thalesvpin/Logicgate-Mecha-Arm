extends Node

@onready var telemetry_bar: PanelContainer = $"../GameplayElements/TelemetryBar"

#region SAVE RUN
var player_stats: Dictionary[Stats.List, Variant]
var gates_price: Dictionary[Gates.Type, int]
var run_stats: Dictionary #not used yet
#endregion

#region PLAYER
@export var max_health: int = 100
var current_health: int
@export var base_heal: float
@export var max_shield: int = 10
var current_shield: int
@export var base_shield_repair: int
@export var max_heavy_attack_charges: int
var current_active_charges: int
@export var attack_damage: float
@export var self_damage: float
@export var crit_chance: float
@export var crit_multiplier: float
@export var mitigation_percent: float
@export var heavy_attack_max_charges: int = 4
@export var heavy_attack_charge_amount: int = 1
@export_group('Gates Price')
@export var max_tokens_amount: int
@export var _and: int
@export var _or: int
@export var _not: int
@export var _nand: int
@export var _nor: int
@export var _xor: int
@export var _xnor: int
var current_tokens: int
var current_money: int
var current_elementals: Array
#endregion

#region RUN
var current_firewall: int = 1
var current_battle: int = 1
var current_run_time: float
var current_turn: int = 0
#endregion

func _ready() -> void:
	Global.run_stats = self
	set_variables()
	connect_signals()

func _process(delta: float) -> void:
	current_run_time += delta

func connect_signals() -> void:
	EventBus.battle_ended.connect(next_battle)

func next_battle() -> void:
	if current_battle < 3:
		current_battle += 1
	else:
		current_battle = 1
		#current_turn = 0
		current_firewall += 1

func set_variables() -> void:
	current_run_time = 0
	
	current_health = max_health
	current_shield = max_shield
	current_active_charges = max_heavy_attack_charges
	current_tokens = max_tokens_amount
	
	player_stats = {
		Stats.List.MAX_HEALTH: max_health,
		Stats.List.CURRENT_HEALTH: max_health,
		Stats.List.BASE_HEAL: base_heal,
		Stats.List.MAX_SHIELD: max_shield,
		Stats.List.CURRENT_SHIELD: 5,
		Stats.List.MAX_SHIELD_COUNT: 4,
		Stats.List.CURRENT_SHIELD_COUNT: 1,
		Stats.List.BASE_SHIELD_REPAIR: base_shield_repair,
		Stats.List.MAX_HEAVY_ATTACK_CHARGES: max_heavy_attack_charges,
		Stats.List.CURRENT_HEAVY_ATTACK_CHARGES: 0,
		Stats.List.HEAVY_ATTACK_CHARGE_AMOUNT: heavy_attack_charge_amount,
		Stats.List.BASE_ATTACK_DAMAGE: attack_damage,
		Stats.List.SELF_DAMAGE: self_damage,
		Stats.List.CRITIC_CHANCE: crit_chance,
		Stats.List.CRITIC_MULTIPLIER: crit_multiplier,
		Stats.List.MITIGATION_PERCENT: mitigation_percent,
		Stats.List.MAX_TOKENS_AMOUNT: max_tokens_amount,
		Stats.List.CURRENT_TOKENS: max_tokens_amount,
		Stats.List.CURRENT_MONEY: 0,
		Stats.List.CURRENT_ELEMENTALS: [],
	}
	gates_price = {
		Gates.Type.AND: _and,
		Gates.Type.OR: _or,
		Gates.Type.NOT: _not,
		Gates.Type.NAND: _nand,
		Gates.Type.NOR: _nor,
		Gates.Type.XOR: _xor,
		Gates.Type.XNOR: _xnor,
	}
