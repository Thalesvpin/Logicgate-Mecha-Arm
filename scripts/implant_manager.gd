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
	Stats.List.BASE_ATTACK_DAMAGE_MULT: 1
}

func _ready() -> void:
	Global.implant_manager = self
	EventBus.tech_mod_added.connect(add_tech_mod)
	EventBus.bio_hack_added.connect(add_bio_hack)

func add_tech_mod(implant: Implant):
	print('implant_manager add tech mod')
	implant = implant.duplicate(true) as Implant
	active_tech_mods.append(implant)
	Global.tech_mods_container.add_implant(implant)
	implant.connect_triggers()
	EventBus.inventory_changed.emit(implant)
	EventBus.on_purchase.emit(implant)

func add_bio_hack(implant: Implant):
	implant = implant.duplicate(true) as Implant
	active_bio_hacks.append(implant)
	Global.bio_hacks_container.add_implant(implant)
	implant.connect_triggers()
	EventBus.inventory_changed.emit(implant)
	EventBus.on_purchase.emit(implant)

func remove_tech_mod(implant: Implant) -> void:
	implant.disconnect_triggers()
	implant.revert()
	active_tech_mods.erase(implant)
	for card in Global.tech_mods_container.implants_holder.get_children():
		if card.resource == implant:
			Global.tech_mods_container.remove_implant(card)
			break
	EventBus.inventory_changed.emit(implant)

func remove_bio_hack(implant: Implant) -> void:
	implant.disconnect_triggers()
	implant.revert()
	active_bio_hacks.erase(implant)
	for card in Global.bio_hacks_container.implants_holder.get_children():
		if card.resource == implant:
			Global.bio_hacks_container.remove_implant(card)
			break
	EventBus.inventory_changed.emit(implant)

func get_random_owned_implant_config(type: Implant.Type, prevent_consumable: bool = true) -> Array[ImplantExecutionConfig]:
	var chance = Global.random.next()
	if type == Implant.Type.TECH_MOD:
		if prevent_consumable:
			while active_tech_mods[chance % active_tech_mods.size()].consumable:
				chance = Global.random.next()
		return active_tech_mods[chance % active_tech_mods.size()].config
	if type == Implant.Type.BIO_HACK:
		if prevent_consumable:
			while active_bio_hacks[chance % active_bio_hacks.size()].consumable:
				chance = Global.random.next()
		return active_bio_hacks[chance % active_bio_hacks.size()].config
	return []

func get_random_owned_implant2(type: Implant.Type, prevent_consumable: bool = true) -> Implant:
	var chance = Global.random.next()
	if type == Implant.Type.TECH_MOD:
		if prevent_consumable:
			while active_tech_mods[chance % active_tech_mods.size()].consumable:
				chance = Global.random.next()
		return active_tech_mods[chance % active_tech_mods.size()]
	if type == Implant.Type.BIO_HACK:
		if prevent_consumable:
			while active_bio_hacks[chance % active_bio_hacks.size()].consumable:
				chance = Global.random.next()
		return active_bio_hacks[chance % active_bio_hacks.size()]
	return null

func get_random_owned_implant(type: Implant.Type, prevent_consumable: bool = true, exclude: Array[Implant] = [], prevent_disabled: bool = true) -> Implant:
	var source := active_tech_mods if type == Implant.Type.TECH_MOD else active_bio_hacks
	var pool: Array[Implant] = []
	for implant in source:
		if prevent_consumable && implant.consumable:
			continue
		if prevent_disabled && implant._disabled:
			continue
		if implant in exclude:
			continue
		pool.append(implant)
	if pool.is_empty():
		return null
	return pool[Global.random.next() % pool.size()]

func get_owned_implant_by_id(type: Implant.Type, id: int) -> Implant:
	if type == Implant.Type.TECH_MOD:
		for implant in active_tech_mods:
			if implant.id == id:
				return implant
	if type == Implant.Type.BIO_HACK:
		for implant in active_bio_hacks:
			if implant.id == id:
				return implant
	return null
