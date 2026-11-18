extends PanelContainer

@onready var firewall_counter: RichTextLabel = $HBoxContainer/FirewallCounter
@onready var dificulty_label: RichTextLabel = $HBoxContainer/DificultyLabel
@onready var run_time: RichTextLabel = $HBoxContainer/RunTime
@onready var clock: RichTextLabel = $HBoxContainer/Clock
@onready var fps: RichTextLabel = $HBoxContainer/FPS

func _ready() -> void:
	EventBus.battle_ended.connect(update_battle)
	EventBus.close_shop.connect(update_battle)

func _process(delta: float) -> void:
	var time = Time.get_time_dict_from_system() 
	var curr_run_time = Global.run_stats.current_run_time
	run_time.text = "Tempo da run: %02d:%02d:%02d | " % [curr_run_time/(60*60), int(curr_run_time/60)%60, int(curr_run_time)%60]
	clock.text = ''
	clock.add_image(preload("uid://dtdmncjvb5ehx"), 18, 18)
	clock.add_text(" %02d:%02d" % [time.hour, time.minute])
	fps.text = ' | FPS: %d  ' % Engine.get_frames_per_second()

func update_battle(arg=null) -> void:
	await get_tree().create_timer(0.3).timeout
	var fire_wall = Global.run_stats.current_firewall
	
	var curr_battle = Global.run_stats.current_battle
	var text
	if Global.turn_manager.is_shop_open:
		text = 'LOJA (%d)' % (curr_battle-1)
	else:
		firewall_counter.text = str(fire_wall)
		match curr_battle % 3:
			1:
				text = 'BATALHA FÁCIL'
			2:
				text = 'BATALHA DIFÍCIL'
			0:
				text = 'BATALHA CONTRA CHEFE'
		text += ' (%d)' % curr_battle
	dificulty_label.text = text
