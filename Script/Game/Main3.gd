extends Node3D

class_name Main3

var job_target: int = 10
var job_counter: int = 0

var self_target: int = 9
var self_counter: int = 0

var hit_ghost: bool = false

@onready var in_game_ui = $UI
@onready var bg_music = $DarkMusic
@onready var pickup_se = $PickUp
@onready var ghost = $Ghost
@onready var ghost2 = $Ghost2
@onready var ghost3 = $Ghost3

func _ready():
	$Win.visible = false
	$Lose.visible = false

	bg_music.play()
	if bg_music.stream:
		bg_music.stream.loop = true

func _process(delta):
	if self_counter == self_target:
		$Win.visible = true
		$UI.visible = false
	elif ((self_counter < self_target) && (!in_game_ui.timer_running)) || (hit_ghost):
		$Lose.visible = true
		$UI.visible = false

func increment_counter():
	pickup_se.play()
	if job_counter < job_target:
		job_counter += 1
	else:
		self_counter += 1
