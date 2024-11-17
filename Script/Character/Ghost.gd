extends CharacterBody3D

var main_scene: Node3D

const SPEED = 2.0
var hero
var start = false

@export var turn_speed = 4.0

func _ready():
	main_scene = get_parent()
	hero = get_tree().get_nodes_in_group("Perfi")[0]

func _physics_process(delta):
	if start:
		$FaceDirection.look_at(hero.global_transform.origin, Vector3.UP)
		rotate_y(deg_to_rad($FaceDirection.rotation.y * turn_speed))
		$NavigationAgent3D.set_target_position(hero.global_transform.origin)
		var velocity = ($NavigationAgent3D.get_next_path_position() - transform.origin).normalized() * SPEED * delta
		var collision_info = move_and_collide(velocity)
		
		# Check for collision with hero
		if collision_info:
			var collider = collision_info.get_collider()
			if collider == hero:
				main_scene.hit_ghost = true
