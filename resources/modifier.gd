extends Resource
class_name Modifier

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


@export var trigger: Trigger.Type
@export var effect: Array[ModifierEffect]
@export var custom_effect: bool = false
@export var condition: Array[ModifierCondition]

func connect_triggers() -> void:
	for ef in effect:
		EventBus.signals_list[trigger].connect(check_condition)

func check_condition() -> void:
	var counter = 0
	for con in condition:
		if con.is_met():
			counter += 1
	if condition.size() == counter:
		for ef in effect:
			ef.apply()
