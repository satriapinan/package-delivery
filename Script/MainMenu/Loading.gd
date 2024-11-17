extends Control

@onready var loading_label: Label = $Panel/Label

var dot_count: int = 0
var timer: float = 0.0
var interval: float = 1.0

func _ready():
	pass

func _process(delta):
	timer += delta
	if timer >= interval:
		timer = 0.0
		dot_count += 1
		if dot_count > 3:
			dot_count = 0
		
		var dots = ".".repeat(dot_count)
		loading_label.text = "Loading" + dots
