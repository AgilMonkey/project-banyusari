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
@export var dash_energy_gen := 1.0
@export var dash_energy_gen_in_air := 0.7
@export var dash_energy_req := 1.0
@export var slide_max_speed := 18.0

var phys_delta := 0.0
var input_dir := Vector3.ZERO
var cam_inp_dir := Vector3.ZERO:
	get:
		var cam_rotation_y = cur_camera.rotation.y
		var cam_direction = input_dir.rotated(Vector3.UP, cam_rotation_y)
		return cam_direction

@onready var down_gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var jump_count := 0

var is_in_air := false

var is_dashing := false
var cur_dash_energy := 0.0

var is_sliding := false
var slide_dir := Vector3.ZERO

var is_wall_running := false

# INPUTS
var jump_inp_just_pressed := false
var dash_inp_just_pressed := false
var slide_inp_pressed := false


@onready var c_body: CharacterBody3D = $".."
@onready var cur_camera: Camera3D = get_viewport().get_camera_3d()
@onready var collision_shape: CollisionShape3D = $"../CollisionShape3D"
@onready var gfx: MeshInstance3D = %"Gfx"
@onready var crouch_ray_cast: RayCast3D = $"../CrouchRayCast"
@onready var gfx_pivot: Node3D = $"../GfxPivot"


func _ready() -> void:
	cur_dash_energy = max_dash_energy


func _input(event: InputEvent) -> void:
	# Controller
	var inp_flat = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	input_dir = Vector3(inp_flat.x, 0, -inp_flat.y)
	
	if Input.is_action_just_pressed("jump"):
		jump_inp_just_pressed = true
	
	if Input.is_action_just_pressed("dash"):
		dash_inp_just_pressed = true
	
	slide_inp_pressed = Input.is_action_pressed("slide")


func _process(delta: float) -> void:
	if not is_dashing:
		gen_dash_energy(delta)
	
	# UI STUFF
	on_dash_val_changed.emit(cur_dash_energy, max_dash_energy, dash_energy_req)


func _physics_process(delta: float) -> void:
	is_in_air = not c_body.is_on_floor()
	
	if not is_dashing:
		gravity(delta)
	
	if not is_dashing and not is_sliding and not is_wall_running:
		horizontal_movement(delta)
	
	landing()
	
	wall_run()
	
	if jump_inp_just_pressed and not is_wall_running:
		jump()
	
	if dash_inp_just_pressed and not is_dashing and not is_sliding:
		dash()
	
	if slide_inp_pressed and not is_in_air:
		slide()
	else:
		is_sliding = false
		slide_dir = Vector3.ZERO
	slide_change_p_size()
	
	c_body.move_and_slide()
	
	# INPUT STUFF
	jump_inp_just_pressed = false
	dash_inp_just_pressed = false


func horizontal_movement(delta):
	var cam_direction = cam_inp_dir
	var target_vel = cam_direction * max_speed
	var next_vel = cam_direction * acceleration * delta
	
	c_body.velocity.x = target_vel.x
	c_body.velocity.z = target_vel.z


func jump():
	var can_jump = c_body.is_on_floor() or jump_count < max_jump
	if can_jump:
		c_body.velocity.y = jump_force
		jump_count += 1

func force_jump():
	c_body.velocity.y = jump_force
	jump_count += 1


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
	if not is_in_air and not is_sliding:
		cur_dash_energy += delta * dash_energy_gen
	else:
		cur_dash_energy += delta * dash_energy_gen_in_air
	cur_dash_energy = clamp(cur_dash_energy, 0.0, max_dash_energy)


func slide():
	is_sliding = true
	
	slide_dir = get_slide_dir()
	var target_vel = slide_dir * slide_max_speed
	
	c_body.velocity.x = target_vel.x
	c_body.velocity.z = target_vel.z


