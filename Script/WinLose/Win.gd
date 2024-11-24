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

	_show_victory_monolog()

func _process(delta):
	if not winning:
		if main_scene.self_counter == main_scene.self_target:
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
				Global.dayProgress[scene_index] = 3

				for i in range(scene_index + 1):
					var ghost_node_name = "Ghost" + (str(i + 1) if i > 0 else "")
					if main_scene.has_node(ghost_node_name):
						main_scene.get_node(ghost_node_name).start = false

			$AnimationWinning.play("dark")
			winning = true

	if winning and not musicPlay:
		main_scene.bg_music.playing = false
		bg_music.play()
		musicPlay = true

	if tween:
		tween.kill()
	tween = create_tween()

	tween.tween_property(bg_music, "volume_db", -80.0 if $Loading.visible else -5.0, 1.0)

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

