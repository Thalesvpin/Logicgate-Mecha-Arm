extends Node

var active_tech_mods: Array[Modifier] = []
var active_bio_hacks: Array[Modifier] = []

func _ready() -> void:
	EventBus.tech_mod_added.connect(add_tech_mod)
	#EventBus.bio_hack_added.connect(add_tech_mod)
	
	#EventBus.damage_taken.connect(a)
	#EventBus.battle_started.connect(_on_battle_start)
	#EventBus.enemy_defeated.connect(a)
	#EventBus.critical_hit.connect(nova)
	#EventBus.enemy_defeated.connect(tet)

#func a():
	#pass
#
#func tet():
	#apply_effects(Trigger.Type.ENEMY_DEFEATED)
	#

#func nova():
	#print('crit hit')
	#apply_effects(Trigger.Type.CRITICAL_HIT)
#
#func _on_battle_start():
	#print('_on_battle_start')
#
#func apply_effects(trigger: Trigger.Type):
	#for mod in active_tech_mods:
		#if mod.trigger == trigger:
			#for effect in mod.effect:
				#effect.apply()

func add_tech_mod(mod: Modifier):
	active_tech_mods.append(mod)
	mod.connect_triggers()

func add_bio_hacks(mod: Modifier):
	active_bio_hacks.append(mod)
	mod.connect_triggers()
