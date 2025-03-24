extends Node


@export var max_speed := 15.0
@export var acceleration := 10.0
@export var stop_accel := 8.0
@export var jump_force := 15.0
@export var max_jump := 2

var input_dir := Vector3.ZERO
var jump_inp_just_pressed := false

var jump_count := 0

@onready var c_body: CharacterBody3D = $".."
@onready var cur_camera: Camera3D = get_viewport().get_camera_3d()


func _input(event: InputEvent) -> void:
	# Controller
	var inp_flat = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	input_dir = Vector3(inp_flat.x, 0, -inp_flat.y)
	
	if Input.is_action_just_pressed("jump"):
		jump_inp_just_pressed = true


func _physics_process(delta: float) -> void:
	gravity(delta)
	landing()
	horizontal_movement(delta)
	jumping()
	
	c_body.move_and_slide()
	print(c_body.velocity.length())


func horizontal_movement(delta):
	var cam_rotation_y = cur_camera.rotation.y
	var cam_direction = input_dir.rotated(Vector3.UP, cam_rotation_y)
	var target_vel = cam_direction * max_speed
	var next_vel = cam_direction * acceleration * delta
	
	c_body.velocity.x += next_vel.x
	c_body.velocity.z += next_vel.z
	
	speed_limiter(delta)
	
	if input_dir.length_squared() == 0:
		hor_move_stop(delta)


func speed_limiter(delta):
	var cur_vel = c_body.velocity
	var hor_vel = Vector3(cur_vel.x, 0, cur_vel.z)
	if hor_vel.length() > max_speed:
		var stopper_vel = -hor_vel.normalized() * acceleration * delta
		
		c_body.velocity.x += stopper_vel.x
		c_body.velocity.z += stopper_vel.z


func hor_move_stop(delta):
	var cur_vel = c_body.velocity
	var hor_vel = Vector3(cur_vel.x, 0, cur_vel.z)
	var stop_vel = hor_vel.move_toward(Vector3.ZERO, stop_accel * delta)
	
	c_body.velocity.x = stop_vel.x
	c_body.velocity.z = stop_vel.z


func jumping():
	var can_jump = c_body.is_on_floor() or jump_count < max_jump
	if jump_inp_just_pressed and can_jump:
		c_body.velocity.y = jump_force
		jump_count += 1
	
	if jump_inp_just_pressed:
		jump_inp_just_pressed = false


func gravity(delta):
	var down_force = ProjectSettings.get_setting("physics/3d/default_gravity")
	c_body.velocity.y -= down_force * delta


func landing():
	if c_body.is_on_floor() and jump_count > 0:
		jump_count = 0
