extends Node
class_name Enemy

static var dificulty_progression: float = 1.5

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
		Stats.List.MAX_HEALTH: 200*(dificulty_progression**(Global.run_stats.current_firewall-1)),
		Stats.List.BASE_HEAL: 0,
		Stats.List.MAX_SHIELD: 0,
		Stats.List.BASE_SHIELD_REPAIR: 0,
		Stats.List.BASE_ATTACK_DAMAGE: 100*(dificulty_progression**(Global.run_stats.current_firewall-1)),
		Stats.List.MITIGATION_PERCENT: 0,
		Stats.List.CRITIC_CHANCE: 0,
		Stats.List.CRITIC_MULTIPLIER: 0,
	},
	Strength.MEDIUM: {
		Stats.List.MAX_HEALTH: 300*(dificulty_progression**(Global.run_stats.current_firewall-1)),
		Stats.List.BASE_HEAL: 0,
		Stats.List.MAX_SHIELD: 0,
		Stats.List.BASE_SHIELD_REPAIR: 0,
		Stats.List.BASE_ATTACK_DAMAGE: 150*(dificulty_progression**(Global.run_stats.current_firewall-1)),
		Stats.List.MITIGATION_PERCENT: 0,
		Stats.List.CRITIC_CHANCE: 0,
		Stats.List.CRITIC_MULTIPLIER: 0,
	},
	Strength.STRONG: {
		Stats.List.MAX_HEALTH: 400*(dificulty_progression**(Global.run_stats.current_firewall-1)),
		Stats.List.BASE_HEAL: 0,
		Stats.List.MAX_SHIELD: 0,
		Stats.List.BASE_SHIELD_REPAIR: 0,
		Stats.List.BASE_ATTACK_DAMAGE: 200*(dificulty_progression**(Global.run_stats.current_firewall-1)),
		Stats.List.MITIGATION_PERCENT: 0,
		Stats.List.CRITIC_CHANCE: 0,
		Stats.List.CRITIC_MULTIPLIER: 0,
	},
}

static var status_boss: Dictionary[Stats.List, Variant] = {
	Stats.List.MAX_HEALTH: 700*(dificulty_progression**(Global.run_stats.current_firewall-1)),
	Stats.List.BASE_HEAL: 0,
	Stats.List.MAX_SHIELD: 0,
	Stats.List.BASE_SHIELD_REPAIR: 0,
	Stats.List.BASE_ATTACK_DAMAGE: 200*(dificulty_progression**(Global.run_stats.current_firewall-1)),
	Stats.List.CRITIC_CHANCE: 0,
	Stats.List.CRITIC_MULTIPLIER: 0,
	Stats.List.MITIGATION_PERCENT: 0,
}
