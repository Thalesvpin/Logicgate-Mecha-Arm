extends Resource
class_name EnemyConfig

@export var _name: String
@export var texture: Texture2D
@export var health: int
@export var shield: int
@export var actions_list: Array[Enemy.Actions]
@export var actions_per_turn: int
@export var is_boss: bool
#@export var
#stats[Stats.List.BASE_HEAL] = 
#stats[Stats.List.BASE_ATTACK_DAMAGE] = 
#stats[Stats.List.CRITIC_CHANCE] = 
#stats[Stats.List.CRITIC_MULTIPLIER] = 
#stats[Stats.List.MITIGATION_PERCENT] = 
