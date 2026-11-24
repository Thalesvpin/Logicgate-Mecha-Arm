extends ImplantEffect
class_name DealDamageEffect

##To subtract add a nagative value
@export var amount: int = 0
@export var amount_from_stat: Stats.List = Stats.List.BASE_ATTACK_DAMAGE
@export var multiplier: float = 1.0
@export var target: Who
@export var random_except: WhoExcept

enum Who {CENTER, LEFT, RIGHT, RANDOM, ALL}
enum WhoExcept {NONE, CENTER, LEFT, RIGHT}

func apply(_context = null) -> void:
	print('deal_damage.gd apply()')
	var enemy
	var dmg := float(amount)
	#dmg = Global.run_stats.player_stats[Stats.List.BASE_ATTACK_DAMAGE] + Global.implant_manager.extra_stats[Stats.List.BASE_ATTACK_DAMAGE]
	#dmg *= Global.implant_manager.extra_stats[Stats.List.BASE_ATTACK_DAMAGE_MULT]
	var pos
	if amount == 0:
		dmg = Global.run_stats.player_stats[amount_from_stat]+Global.implant_manager.extra_stats[Stats.List.BASE_ATTACK_DAMAGE]
		dmg *= (multiplier - 1) + Global.implant_manager.extra_stats[Stats.List.BASE_ATTACK_DAMAGE_MULT]
		if _context is int or _context is float:
			dmg = float(_context) * multiplier
	var chance = float(Global.run_stats.player_stats[Stats.List.CRITIC_CHANCE]) + float(Global.implant_manager.extra_stats[Stats.List.CRITIC_CHANCE])
	var crit := float(Global.run_stats.player_stats[Stats.List.CRITIC_MULTIPLIER]) + float(Global.implant_manager.extra_stats[Stats.List.CRITIC_MULTIPLIER])
	if chance > 0.0 and (Global.random.next() % 100) < int(chance):
		dmg *= crit
		EventBus.critical_hit.emit()
	match target:
		Who.CENTER:
			pos = EnemyPosition.Position.CENTER
		Who.LEFT:
			pos = EnemyPosition.Position.LEFT
		Who.RIGHT:
			pos = EnemyPosition.Position.RIGHT
		Who.ALL:
			for _pos in [
				EnemyPosition.Position.CENTER,
				EnemyPosition.Position.LEFT,
				EnemyPosition.Position.RIGHT,
			]:
				enemy = Global.combat_screen.get_enemy(_pos)
				if enemy == null:
					continue
				if enemy.stats[Stats.List.CURRENT_HEALTH] <= 0:
					continue
				if _context is Object and enemy == _context:
					continue
				enemy.take_damage(dmg)
				EventBus.damage_dealt.emit({'enemy': enemy, 'damage': dmg})
			return
		Who.RANDOM:
			var rng = Global.random.next()
			if random_except != WhoExcept.NONE:
				var exception = EnemyPosition.Position.duplicate()
				match random_except:
					WhoExcept.CENTER:
						exception.erase(EnemyPosition.Position.CENTER)
					WhoExcept.LEFT:
						exception.erase(EnemyPosition.Position.LEFT)
					WhoExcept.RIGHT:
						exception.erase(EnemyPosition.Position.RIGHT)
				print('DEAL_DMG exception: ', exception)
				pos = exception.keys()[rng%exception.size()]
			else:
				pos = EnemyPosition.Position.values()[rng%EnemyPosition.Position.size()]
			print('pos random: ', EnemyPosition.Position.keys()[rng%EnemyPosition.Position.size()])
	print('causei %d de dano' % dmg)
	enemy = Global.combat_screen.get_enemy(pos)
	enemy.take_damage(dmg)
	var context = {'enemy': enemy, 'damage': dmg}
	EventBus.damage_dealt.emit(context)

func revert() -> void:
	if !is_permanent:
		Global.run_stats.max_health -= amount
