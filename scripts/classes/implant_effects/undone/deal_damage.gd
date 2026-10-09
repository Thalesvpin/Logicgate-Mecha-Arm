extends ModifierEffect
class_name DealDamageEffect

##To subtract add a nagative value
@export var amount: int = 0

func apply(context = null) -> void:
	var dmg = Global.run_stats.player_stats[Stats.List.BASE_ATTACK_DAMAGE] + Global.implant_manager.extra_stats[Stats.List.BASE_ATTACK_DAMAGE]
	Global.combat_screen.get_enemy(EnemyPosition.Position.CENTER).take_damage(dmg)

func revert() -> void:
	if !is_permanent:
		Global.run_stats.max_health -= amount
