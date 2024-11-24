extends Control

var main_scene: Node3D
var losing = false
var star: int = 0

@onready var bg_music = $BGMusic
@onready var tween:Tween
var musicPlay = false

func _ready():
	main_scene = get_parent()
	$AnimationLosing.play("RESET")
	$Loading.visible = false

func _process(delta):
	if not losing:
		if ((main_scene.self_counter < main_scene.self_target) && (!main_scene.in_game_ui.timer_running)) || (main_scene.hit_ghost):
			$AnimationLosing.play("dark")
			main_scene.in_game_ui.start = false

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
				
			if main_scene.job_counter == main_scene.job_target:
				if main_scene.hit_ghost:
					star = 1
				else:
					star = 2

			if scene_index >= 0:
				Global.dayProgress[scene_index] = max(Global.dayProgress[scene_index], star)

				for i in range(scene_index + 1):
					var ghost_node_name = "Ghost" + (str(i + 1) if i > 0 else "")
					if main_scene.has_node(ghost_node_name):
						main_scene.get_node(ghost_node_name).start = false

			losing = true

	if losing and not musicPlay:
		main_scene.bg_music.playing = false
		bg_music.play()
		musicPlay = true

	if tween:
		tween.kill()
	tween = create_tween()

	var loading_visible = $Loading.visible
	var volume_target = -5.0 if not loading_visible else -80.0
	tween.tween_property(bg_music, "volume_db", volume_target, 1.0)

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
