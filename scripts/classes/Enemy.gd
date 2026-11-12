extends Node
class_name Enemy

enum Type {MINION, BOSS}
enum Strength {WEAK, MEDIUM, STRONG}

static var reward: Dictionary[Type, int] = {
	Type.MINION: 150,
	Type.BOSS: 300
}

enum Actions {
	ATTACK,
	SELF_DAMAGE,
	HEAL,
	REPAIR_SHIELD,
}

static var status_preset: Dictionary[Strength, Dictionary] = {
	Strength.WEAK: {
		Stats.List.MAX_HEALTH: 200,
		Stats.List.BASE_HEAL: 0,
		Stats.List.MAX_SHIELD: 0,
		Stats.List.BASE_SHIELD_REPAIR: 0,
		Stats.List.BASE_ATTACK_DAMAGE: 100,
		Stats.List.MITIGATION_PERCENT: 0,
		Stats.List.CRITIC_CHANCE: 0,
		Stats.List.CRITIC_MULTIPLIER: 0,
	},
	Strength.MEDIUM: {
		Stats.List.MAX_HEALTH: 300,
		Stats.List.BASE_HEAL: 0,
		Stats.List.MAX_SHIELD: 0,
		Stats.List.BASE_SHIELD_REPAIR: 0,
		Stats.List.BASE_ATTACK_DAMAGE: 150,
		Stats.List.MITIGATION_PERCENT: 0,
		Stats.List.CRITIC_CHANCE: 0,
		Stats.List.CRITIC_MULTIPLIER: 0,
	},
	Strength.STRONG: {
		Stats.List.MAX_HEALTH: 400,
		Stats.List.BASE_HEAL: 0,
		Stats.List.MAX_SHIELD: 0,
		Stats.List.BASE_SHIELD_REPAIR: 0,
		Stats.List.BASE_ATTACK_DAMAGE: 200,
		Stats.List.MITIGATION_PERCENT: 0,
		Stats.List.CRITIC_CHANCE: 0,
		Stats.List.CRITIC_MULTIPLIER: 0,
	},
}

static var status_boss: Dictionary[Stats.List, Variant] = {
	Stats.List.MAX_HEALTH: 500,
	Stats.List.BASE_HEAL: 0,
	Stats.List.MAX_SHIELD: 0,
	Stats.List.BASE_SHIELD_REPAIR: 0,
	Stats.List.BASE_ATTACK_DAMAGE: 250,
	Stats.List.CRITIC_CHANCE: 0,
	Stats.List.CRITIC_MULTIPLIER: 0,
	Stats.List.MITIGATION_PERCENT: 0,
}
