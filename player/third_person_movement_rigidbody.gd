extends Node


@export var speed := 10
var input_dir: Vector3

var rb: RigidBody3D


func _ready() -> void:
	rb = get_parent()


func _input(event: InputEvent) -> void:
	input_dir.z = Input.get_axis("move_forward", "move_backward")
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir = input_dir.normalized()


func _process(delta: float) -> void:
	rb.linear_damp = 0.0
	if input_dir.length_squared() == 0:
		rb.linear_damp = 10.0
	
	if rb.linear_velocity.length() > 20.0:
		rb.linear_damp = 10.0

	rb.apply_force(input_dir * speed)
