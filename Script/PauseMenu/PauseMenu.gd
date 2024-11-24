extends Control

var pause_start_time: float = 0.0
var paused_duration: float = 0.0 

func _ready():
	$AnimationPlayerPause.play("RESET")
	$".".visible = false

func _process(delta):
	_test_esc()
	if get_tree().paused:
		paused_duration = Time.get_ticks_msec() / 1000.0 - pause_start_time

func _resume():
	get_tree().paused = false
	$AnimationPlayerPause.play_backwards("dark")
	var in_game_ui = get_parent().get_node("UI")
	if in_game_ui:
		in_game_ui.paused_time += paused_duration
		paused_duration = 0.0

func _pause():
	get_tree().paused = true
	pause_start_time = Time.get_ticks_msec() / 1000.0
	$AnimationPlayerPause.play("dark")

func _test_esc():
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		$".".visible = true
		_pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		$".".visible = false
		_resume()

func _on_texture_button_resume_pressed():
	$ButtonClick.play()
	$".".visible = false
	_resume()

func _on_texture_button_main_menu_pressed():
	$ButtonClick.play()
	$".".visible = false
	_resume()
	get_tree().change_scene_to_file("res://Scene/MainMenu/MainMenu.tscn")
