extends Node

var active_tech_mods: Array[Implant] = []
var active_bio_hacks: Array[Implant] = []

var extra_stats: Dictionary[Stats.List, Variant] = {
	Stats.List.MAX_HEALTH: 0,
	Stats.List.BASE_HEAL: 0,
	Stats.List.BASE_ATTACK_DAMAGE: 0,
	Stats.List.CRITIC_CHANCE: 0,
	Stats.List.CRITIC_MULTIPLIER: 0,
	Stats.List.MITIGATION_PERCENT: 0,
}


func _ready() -> void:
	Global.modifier_manager = self
	EventBus.tech_mod_added.connect(add_tech_mod)
	EventBus.bio_hack_added.connect(add_bio_hack)
	#EventBus.submit_circuit.connect()
	
	#EventBus.damage_taken.connect(a)
	#EventBus.battle_started.connect(_on_battle_start)
	#EventBus.enemy_defeated.connect(a)
	#EventBus.critical_hit.connect(nova)
	#EventBus.enemy_defeated.connect(tet)


func add_tech_mod(mod: Implant):
	print('mod_manager add tech mod')
	active_tech_mods.append(mod)
	mod.connect_triggers()

func add_bio_hack(mod: Implant):
	active_bio_hacks.append(mod)
	mod.connect_triggers()
