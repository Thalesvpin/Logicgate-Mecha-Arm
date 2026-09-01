extends Node

signal battle_started()
signal battle_ended()
signal turn_started()
signal turn_ended()
signal tick()

signal damage_taken(amount)
signal damage_dealt(amount)
signal critical_hit
signal healed()

signal enemy_defeated

signal tech_mod_added(mod)
signal bio_hack_added(mod)




signal repaired_shield(amount)
signal stat_changed(stat, new_value)
