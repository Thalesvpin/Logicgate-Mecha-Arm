extends Node
class_name Enemy

enum Type {MINION, BOSS}

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
