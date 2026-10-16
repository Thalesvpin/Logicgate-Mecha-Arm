extends Resource
class_name EnemyConfig

@export var _name: String
@export var texture: Texture2D
@export var health: int
@export var shield: int
@export var base_damage: int
@export_range(0, 100, 0.1, 'suffix:%') var mitigation: float
@export var heal: float
@export var shield_repair: float
@export var actions_list: Array[Enemy.Actions]
##Must follow the same order as actions_list
@export_range(1, 100, 0.1, 'suffix:%') var actions_weight: Array[float]
@export var actions_per_turn: int
@export var is_boss: bool
