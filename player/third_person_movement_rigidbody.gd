extends Node


@export var speed := 10

@export var jump_force := 10

var input_dir: Vector3

@onready var rb: RigidBody3D = get_parent()
@onready var cur_camera: Camera3D = get_viewport().get_camera_3d()


func _input(event: InputEvent) -> void:
	input_dir.z = Input.get_axis("move_forward", "move_backward")
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir = input_dir.normalized()
	
	if Input.is_action_just_pressed("jump") and rb.on_floor:
		rb.apply_impulse(Vector3.UP * jump_force)


func _process(delta: float) -> void:
	var cam_rotation_y = cur_camera.rotation.y
	var cam_direction = input_dir.rotated(Vector3.UP, cam_rotation_y)
	rb.apply_force(cam_direction * speed)
