extends Node
class_name CombatActions

enum List {
	ATTACK,
	CHARGED_ATTACK,
	CHARGE_CHARGED_ATTACK,
	SELF_DAMAGE,
	HEAL,
	REPAIR_SHIELD,
}

enum Persistent {
	ATTACK,
	CHARGED_ATTACK,
	CHARGE_CHARGED_ATTACK,
	SELF_DAMAGE,
	HEAL,
	REPAIR_SHIELD,
	#SPECIAL_ATTACK
}

enum Ocasional {}

static var list_signals: Dictionary[List, Signal] = {
	List.ATTACK: EventBus.attacked,
	List.CHARGED_ATTACK: EventBus.charged_attack_used,
	List.CHARGE_CHARGED_ATTACK: EventBus.charged_charged_attack,
	List.SELF_DAMAGE: EventBus.self_damage,
	List.HEAL: EventBus.healed,
	List.REPAIR_SHIELD: EventBus.repaired_shield
}
