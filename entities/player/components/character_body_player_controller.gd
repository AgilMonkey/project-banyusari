extends Node


@export var max_speed := 15.0
@export var acceleration := 14.0
@export var stop_accel := 15.0
@export var jump_force := 15.0
@export var max_jump := 2
@export var dash_force := 40.0
@export var dash_time := 0.15

var phys_delta := 0.0
var input_dir := Vector3.ZERO
var jump_inp_just_pressed := false

var jump_count := 0
var is_dashing := false

@onready var c_body: CharacterBody3D = $".."
@onready var cur_camera: Camera3D = get_viewport().get_camera_3d()


func _input(event: InputEvent) -> void:
	# Controller
	var inp_flat = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	input_dir = Vector3(inp_flat.x, 0, -inp_flat.y)
	


func _physics_process(delta: float) -> void:
	phys_delta = delta
	
	if not is_dashing:
		gravity(delta)
		horizontal_movement(delta)
	
	landing()
	
	if Input.is_action_just_pressed("jump"):
		jump()
	
	if Input.is_action_just_pressed("dash") and not is_dashing:
		dash()
	
	c_body.move_and_slide()
	
	#var cur_vel = c_body.velocity
	#var hor_vel = Vector3(cur_vel.x, 0, cur_vel.z)
	#print("Hor: ", hor_vel, " ", hor_vel.length())


func horizontal_movement(delta):
	var cam_rotation_y = cur_camera.rotation.y
	var cam_direction = input_dir.rotated(Vector3.UP, cam_rotation_y)
	var target_vel = cam_direction * max_speed
	var next_vel = cam_direction * acceleration * delta
	
	c_body.velocity.x = target_vel.x
	c_body.velocity.z = target_vel.z
	
	#speed_limiter(delta)
	#turning(cam_direction, delta)
	#
	#if input_dir.length_squared() == 0:
		#hor_move_stop(delta)


## @deprecated
func speed_limiter(delta):
	var cur_vel = c_body.velocity
	var hor_vel = Vector3(cur_vel.x, 0, cur_vel.z)
	if hor_vel.length() > max_speed:
		var stopper_vel = -hor_vel.normalized() * acceleration * delta
		
		c_body.velocity.x += stopper_vel.x
		c_body.velocity.z += stopper_vel.z


## @deprecated
func turning(cam_direction, delta):
	var turn_accel = acceleration * 3.5
	var vel = c_body.velocity
	var vel_dir = vel.normalized()
	var vel_neg_dir = -vel_dir
	var vel_inp_dot = vel_dir.dot(cam_direction)
	var is_turning = vel_inp_dot < 0.92
	var turn_percent = clampf((-vel_inp_dot + 1) / 2, 0.0, 1.0)
	if is_turning and cam_direction.length() > 0.0:
		var neg_vel_force = vel_neg_dir * turn_percent * turn_accel
		var neg_velxz_force = Vector3(neg_vel_force.x, 0, neg_vel_force.z)
		add_force(neg_velxz_force)
		
		var turn_percent_reverse = clampf(1.0 - turn_percent, 0.0, 1.0)
		var counter_push_force = cam_direction * turn_percent_reverse * (acceleration / 1.5)
		add_force(counter_push_force)


## @deprecated
func hor_move_stop(delta):
	var cur_vel = c_body.velocity
	var hor_vel = Vector3(cur_vel.x, 0, cur_vel.z)
	var stop_vel = hor_vel.move_toward(Vector3.ZERO, stop_accel * delta)
	
	c_body.velocity.x = stop_vel.x
	c_body.velocity.z = stop_vel.z


func jump():
	var can_jump = c_body.is_on_floor() or jump_count < max_jump
	if can_jump:
		c_body.velocity.y = jump_force
		jump_count += 1
	
	if jump_inp_just_pressed:
		jump_inp_just_pressed = false


func dash():
	get_tree().create_timer(dash_time).timeout.connect(func (): is_dashing = false)
	is_dashing = true
	
	var cam_rotation_y = cur_camera.rotation.y
	var dash_direction := Vector3.ZERO
	if input_dir.length_squared() > 0.1:
		dash_direction = input_dir.rotated(Vector3.UP, cam_rotation_y)
	else:
		dash_direction = Vector3.FORWARD.rotated(Vector3.UP, cam_rotation_y)
	
	var dash_force = dash_direction * dash_force
	c_body.velocity.x = dash_force.x
	c_body.velocity.z = dash_force.z


func gravity(delta):
	var down_force = ProjectSettings.get_setting("physics/3d/default_gravity")
	c_body.velocity.y -= down_force * delta


func landing():
	if c_body.is_on_floor() and jump_count > 0:
		jump_count = 0


func add_force(force: Vector3):
	c_body.velocity += force * phys_delta
