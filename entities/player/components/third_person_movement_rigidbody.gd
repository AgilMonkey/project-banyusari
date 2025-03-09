extends Node


@export var acceleration := 45.0
#@export var turn_acceleration := 40.0

@export var jump_force := 14.0

var input_dir: Vector3
var jumped := false

@onready var rb: RigidBody3D = get_parent()
@onready var cur_camera: Camera3D = get_viewport().get_camera_3d()


func _input(event: InputEvent) -> void:
	# Controller
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.z = Input.get_axis("move_forward", "move_backward")
	input_dir = input_dir.normalized()
	
	if Input.is_action_just_pressed("jump") and rb.on_floor:
		if not jumped: jump()


func _physics_process(delta: float) -> void:
	if input_dir.length() < 0.1:
		stop_force(delta)
	
	var cam_rotation_y = cur_camera.rotation.y
	var cam_direction = input_dir.rotated(Vector3.UP, cam_rotation_y)
	rb.apply_force(cam_direction * acceleration * 1.0)
	
	var max_speed_gain = 15.0
	var vel_horizontal = Vector3(rb.linear_velocity.x, 0, rb.linear_velocity.z)
	if vel_horizontal.length() > max_speed_gain:
		rb.apply_force(-vel_horizontal.normalized() * max_speed_gain)
		if cam_direction.length() > 0.0:
			rb.apply_force(-cam_direction * acceleration)
	
	var turn_accel = acceleration * 4.0
	var rb_vel = rb.linear_velocity
	var rb_vel_dir = rb_vel.normalized()
	var rb_vel_neg_dir = -rb_vel_dir
	var vel_inp_dot = rb_vel_dir.dot(cam_direction)
	var is_turning = vel_inp_dot < 0.92
	var turn_percent = clampf((-vel_inp_dot + 1) / 2, 0.0, 1.0)
	if is_turning and cam_direction.length() > 0.0:
		var neg_vel_force = rb_vel_neg_dir * turn_percent * turn_accel
		var neg_velxz_force = Vector3(neg_vel_force.x, 0, neg_vel_force.z)
		rb.apply_force(neg_velxz_force)
		
		var turn_percent_reverse = clampf(1.0 - turn_percent, 0.0, 1.0)
		var counter_push_force = cam_direction * turn_percent_reverse * (acceleration / 1.5)
		rb.apply_force(counter_push_force)
	
	#print(Vector3(rb.linear_velocity.x, 0, rb.linear_velocity.z).length())


func jump():
	jumped = true
	rb.apply_impulse(Vector3.UP * jump_force)
	await get_tree().physics_frame
	jumped = false


func stop_force(delta):
	var velocityxz = Vector3(rb.linear_velocity.x, 0, rb.linear_velocity.z)
	var vel_mag = velocityxz.length()
	var vel_to_zero = -velocityxz 
	var vel_to_zero_horizontal = Vector3(vel_to_zero.x, 0, vel_to_zero.z).normalized()
	var force = vel_to_zero_horizontal * clampf(vel_mag/5.0, 0, 1) * 15.0 * 3.0
	rb.apply_force(force)
