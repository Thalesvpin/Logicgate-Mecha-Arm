extends Node

signal battle_started(context)
signal battle_ended(context)
signal turn_started(context)
signal turn_ended(context)
signal submit_circuit
signal pulse(execution_sequence_idx: int)
signal gate_added_to_sandbox(gate)
signal gate_removed_from_sandbox(gate)
signal tick

#region COMBAT
signal damage_taken(context)
signal damage_dealt(context)
signal self_damage
signal attacked(context)
signal critical_hit
signal healed
signal shield_break
signal heavy_attack_used
signal charged_heavy_attack
signal enemy_defeated(context)
signal repaired_shield(context)
signal elemental_applied(elemental, enemy)
signal afflicted_by_elemental(elemental)
signal player_defeated
#endregion

#region SHOP
signal tech_mod_added(implant)
signal bio_hack_added(implant)
signal item_bought(context)
signal on_purchase(implant)
signal pack_opened(context)
signal stat_changed(stat: Stats.List, new_value)
signal open_shop
#endregion

var signals_list: Dictionary[Trigger.Type, Variant] = {
	Trigger.Type.BATTLE_START: battle_started,
	Trigger.Type.BATTLE_END: battle_ended,
	Trigger.Type.DAMAGE_TAKEN: damage_taken,
	Trigger.Type.DAMAGE_DEALT: damage_dealt,
	Trigger.Type.SELF_DAMAGE: self_damage,
	Trigger.Type.CRITICAL_HIT: critical_hit,
	Trigger.Type.ENEMY_DEFEATED: enemy_defeated,
	Trigger.Type.TURN_START: turn_started,
	Trigger.Type.TURN_END: turn_ended,
	Trigger.Type.SUBMIT_CIRCUIT: submit_circuit,
	Trigger.Type.PULSE: pulse,
	Trigger.Type.SHIELD_BREAK: shield_break,
	Trigger.Type.BUY_ITEM: item_bought,
	Trigger.Type.ON_PURCHASE: on_purchase,
	Trigger.Type.HEAVY_ATTACK_USED: heavy_attack_used,
	Trigger.Type.HEAVY_ATTACK_CHARGED: charged_heavy_attack,
	Trigger.Type.ATTACK: attacked,
	Trigger.Type.OPEN_PACK: pack_opened,
	Trigger.Type.GATE_ADDED_TO_SANDBOX: gate_added_to_sandbox,
	Trigger.Type.GATE_REMOVED_FROM_SANDBOX: gate_removed_from_sandbox,
	Trigger.Type.PLAYER_DEFEATED: player_defeated,
}
