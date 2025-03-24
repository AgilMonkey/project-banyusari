extends Node


@export var speed := 10

var input_dir := Vector3.ZERO

@onready var c_body: CharacterBody3D = $".."
@onready var cur_camera: Camera3D = get_viewport().get_camera_3d()


func _input(event: InputEvent) -> void:
	# Controller
	var inp_flat = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	input_dir = Vector3(inp_flat.x, 0, -inp_flat.y)
	
	if Input.is_action_just_pressed("jump"):
		print("jump")


func _physics_process(delta: float) -> void:
	var cam_rotation_y = cur_camera.rotation.y
	var cam_direction = input_dir.rotated(Vector3.UP, cam_rotation_y)
	c_body.velocity = cam_direction * speed
	c_body.move_and_slide()
