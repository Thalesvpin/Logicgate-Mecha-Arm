extends Resource
class_name Implant

enum Type {TECH_MOD=0, BIO_HACK=1}

@export_group('Info')
@export var id: int
@export var name: String
@export_multiline var description: String
@export_enum('Tech Mod', 'Bio Hack') var type: int
@export var texture: Texture2D
@export var rarity: Global.Rarity
@export var corrupted: bool
##If this value is false, uses_amount will be ignored[br]If true, trigger will be ignored
@export var consumable: bool
##If is_consumable is false, this value will be ignored
@export var uses_amount: int
@export_group('')

##If consumable, trigger will be ignored
@export var trigger: Trigger.Type
@export var effect: Array[ImplantEffect]
#@export var custom_effect: bool = false
##All conditions must be met to execute
@export var conditions: Array[ImplantCondition]
@export var config: Array[ImplantExecutionConfig]

const PRICES: Dictionary[Global.Rarity, int] = {
	Global.Rarity.COMMON: 300,
	Global.Rarity.RARE: 400,
	Global.Rarity.ULTRA_RARE: 500,
	Global.Rarity.LEGENDARY: 600,
}

func connect_triggers() -> void:
	for item in config:
		for condition in item.conditions:
			for ef in item.effect:
				condition.abort.connect(ef.revert)
	if consumable:
		return
	for module in config:
		for ef in module.effect:
			EventBus.signals_list[module.trigger].connect(check_condition.bind(module))

static func check_condition(context = null, module: ImplantExecutionConfig = null) -> void:
	var counter = 0
	for con in module.conditions:
		if con.is_met(context):
			counter += 1
	if module.conditions.size() == counter:
		for ef in module.effect:
			ef.apply(context)

func revert() -> void:
	for module in config:
		for ef in module.effect:
			ef.revert()

#func connect_triggers2() -> void:
	#if consumable:
		#return
	#for ef in effect:
		#EventBus.signals_list[trigger].connect(check_condition)
#
#func check_condition2(context = null) -> void:
	#var counter = 0
	#for con in conditions:
		#if con.is_met(context):
			#counter += 1
	#if conditions.size() == counter:
		#for ef in effect:
			#ef.apply(context)
#
#func revert2() -> void:
	#for ef in effect:
		#ef.revert()
