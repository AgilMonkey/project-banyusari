extends Node


signal on_dash_val_changed(cur_energy, max_dash, dash_req)

@export var max_speed := 15.0
@export var acceleration := 14.0
@export var stop_accel := 15.0
@export var jump_force := 15.0
@export var max_jump := 2
@export var dash_force := 40.0
@export var dash_time := 0.15
@export var max_dash_energy := 3.0
@export var dash_energy_gen := 1.5
@export var dash_energy_req := 1.0

var phys_delta := 0.0
var input_dir := Vector3.ZERO
var jump_inp_just_pressed := false

var jump_count := 0
var is_dashing := false
var cur_dash_energy := 0.0

@onready var c_body: CharacterBody3D = $".."
@onready var cur_camera: Camera3D = get_viewport().get_camera_3d()


func _ready() -> void:
	cur_dash_energy = max_dash_energy


func _input(event: InputEvent) -> void:
	# Controller
	var inp_flat = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	input_dir = Vector3(inp_flat.x, 0, -inp_flat.y)
	


func _process(delta: float) -> void:
	if not is_dashing:
		gen_dash_energy(delta)
	
	# UI STUFF
	on_dash_val_changed.emit(cur_dash_energy, max_dash_energy, dash_energy_req)


func _physics_process(delta: float) -> void:
	
	if not is_dashing:
		gravity(delta)
		horizontal_movement(delta)
	
	landing()
	
	if Input.is_action_just_pressed("jump"):
		jump()
	
	if Input.is_action_just_pressed("dash") and not is_dashing:
		dash()
	
	c_body.move_and_slide()


func horizontal_movement(delta):
	var cam_rotation_y = cur_camera.rotation.y
	var cam_direction = input_dir.rotated(Vector3.UP, cam_rotation_y)
	var target_vel = cam_direction * max_speed
	var next_vel = cam_direction * acceleration * delta
	
	c_body.velocity.x = target_vel.x
	c_body.velocity.z = target_vel.z


func jump():
	var can_jump = c_body.is_on_floor() or jump_count < max_jump
	if can_jump:
		c_body.velocity.y = jump_force
		jump_count += 1
	
	if jump_inp_just_pressed:
		jump_inp_just_pressed = false


func dash():
	if cur_dash_energy < dash_energy_req:
		return
	cur_dash_energy -= dash_energy_req
	
	get_tree().create_timer(dash_time).timeout.connect(func (): is_dashing = false)
	is_dashing = true
	
	var cam_rotation_y = cur_camera.rotation.y
	var dash_direction := Vector3.ZERO
	if input_dir.length_squared() > 0.1:
		dash_direction = input_dir.rotated(Vector3.UP, cam_rotation_y)
	else:
		dash_direction = Vector3.FORWARD.rotated(Vector3.UP, cam_rotation_y)
	
	var dash_force = dash_direction * dash_force
	c_body.velocity = dash_force


func gen_dash_energy(delta):
	cur_dash_energy += delta * dash_energy_gen
	cur_dash_energy = clamp(cur_dash_energy, 0.0, max_dash_energy)


func gravity(delta):
	var down_force = ProjectSettings.get_setting("physics/3d/default_gravity")
	c_body.velocity.y -= down_force * delta


func landing():
	if c_body.is_on_floor() and jump_count > 0:
		jump_count = 0


func add_force(force: Vector3):
	c_body.velocity += force * phys_delta
