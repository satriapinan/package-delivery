extends Control

@onready var credit_scene = $Ending

func _ready():
	credit_scene.play()

func change_scene_to_main_menu():
	get_tree().change_scene_to_file("res://Scene/MainMenu/MainMenu.tscn")

func _on_ending_finished():
	change_scene_to_main_menu()
