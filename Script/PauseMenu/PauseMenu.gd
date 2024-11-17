extends Control

func _ready():
	$AnimationPlayerPause.play("RESET")
	$".".visible = false

func _process(delta):
	_test_esc()

func _resume():
	get_tree().paused = false
	$AnimationPlayerPause.play_backwards("dark")

func _pause():
	get_tree().paused = true
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
