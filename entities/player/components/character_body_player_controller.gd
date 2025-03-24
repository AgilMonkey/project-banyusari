extends Node


@export var speed := 10

var input_dir := Vector2.ZERO

@onready var player: CharacterBody3D = $".."


func _input(event: InputEvent) -> void:
	# Controller
	input_dir = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	
	if Input.is_action_just_pressed("jump"):
		print("jump")


func _physics_process(delta: float) -> void:
	print(input_dir)