func get_slide_dir():
	if slide_dir.length_squared() > 0:
		return slide_dir
	
	if cam_inp_dir.length_squared() == 0:
		var cam_rotation_y = cur_camera.rotation.y
		return Vector3.FORWARD.rotated(Vector3.UP, cam_rotation_y)
	
	return c_body.velocity.normalized()


func slide_change_p_size():
	if is_sliding:
		gfx.position.y = -0.5
		gfx.scale.y = 0.5
		
		var col_shape: CapsuleShape3D = collision_shape.shape
		collision_shape.position.y = -0.5
		col_shape.height = 1.0
	elif not crouch_ray_cast.is_colliding():
		gfx.position.y = 0.0
		gfx.scale.y = 1.0
		
		var col_shape: CapsuleShape3D = collision_shape.shape
		collision_shape.position.y = 0.0
		col_shape.height = 2.0


func gravity(delta):
	c_body.velocity.y -= down_gravity * delta


func landing():
	if c_body.is_on_floor() and jump_count > 0:
		jump_count = 0


func wall_run():
	if is_wall_running and jump_inp_just_pressed:
		force_jump()
		reset_jump_count()
		is_wall_running = false
		return
	
	var on_wall_not_floor = c_body.is_on_wall() and not c_body.is_on_floor()
	var inp_jump_is_just_pressed = Input.is_action_just_pressed("jump")
	if inp_jump_is_just_pressed and on_wall_not_floor and not is_wall_running:
		is_wall_running = true
		down_gravity = 5.0
		c_body.velocity.y = 0.0
	elif not c_body.is_on_wall() or c_body.is_on_floor():
		is_wall_running = false
		down_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	
	if is_wall_running:
		hor_wall_run_move()
	
	wall_run_visual()


func hor_wall_run_move():
	var cam_direction = cam_inp_dir
	var target_vel = cam_direction * max_speed
	var vel_xz = Vector3(c_body.velocity.x, 0, c_body.velocity.z)
	
	var wall_normal = c_body.get_wall_normal()
	var wall_normal_xz = Vector3(wall_normal.x, 0, wall_normal.z)
	var wall_cross = wall_normal_xz.cross(Vector3.UP)
	var forward_or_backward_wall = -1 if sign(wall_cross.dot(vel_xz)) < 0 else 1
	
	var wall_run_dir = (wall_cross * forward_or_backward_wall).normalized()
	#var arrow_pos = c_body.position + wall_run_dir * 2.0
	#DebugDraw3D.draw_arrow(c_body.position, arrow_pos, Color.GREEN, 0.2)
	
	var reverse_wall_vel = -wall_normal_xz.normalized() * 1.0
	var wall_run_vel = wall_run_dir * (max_speed + 5.0) + reverse_wall_vel
	c_body.velocity.x = wall_run_vel.x
	c_body.velocity.z = wall_run_vel.z


# This thing is gonna bite me in the ass later
# Maybe next time make them more modular?
func wall_run_visual():
	if is_wall_running:
		var vel_xz = Vector3(c_body.velocity.x, 0, c_body.velocity.z)
		var wall_normal = c_body.get_wall_normal()
		var wall_normal_xz = Vector3(wall_normal.x, 0, wall_normal.z)
		var wall_forward = wall_normal_xz.cross(Vector3.UP)
		var forward_or_backward_wall = -1 if sign(wall_forward.dot(vel_xz)) < 0 else 1
		
		var hor_rot = atan2(wall_forward.x, wall_forward.z) - PI
		gfx_pivot.rotation.y = hor_rot
		
		var cross = wall_normal.cross(wall_forward)
		var is_left_right = absf(cross.y)
		gfx_pivot.rotation.z = deg_to_rad(15 * is_left_right)
		return
	
	gfx_pivot.rotation.y = 0
	gfx_pivot.rotation.z = 0


func reset_jump_count():
	jump_count = 0


func add_force(force: Vector3):
	c_body.velocity += force * phys_delta
