extends CharacterBody3D

var main_scene: Node3D

var SPEED = 3.0
const RUN_MULTIPLIER = 1.5
const JUMP_VELOCITY = 4.5
const MOVEMENT_SMOOTHNESS = 0.1
#const MAX_TILT_ANGLE = 360.0
const TILT_SENSITIVITY = 10.0

var current_speed = SPEED 
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var tilt_angle = 0.0
var is_tilting = false
var mouse_motion = Vector2.ZERO
var is_moving = false
var is_running = false
var is_in_air = false

@onready var spring_arm = $SpringArm3D
@onready var camera = $SpringArm3D/Camera3D
@onready var model = $Rig
@onready var anim_tree = $AnimationTree
@onready var anim_state = $AnimationTree.get("parameters/playback")
@onready var light = $SpotLight3D
@onready var walk_sound = $Walk
@onready var tween: Tween

func _ready():
	main_scene = get_parent()
	
	if main_scene is Main2:
		SPEED -= 0.35
	elif main_scene is Main3:
		SPEED -= 0.6
	elif main_scene is Main4:
		SPEED -= 0.85
	elif main_scene is Main5:
		SPEED -= 1.1

	if walk_sound.stream:
		walk_sound.stream.loop = true
	
	walk_sound.volume_db = -30
	max_slides = 5

func _input(event):
	if event is InputEventMouseMotion and is_tilting:
		mouse_motion = event.relative

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		if not is_in_air:
			fade_out_walk_sound()
			is_in_air = true
	else:
		if is_in_air:
			if is_moving:
				fade_in_walk_sound()
			is_in_air = false

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim_tree.set("parameters/conditions/grounded", false)
		anim_tree.set("parameters/conditions/jumping", true)
	else:
		anim_tree.set("parameters/conditions/grounded", true)
		anim_tree.set("parameters/conditions/jumping", false)

	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var camera_rotation = spring_arm.global_transform.basis.get_euler().y
	var rotated_input_dir = Vector3(
		input_dir.x * cos(camera_rotation) + input_dir.y * sin(camera_rotation),
		0,
		-input_dir.x * sin(camera_rotation) + input_dir.y * cos(camera_rotation)
	).normalized()

	if Input.is_action_pressed("run"):
		current_speed = SPEED * RUN_MULTIPLIER
		walk_sound.pitch_scale = 1.1
		is_running = true
	else:
		current_speed = SPEED
		walk_sound.pitch_scale = 1.0
		is_running = false

	velocity.x = lerp(velocity.x, float(rotated_input_dir.x * current_speed), MOVEMENT_SMOOTHNESS)
	velocity.z = lerp(velocity.z, float(rotated_input_dir.z * current_speed), MOVEMENT_SMOOTHNESS)

	if rotated_input_dir.length() > 0:
		if not is_moving:
			is_moving = true
			if not is_in_air:
				fade_in_walk_sound()
		var target_rotation = Vector2(rotated_input_dir.z, rotated_input_dir.x).angle()
		model.rotation.y = lerp_angle(model.rotation.y, target_rotation, MOVEMENT_SMOOTHNESS)
	else:
		if is_moving:
			is_moving = false
			fade_out_walk_sound()

	var vl = velocity * model.transform.basis
	anim_tree.set("parameters/IWR/blend_position", Vector2(vl.x, -vl.z) / current_speed)
	move_and_slide()

	if light:
		light.rotation.y = model.rotation.y + PI

	handle_camera_tilt(delta)

func handle_camera_tilt(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not is_tilting:
			is_tilting = true
		
		tilt_angle -= float(mouse_motion.x) * TILT_SENSITIVITY * delta
		mouse_motion = Vector2.ZERO
	else:
		if is_tilting:
			is_tilting = false
		#tilt_angle = lerp(tilt_angle, 0.0, MOVEMENT_SMOOTHNESS)

	spring_arm.rotation.y = deg_to_rad(tilt_angle)

func fade_in_walk_sound():
	var duration = 0.1 if is_in_air else 0.5

	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(walk_sound, "volume_db", -20.0, duration)
	if not walk_sound.playing:
		walk_sound.play()

func fade_out_walk_sound():
	var duration = 0.3 if is_in_air else 0.6
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(walk_sound, "volume_db", -80.0, duration)
