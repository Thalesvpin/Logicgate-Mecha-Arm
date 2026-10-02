extends Node

signal battle_started(type)
signal battle_ended(type)
signal turn_started(who)
signal turn_ended(who)
signal submit_circuit(execution_sequence_idx: int)
signal pulse(execution_sequence_idx: int)
signal gate_added_to_sandbox(gate)
signal gate_removed_from_sandbox(gate)
signal tick

#region COMBAT
signal damage_taken(amount)
signal damage_dealt(amount)
signal self_damage(amount)
signal attacked
signal critical_hit
signal healed()
signal shield_break
signal heavy_attack_used
signal charged_heavy_attack
signal enemy_defeated(who)
signal repaired_shield(amount)
signal elemental_applied(elemental, enemy)
signal afflicted_by_elemental(elemental)
signal player_defeated
#endregion

#region SHOP
signal tech_mod_added(mod)
signal bio_hack_added(mod)
signal item_bought
signal pack_opened
signal stat_changed(stat, new_value)
#endregion

var signals_list: Dictionary[Trigger.Type, Variant] = {
	Trigger.Type.BATTLE_START: battle_started,
	Trigger.Type.BATTLE_END: battle_ended,
	Trigger.Type.DAMAGE_TAKEN: damage_taken,
	Trigger.Type.DAMAGE_DEALT: damage_dealt,
	Trigger.Type.CRITICAL_HIT: critical_hit,
	Trigger.Type.ENEMY_DEFEATED: enemy_defeated,
	Trigger.Type.TURN_START: turn_started,
	Trigger.Type.TURN_END: turn_ended,
	Trigger.Type.SUBMIT_CIRCUIT: submit_circuit,
	Trigger.Type.PULSE: pulse,
	Trigger.Type.SHIELD_BREAK: shield_break,
	Trigger.Type.BUY_ITEM: item_bought,
	Trigger.Type.HEAVY_ATTACK_USED: heavy_attack_used,
	Trigger.Type.HEAVY_ATTACK_CHARGED: charged_heavy_attack,
	Trigger.Type.ATTACK: attacked,
	Trigger.Type.OPEN_PACK: pack_opened,
	Trigger.Type.GATE_ADDED_TO_SANDBOX: gate_added_to_sandbox,
	Trigger.Type.GATE_REMOVED_FROM_SANDBOX: gate_removed_from_sandbox,
	Trigger.Type.PLAYER_DEFEATED: player_defeated,
}
