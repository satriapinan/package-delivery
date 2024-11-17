extends Area3D

var main_scene: Node3D

func _ready():
	main_scene = get_parent()

func _process(delta):
	pass

func _on_body_entered(body):
	main_scene.increment_counter()
	queue_free()

