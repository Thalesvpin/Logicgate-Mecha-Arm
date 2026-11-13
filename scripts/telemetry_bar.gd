extends PanelContainer

@onready var firewall_counter: RichTextLabel = $HBoxContainer/FirewallCounter
@onready var dificulty_label: RichTextLabel = $HBoxContainer/DificultyLabel
@onready var run_time: RichTextLabel = $HBoxContainer/RunTime
@onready var clock: RichTextLabel = $HBoxContainer/Clock
@onready var fps: RichTextLabel = $HBoxContainer/FPS

func _ready() -> void:
	EventBus.battle_ended.connect(update_battle)

func _process(delta: float) -> void:
	var time = Time.get_time_dict_from_system() 
	var curr_run_time = Global.run_stats.current_run_time
	run_time.text = "Tempo da run: %02d:%02d:%02d" % [curr_run_time/(60*60), int(curr_run_time/60)%60, int(curr_run_time)%60]
	clock.text = " | %02d:%02d" % [time.hour, time.minute]
	fps.text = ' | FPS: %d  ' % Engine.get_frames_per_second()

func update_battle(arg) -> void:
	await get_tree().create_timer(0.1).timeout
	print('current_battle: ', Global.run_stats.current_battle)
	var fire_wall = Global.run_stats.current_firewall
	firewall_counter.text = str(fire_wall)
	
	var curr_battle = Global.run_stats.current_battle
	var curr_turn = Global.run_stats.current_turn
	var text
	match curr_battle:
		1:
			text = 'FÁCIL'
		2:
			text = 'MÉDIO'
		3:
			text = 'DIFÍCIL'
	text += ' (%d)' % curr_turn
	dificulty_label.text = text
