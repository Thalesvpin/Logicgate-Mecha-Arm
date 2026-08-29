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
@export var conditions: Array[Condition]
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
