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
	Stats.List.BASE_SHIELD_REPAIR: 0,
}


func _ready() -> void:
	Global.implant_manager = self
	EventBus.tech_mod_added.connect(add_tech_mod)
	EventBus.bio_hack_added.connect(add_bio_hack)
	#EventBus.submit_circuit.connect()
	
	#EventBus.damage_taken.connect(a)
	#EventBus.battle_started.connect(_on_battle_start)
	#EventBus.enemy_defeated.connect(a)
	#EventBus.critical_hit.connect(nova)
	#EventBus.enemy_defeated.connect(tet)


func add_tech_mod(implant: Implant):
	print('implant_manager add tech mod')
	active_tech_mods.append(implant)
	Global.tech_mods_container.add_implant(implant)
	implant.connect_triggers()

func add_bio_hack(implant: Implant):
	active_bio_hacks.append(implant)
	Global.bio_hacks_container.add_implant(implant)
	implant.connect_triggers()

func remove_tech_mod(implant: Node):
	implant.resource.revert()
	Global.tech_mods_container.remove_implant(implant)
	active_tech_mods.erase(implant.resource)

func remove_bio_hack(implant: Node):
	implant.revert()
	Global.bio_hacks_container.remove_implant(implant)
	active_bio_hacks.erase(implant.resource)
