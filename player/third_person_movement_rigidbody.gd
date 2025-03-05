extends Node


@export var acceleration := 45.0
#@export var turn_acceleration := 40.0

@export var jump_force := 12.0

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
	rb.apply_force(cam_direction * acceleration)
	
	var vel_horizontal = Vector3(rb.linear_velocity.x, 0, rb.linear_velocity.z)
	if vel_horizontal.length() > 15.0:
		rb.apply_force(-vel_horizontal.normalized() * acceleration)
	
	#rb.rotate


func jump():
	jumped = true
	rb.apply_impulse(Vector3.UP * jump_force)
	await get_tree().physics_frame
	jumped = false


func stop_force(delta):
	var velocity = rb.linear_velocity
	var vel_to_zero = Vector3.ZERO - velocity 
	var vel_to_zero_horizontal = Vector3(vel_to_zero.x, 0, vel_to_zero.z)
	var force = vel_to_zero_horizontal * 15.0
	rb.apply_force(force)
