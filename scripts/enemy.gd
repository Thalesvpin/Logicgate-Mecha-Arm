extends Control

@export_group('Deafault values')
@export var max_heatlh: int
@export var base_heal: float
@export var max_shield: int
@export var base_attack_damage: int
@export var critic_chance: float
@export var critic_mult: float
@export var mitigation_percent: float
@export var current_elemental: Variant

var stats: Dictionary[Stats.List, Variant] = {
	Stats.List.MAX_HEALTH: 0,
	Stats.List.CURRENT_HEALTH: 0,
	Stats.List.BASE_HEAL: 0,
	Stats.List.MAX_SHIELD: 0,
	Stats.List.CURRENT_SHIELD: 0,
	Stats.List.BASE_ATTACK_DAMAGE: 0,
	Stats.List.CRITIC_CHANCE: 0,
	Stats.List.CRITIC_MULTIPLIER: 0,
	Stats.List.MITIGATION_PERCENT: 0,
	Stats.List.CURRENT_ELEMENTALS: null,
	Stats.List.CURRENT_AFFLICTED_ELEMENT: null
}

var id
var battle_position

func _ready() -> void:
	set_stats()
	connect_signals()

func is_the_signal_for_me(target: Node) -> bool:
	return target == self

##Undone
func take_damage(value: float, target: Node) -> void:
	if !is_the_signal_for_me(target):
		return
	
	var final_taken_dmg := 0
	if stats[Stats.List.CURRENT_SHIELD] > 0:
		#mitigation
		pass
	else:
		final_taken_dmg = int(value)
	
	stats[Stats.List.CURRENT_HEALTH] -= final_taken_dmg

func heal() -> void:
	stats[Stats.List.CURRENT_HEALTH] += stats[Stats.List.BASE_HEAL]

func repair_shield(amount: float) -> void:
	stats[Stats.List.CURRENT_SHIELD] += int(amount)

func attack(amount: float) -> void:
	EventBus.damage_taken.emit(amount)

func set_stats() -> void:
	stats[Stats.List.MAX_HEALTH] = max_heatlh
	stats[Stats.List.CURRENT_HEALTH] = max_heatlh
	stats[Stats.List.BASE_HEAL] = base_heal
	stats[Stats.List.MAX_SHIELD] = max_shield
	stats[Stats.List.CURRENT_SHIELD] = 0
	stats[Stats.List.BASE_ATTACK_DAMAGE] = base_attack_damage
	stats[Stats.List.CRITIC_CHANCE] = critic_chance
	stats[Stats.List.CRITIC_MULTIPLIER] = critic_mult
	stats[Stats.List.MITIGATION_PERCENT] = mitigation_percent
	stats[Stats.List.CURRENT_ELEMENTALS] = current_elemental
	stats[Stats.List.CURRENT_AFFLICTED_ELEMENT] = null

func connect_signals() -> void:
	EventBus.attacked.connect(take_damage)
