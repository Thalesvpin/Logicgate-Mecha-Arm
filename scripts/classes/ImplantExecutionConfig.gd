extends Resource
class_name  ImplantExecutionConfig

##If consumable, trigger will be ignored
@export var trigger: Trigger.Type
@export var effect: Array[ModifierEffect]
@export var custom_effect: bool = false
##All conditions must be met to execute
@export var conditions: Array[ImplantCondition]
