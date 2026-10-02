extends Node
class_name CombatActions

enum List {
	ATTACK,
	HEAVY_ATTACK,
	CHARGE_HEAVY_ATTACK,
	SELF_DAMAGE,
	HEAL,
	REPAIR_SHIELD,
}

enum Persistent {
	ATTACK,
	HEAVY_ATTACK,
	CHARGE_HEAVY_ATTACK,
	SELF_DAMAGE,
	HEAL,
	REPAIR_SHIELD,
	#SPECIAL_ATTACK
}

enum Ocasional {}

static var list_signals: Dictionary[List, Signal] = {
	List.ATTACK: EventBus.attacked,
	List.HEAVY_ATTACK: EventBus.heavy_attack_used,
	List.CHARGE_HEAVY_ATTACK: EventBus.charged_heavy_attack,
	List.SELF_DAMAGE: EventBus.self_damage,
	List.HEAL: EventBus.healed,
	List.REPAIR_SHIELD: EventBus.repaired_shield
}
