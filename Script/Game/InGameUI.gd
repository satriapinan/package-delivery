extends Control

var main_scene: Node3D
var timer_start: float = 0.0
var elapsed_time: float = 0.0
var time_limit: float = 6 * 60
var warning_time: float = 10.0
var last_second: int = -1
var timer_running: bool = true
var start = false
var first_subtitle_delay = false

var monologs = []
var current_monolog_index = 0
var subtitle_duration = 5.0
var subtitle_interval = 60.0
var time_since_last_subtitle = 0.0
var paused_time: float = 0.0  # Track paused time

@onready var subtitle_label : Label = $SubtitleLabel

func _ready():
	main_scene = get_parent()
	$TextureRectDarkBG.visible = false
	$PanelPetunjuk.visible = false
	
	$JobTarget.text = str(main_scene.job_counter) + "/" + str(main_scene.job_target) 
	$SelfTarget.text = str(main_scene.self_counter) + "/" + str(main_scene.self_target)

	var current_scene = get_tree().current_scene
	if current_scene is Main:
		$PanelPetunjuk.visible = true
		$TextureRectDarkBG.visible = true
		monologs = Global.monologDay1
	elif current_scene is Main2:
		monologs = Global.monologDay2
		_play()
	elif current_scene is Main3:
		monologs = Global.monologDay3
		_play()
	elif current_scene is Main4:
		monologs = Global.monologDay4
		_play()
	elif current_scene is Main5:
		monologs = Global.monologDay5
		_play()

	current_monolog_index = 0
	time_since_last_subtitle = 0.0

func _process(delta):
	if timer_running and start:
		elapsed_time = Time.get_ticks_msec() / 1000.0 - timer_start - paused_time
		var remaining_time = time_limit - elapsed_time
		if remaining_time < 0:
			remaining_time = 0
			timer_running = false
		
		var minutes = int(remaining_time) / 60
		var seconds = int(remaining_time) % 60
		var time_text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
		
		$JobTarget.text = str(main_scene.job_counter) + " / " + str(main_scene.job_target) 
		$SelfTarget.text = str(main_scene.self_counter) + " / " + str(main_scene.self_target)
		$Timer.text = time_text
		
		if remaining_time <= warning_time:
			$Timer.add_theme_color_override("font_color", Color(1, 0, 0))
			if seconds != last_second:
				$Second.play()
				last_second = seconds
		else:
			$Timer.add_theme_color_override("font_color", Color(0, 0, 0))

		if start:
			time_since_last_subtitle += delta
			if time_since_last_subtitle >= subtitle_interval:
				time_since_last_subtitle -= subtitle_interval
				_show_subtitle()

func _show_subtitle():
	if start and current_monolog_index < monologs.size():
		if first_subtitle_delay:
			_delay_first_subtitle()
			first_subtitle_delay = false
		else:
			subtitle_label.text = monologs[current_monolog_index]
			_clear_subtitle_after_delay(subtitle_duration)
			current_monolog_index += 1

func _delay_first_subtitle():
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.autostart = true
	add_child(timer)
	await timer.timeout
	subtitle_label.text = monologs[current_monolog_index]
	_clear_subtitle_after_delay(subtitle_duration)
	current_monolog_index += 1

func _clear_subtitle_after_delay(duration: float):
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.autostart = true
	add_child(timer)
	await timer.timeout
	subtitle_label.text = ""

func _on_texture_button_petunjuk_back_pressed():
	$ButtonClick.play()
	$TextureRectDarkBG.visible = false
	$PanelPetunjuk.visible = false
	
	_play()

func _play():
	timer_start = Time.get_ticks_msec() / 1000.0
	last_second = -1
	timer_running = true
	start = true
	first_subtitle_delay = true 
	
	var scene_index = -1
	if main_scene is Main:
		scene_index = 0
	elif main_scene is Main2:
		scene_index = 1
	elif main_scene is Main3:
		scene_index = 2
	elif main_scene is Main4:
		scene_index = 3
	elif main_scene is Main5:
		scene_index = 4

	if scene_index >= 0:
		for i in range(scene_index + 1):
			var ghost_node_name = "Ghost" + (str(i + 1) if i > 0 else "")
			if main_scene.has_node(ghost_node_name):
				main_scene.get_node(ghost_node_name).start = true

	_show_subtitle()
