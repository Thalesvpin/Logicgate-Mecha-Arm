extends Resource
class_name Modifier

#enum Rarity {COMMON, RARE, ULTRA_RARE, LEGENDARY}
enum Type {TECH_MOD=0, BIO_HACK=1}

@export_group('Info')
@export var id: int
@export var name: String
@export_enum('Tech Mod', 'Bio Hack') var type: int
@export var texture: Texture2D
@export var rarity: Global.Rarity
@export var corrupted: bool
##If this value is false, uses_amount will be ignored
@export var consumable: bool
##If is_consumable is false, this value will be ignored
@export var uses_amount: int
@export_group('')

@export_group('Conditions')
#@export var conditions: Array[Condition]
@export_group('')

@export_group('Effects')
@export var damage_multiplier: float
@export var heal_health_multiplier: float
@export var heal_shield_multiplier: float
#@export var : float
#@export var : float
#@export var : float
#@export var : float
@export_group('')


@export_group('')
@export_group('')


@export var trigger: Trigger.Type
@export var effect: Array[ModifierEffect]
@export var target: Target
@export var condition: Array[ModifierCondition]




enum Stats {
	MAX_HEALTH,
	MAX_SHIELD,
	BASE_DAMAGE,
	CRITIC_DAMAGE,
	CRITIC_CHANCE,
}

enum Triggers {
	BATTLE_START,
	BATTLE_END,
	TURN_START,
	TURN_END,
	DAMAGE_DEALT,
	DAMAGE_TAKEN,
	SELF_DAMAGE,
	CRITICAL_HIT,
	CRITICAL_KILL,
	ENEMY_DIED,
	SHIELD_BROKEN,
	SHIELD_REPAIRED,
	HEAL,
	CHARGED_ATTACK,
	BOSS_DEFEATED,
	MODIFIER_USED,
	MODIFIER_SOLD,
	CIRCUIT_SUBMITTED,
	ENEMY_ATTACKED,
	ENEMY_NOT_ATTACKED,
	SHOP_ITEM_PURCHASED,
	ACTION_EXECUTED,
}

enum Effect {
	ADD_STAT,
	MULTIPLY_STAT,
	ADD_STAT_PERMANENT,
	MULTIPLY_STAT_PERMANENT,
	DEAL_DAMAGE,
	HEAL,
	HEAL_PERCENT,
	MULTIPLY_MONEY,
	REPAIR_SHIELD,
	REPAIR_ALL_SHIELDS,
	BREAK_SHIELD,
	ADD_SHIELD,
	ADD_CRIT_CHANCE,
	ADD_CRIT_DAMAGE,
	MULTIPLY_CRIT_DAMAGE,
	GUARANTEE_CRIT,
	DISABLE_CRIT,
	SKIP_ENEMY_TURN,
	REDUCE_ENEMY_ACTIONS,
	ADD_TOKEN,
	DUPLICATE_PULSE,
	MODIFY_GATE_COST,
	MODIFY_GATE_COST_PERMANENT,
	COPY_MODIFIER_EFFECT,
}

enum Target {
	SELF,
	TRIGGER_SOURCE,
	RANDOM_ENEMY,
	ALL_ENEMIES,
	ALL_OTHER_ENEMIES,
	ATTACK_TARGET,
	RANDOM_BIOHACK
}

enum Condition {
	ALWAYS,
	HEALTH_BELOW_PERCENT,
	HEALTH_ABOVE_PERCENT,
	TARGET_IS_BOSS,
	TARGET_IS_NOT_BOSS,
	SHIELD_IS_FULL,
	SHIELD_IS_NOT_FULL,
	DAMAGE_IS_LETHAL,
	DAMAGE_EXCEEDED_TARGET_HEALTH,
	CRITICAL,
	KILL,
	CHARGED_ATTACK_FULL,
	HAS_SPECIAL_AMMO,
	ENEMY_COUNT,
	STAT_COMPARISON
}
