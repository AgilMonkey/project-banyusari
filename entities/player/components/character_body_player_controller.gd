extends Node


@export var speed := 14.0
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
	horizontal_movement()
	jumping()
	
	c_body.move_and_slide()


func horizontal_movement():
	var cam_rotation_y = cur_camera.rotation.y
	var cam_direction = input_dir.rotated(Vector3.UP, cam_rotation_y)
	var from_cam_vel = cam_direction * speed
	
	c_body.velocity.x = from_cam_vel.x
	c_body.velocity.z = from_cam_vel.z


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
