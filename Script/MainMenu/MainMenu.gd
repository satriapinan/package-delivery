extends Control

class_name MainMenu

var daySelected = 0

var main_scene1 = preload("res://Scene/Game/Main.tscn")
var main_scene2 = preload("res://Scene/Game/Main2.tscn")
var main_scene3 = preload("res://Scene/Game/Main3.tscn")
var main_scene4 = preload("res://Scene/Game/Main4.tscn")
var main_scene5 = preload("res://Scene/Game/Main5.tscn")

@onready var bg_music = $BGMusic
@onready var tween:Tween

func _ready():
	$ControlSelectDay.visible = false
	$ControlDetailLevel.visible = false
	$Loading.visible = false

	bg_music.play()
	if bg_music.stream:
		bg_music.stream.loop = true

func _process(delta):
	if tween:
		tween.kill()
	tween = create_tween()

	var menu_visible = $ControlSelectDay.visible == true  || $ControlDetailLevel.visible == true
	var loading_visible = $Loading.visible == true
	
	if menu_visible && !loading_visible:
		tween.tween_property(bg_music, "volume_db", -20.0, 1.0)
	elif loading_visible:
		tween.tween_property(bg_music, "volume_db", -80.0, 2.0)
	else:
		tween.tween_property(bg_music, "volume_db", -5.0, 1.0)

func _load_star_image(progress):
	var loadTexture = ""
	if progress == 0:
		loadTexture = "res://assets/Textures/Star/Star0Texture.png"
	elif progress == 1:
		loadTexture = "res://assets/Textures/Star/Star1Texture.png"
	elif progress == 2:
		loadTexture = "res://assets/Textures/Star/Star2Texture.png"
	elif progress == 3:
		loadTexture = "res://assets/Textures/Star/Star3Texture.png"
	
	return loadTexture

func _load_star():
	for i in range(Global.dayProgress.size()):
		$ControlSelectDay.get_node("TextureRectStarDay" + str(i + 1)).texture = ResourceLoader.load(_load_star_image(Global.dayProgress[i]))

func _load_day_progress():
	for i in range(1, Global.dayProgress.size()):
		$ControlSelectDay.get_node("PanelSelectDay/CenterContainerDayList/HBoxContainerDayList/TextureButtonDay" + str(i + 1)).disabled = Global.dayProgress[i - 1] != 3

func _on_button_play_pressed():
	$ButtonClick.play()
	_load_star()
	_load_day_progress()
	$ControlSelectDay.visible = true
	$ControlSelectDay/AnimationPlayerSelectDay.play("dark")
	$ControlSelectDay.top_level = true

func _on_texture_button_select_day_back_pressed():
	$ButtonClick.play()
	$ControlSelectDay/AnimationPlayerSelectDay.play_backwards("dark")
	await get_tree().create_timer(0.2).timeout
	$ControlSelectDay.top_level = false
	$ControlSelectDay.visible = false

func _show_detail_level(day):
	$ControlSelectDay/AnimationPlayerSelectDay.play_backwards("dark")
	$ControlSelectDay.top_level = false
	await get_tree().create_timer(0.2).timeout
	$ControlSelectDay.visible = false
	$ControlDetailLevel.visible = true
	$ControlDetailLevel/PanelDetailLevel/TextureRectDetailLevel.texture = ResourceLoader.load("res://assets/Textures/DetailLevel/DetailLevelDay" + str(day) + ".png")
	$ControlDetailLevel/AnimationPlayerDetailLevel.play("dark")
	$ControlDetailLevel.top_level = true
	daySelected = day

func _on_texture_button_day_1_pressed():
	$ButtonClick.play()
	_show_detail_level(1)

func _on_texture_button_day_2_pressed():
	$ButtonClick.play()
	_show_detail_level(2)

func _on_texture_button_day_3_pressed():
	$ButtonClick.play()
	_show_detail_level(3)

func _on_texture_button_day_4_pressed():
	$ButtonClick.play()
	_show_detail_level(4)

func _on_texture_button_day_5_pressed():
	$ButtonClick.play()
	_show_detail_level(5)

func _on_texture_button_detail_level_back_pressed():
	$ButtonClick.play()
	$ControlDetailLevel/AnimationPlayerDetailLevel.play_backwards("dark")
	$ControlDetailLevel.top_level = false
	await get_tree().create_timer(0.2).timeout
	$ControlDetailLevel.visible = false
	$ControlSelectDay.visible = true
	$ControlSelectDay/AnimationPlayerSelectDay.play("dark")
	$ControlSelectDay.top_level = true

func _on_texture_button_detail_level_start_day_pressed():
	$ButtonClick.play()
	$ControlDetailLevel.top_level = false

	$Loading.visible = true

	await get_tree().create_timer(5.0).timeout

	match daySelected:
		1: get_tree().change_scene_to_packed(main_scene1)
		2: get_tree().change_scene_to_packed(main_scene2)
		3: get_tree().change_scene_to_packed(main_scene3)
		4: get_tree().change_scene_to_packed(main_scene4)
		5: get_tree().change_scene_to_packed(main_scene5)

	$Loading.visible = false

func _on_button_exit_pressed():
	$ButtonClick.play()
	get_tree().quit()
