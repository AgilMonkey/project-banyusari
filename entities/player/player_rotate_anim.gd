extends Node


@export var rot_speed: float = 15.0

@export var character: CharacterBody3D
@export var controller: Node

var last_movement: Vector3

@onready var gfx_pivot: Node3D = $".."


func _process(delta: float) -> void:
	var cam_inp_dir: Vector3 = controller.cam_inp_dir
	var is_wall_running = controller.is_wall_running
	
	if is_wall_running:
		return
	
	if cam_inp_dir.length_squared() > 0:
		last_movement = cam_inp_dir
	elif controller.is_sliding:
		last_movement = character.velocity
	var target_angle = Vector3.FORWARD.signed_angle_to(last_movement, Vector3.UP)
	gfx_pivot.rotation.y = lerp_angle(gfx_pivot.rotation.y, target_angle, delta * rot_speed)
