extends Control

var main_scene: Node3D
var winning = false

@onready var bg_music = $BGMusic
@onready var ending_scene = $Ending
@onready var tween: Tween
@onready var subtitle_label : Label = $SubtitleLabel
var musicPlay = false

func _ready():
	main_scene = get_parent()
	$AnimationWinning.play("RESET")
	$Loading.visible = false
	
	if bg_music.stream:
		bg_music.stream.loop = true
	
	# Tampilkan monolog indeks ke-5 di scene kemenangan
	_show_victory_monolog()

func _process(delta):
	if not winning:
		if main_scene.self_counter == main_scene.self_target:
			if main_scene is Main:
				Global.dayProgress[0] = 3
				main_scene.ghost.start = false
			elif main_scene is Main2:
				Global.dayProgress[1] = 3
				main_scene.ghost.start = false
				main_scene.ghost2.start = false
			elif main_scene is Main3:
				Global.dayProgress[2] = 3
				main_scene.ghost.start = false
				main_scene.ghost2.start = false
				main_scene.ghost3.start = false
			elif main_scene is Main4:
				Global.dayProgress[3] = 3
				main_scene.ghost.start = false
				main_scene.ghost2.start = false
				main_scene.ghost3.start = false
				main_scene.ghost4.start = false
			elif main_scene is Main5:
				Global.dayProgress[4] = 3
				main_scene.ghost.start = false
				main_scene.ghost2.start = false
				main_scene.ghost3.start = false
				main_scene.ghost4.start = false
				main_scene.ghost5.start = false
		
			$AnimationWinning.play("dark")
			winning = true
	
	if winning and not musicPlay:
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

func _show_victory_monolog():
	var current_scene = get_tree().current_scene
	var monologs = []
	
	if current_scene is Main:
		monologs = Global.monologDay1
	elif current_scene is Main2:
		monologs = Global.monologDay2
	elif current_scene is Main3:
		monologs = Global.monologDay3
	elif current_scene is Main4:
		monologs = Global.monologDay4
	elif current_scene is Main5:
		monologs = Global.monologDay5
	
	if monologs.size() > 5:
		subtitle_label.text = monologs[5]

func _on_menu_utama_pressed():
	$ButtonClick.play()
	$Loading.visible = true
	
	await get_tree().create_timer(5.0).timeout

	if main_scene is Main5:
		get_tree().change_scene_to_file("res://Scene/Ending/EndingScene.tscn")
	else:
		get_tree().change_scene_to_file("res://Scene/MainMenu/MainMenu.tscn")
	
	$Loading.visible = false

