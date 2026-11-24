extends ImplantCondition
class_name UniqueRarityCondition

@export var implant: Implant.Type
var bought

func is_met(context = null) -> bool:
	bought = context
	if implant:
		match implant:
			Implant.Type.TECH_MOD:
				return check_rarity(Global.implant_manager.active_tech_mods)
			Implant.Type.BIO_HACK:
				return check_rarity(Global.implant_manager.active_bio_hacks)
	return false

func check_rarity(array: Array[Implant]) -> bool:
	var count: Dictionary[Global.Rarity, int] = {
		Global.Rarity.COMMON: 0,
		Global.Rarity.RARE: 0,
		Global.Rarity.ULTRA_RARE: 0,
		Global.Rarity.LEGENDARY: 0,
	}
	for _implant in array:
		if _implant == bought:
			continue
		count[_implant.rarity] += 1
	
	return  count[bought.rarity] == 0
