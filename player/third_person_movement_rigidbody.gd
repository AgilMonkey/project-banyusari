extends Node


@export var speed := 20
var input_dir: Vector3

var rb: RigidBody3D


func _ready() -> void:
	rb = get_parent()


func _input(event: InputEvent) -> void:
	input_dir.z = Input.get_axis("move_forward", "move_backward")
	input_dir.x = Input.get_axis("move_left", "move_right")


func _process(delta: float) -> void:
	rb.apply_force(input_dir * speed)
