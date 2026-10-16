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
	var dmg = Global.run_stats.player_stats[Stats.List.BASE_ATTACK_DAMAGE] + Global.implant_manager.extra_stats[Stats.List.BASE_ATTACK_DAMAGE]
	var pos
	
	if amount == 0:
		dmg = Global.run_stats.player_stats[amount_from_stat] * multiplier
	match target:
		Who.CENTER:
			pos = EnemyPosition.Position.CENTER
		Who.LEFT:
			pos = EnemyPosition.Position.LEFT
		Who.RIGHT:
			pos = EnemyPosition.Position.RIGHT
		Who.ALL:
			pos = EnemyPosition.Position.CENTER
			Global.combat_screen.get_enemy(pos).take_damage(dmg)
			pos = EnemyPosition.Position.LEFT
			Global.combat_screen.get_enemy(pos).take_damage(dmg)
			pos = EnemyPosition.Position.RIGHT
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
	print('dano: ', dmg)
	var enemy = Global.combat_screen.get_enemy(pos)
	enemy.take_damage(dmg)
	var context = {'enemy': enemy, 'damage': dmg}
	EventBus.damage_dealt.emit(context)

func revert() -> void:
	if !is_permanent:
		Global.run_stats.max_health -= amount
