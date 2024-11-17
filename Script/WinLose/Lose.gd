extends Control

var main_scene: Node3D
var losing = false

@onready var bg_music = $BGMusic
@onready var tween:Tween
var musicPlay = false

func _ready():
	main_scene = get_parent()
	$AnimationLosing.play("RESET")
	$Loading.visible = false

func _process(delta):
	if losing == false:
		if ((main_scene.self_counter < main_scene.self_target) && (!main_scene.in_game_ui.timer_running)) || (main_scene.hit_ghost):
			$AnimationLosing.play("dark")
			main_scene.in_game_ui.start = false
			if main_scene is Main:
				main_scene.ghost.start = false
			elif main_scene is Main2:
				main_scene.ghost.start = false
				main_scene.ghost2.start = false
			elif main_scene is Main3:
				main_scene.ghost.start = false
				main_scene.ghost2.start = false
				main_scene.ghost3.start = false
			elif main_scene is Main4:
				main_scene.ghost.start = false
				main_scene.ghost2.start = false
				main_scene.ghost3.start = false
				main_scene.ghost4.start = false
			elif main_scene is Main5:
				main_scene.ghost.start = false
				main_scene.ghost2.start = false
				main_scene.ghost3.start = false
				main_scene.ghost4.start = false
				main_scene.ghost5.start = false
			losing = true
	
	if losing && !musicPlay:
		main_scene.bg_music.playing = false

		bg_music.play()
		musicPlay = true

	if tween:
		tween.kill()
	tween = create_tween()

	var loading_visible = $Loading.visible == true
	
	if loading_visible:
		tween.tween_property(bg_music, "volume_db", -80.0, 4.0)
	else:
		tween.tween_property(bg_music, "volume_db", -5.0, 1.0)

func _on_menu_utama_pressed():
	$ButtonClick.play()
	$Loading.visible = true

	await get_tree().create_timer(5.0).timeout

	get_tree().change_scene_to_file("res://Scene/MainMenu/MainMenu.tscn")
	$Loading.visible = false

func _on_try_again_pressed():
	$ButtonClick.play()
	$Loading.visible = true

	await get_tree().create_timer(5.0).timeout

	get_tree().reload_current_scene()
	$Loading.visible = false
