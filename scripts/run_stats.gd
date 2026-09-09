extends Node

#region PLAYER
@export var max_health: int = 100
var current_health: int
@export var base_heal: float
@export var max_shield: int = 30
var current_shield: int
@export var max_charged_attack_charges: int
var current_active_charges: int
@export var attack_damage: float
@export var crit_chance: float
@export var crit_multiplier: float
@export var mitigation_percent: float
@export var max_tokens_amount: int
@export var charged_attack_max_charges: int = 4
var current_tokens: int
var current_money: int
var current_elementals: Array
var player_stats: Dictionary[Stats.List, Variant] = {
	Stats.List.MAX_HEALTH: max_health,
	Stats.List.CURRENT_HEALTH: max_health,
	Stats.List.BASE_HEAL: base_heal,
	Stats.List.MAX_SHIELD: max_shield,
	Stats.List.CURRENT_SHIELD: 0,
	Stats.List.CURRENT_SHIELD_COUNT: 0,
	Stats.List.MAX_CHARGED_ATTACK_CHARGES: max_charged_attack_charges,
	Stats.List.CURRENT_CHARGED_ATTACK_CHARGES: 0,
	Stats.List.BASE_ATTACK_DAMAGE: attack_damage,
	Stats.List.CRITIC_CHANCE: crit_chance,
	Stats.List.CRITIC_MULTIPLIER: crit_multiplier,
	Stats.List.MITIGATION_PERCENT: mitigation_percent,
	Stats.List.MAX_TOKENS_AMOUNT: max_tokens_amount,
	Stats.List.CURRENT_TOKENS: max_tokens_amount,
	Stats.List.CURRENT_MONEY: 0,
	Stats.List.CURRENT_ELEMENTALS: [],
	Stats.List.CHARGED_ATTACK_MAX_CHARGES: charged_attack_max_charges,
	Stats.List.CHARGED_ATTACK_ACTIVE_CHARGES: 0,
}
#endregion

#region RUN
var current_ante: int
var current_stake: int
var current_run_time
#endregion

#region TECH MODS
var current_tech_mods: Array
#endregion
#region BIO HACKS
var current_bio_hacks: Array
#endregion

func _ready() -> void:
	Global.run_stats = self
	set_variables()

func set_variables() -> void:
	current_health = max_health
	current_shield = max_shield
	current_active_charges = max_charged_attack_charges
	current_tokens = max_tokens_amount
