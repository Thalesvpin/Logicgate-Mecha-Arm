extends ImplantEffect
class_name AddStatPerOwnedEffect

enum CountMode {EACH, UNIQUE_RARITY}
enum ImplantType {BIO_HACK, TECH_MOD, BOTH}

@export var stat: Stats.List
@export var amount: float = 0.0
@export var implant_type: ImplantType
@export var count_mode: CountMode = CountMode.UNIQUE_RARITY
var applied: float = 0.0

func count() -> int:
	var list: Array[Implant]
	match implant_type:
		ImplantType.BIO_HACK:
			list = Global.implant_manager.active_bio_hacks
		ImplantType.TECH_MOD:
			list = Global.implant_manager.active_tech_mods
		ImplantType.BOTH:
			list = Global.implant_manager.active_bio_hacks
			list.append(Global.implant_manager.active_tech_mods)
	
	if count_mode == CountMode.EACH:
		return list.size()
	var seen = {}
	for imp in list:
		seen[imp.rarity] = true
	return seen.size()

func apply(_context = null) -> void:
	var desired = amount * count()
	var delta = desired - applied
	if delta == 0.0:
		return
	add_to_extra_stats(stat, delta, lesser, 0)
	applied = desired

func revert() -> void:
	if is_permanent || applied == 0.0:
		return
	add_to_extra_stats(stat, -applied, lesser, 0)
	applied = 0.0
