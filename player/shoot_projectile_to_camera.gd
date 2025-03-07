extends Node

@export var ball: Node3D

@onready var projectile = load("res://arrow/arrow.tscn")
@onready var camera = get_viewport().get_camera_3d()
@onready var bow = get_parent()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		var new_projectile: RigidBody3D = projectile.instantiate()
		get_tree().get_root().get_node("Main").add_child(new_projectile)
		new_projectile.global_position = bow.global_position
		
		var cam_forward = camera.basis.z * 20
		var cam_target = camera.position - cam_forward
		var bow_to_cam_target = cam_target - bow.global_position
		var vel = bow_to_cam_target.normalized() * 60
		new_projectile.look_at(cam_target)
		new_projectile.linear_velocity = vel


func _process(delta: float) -> void:
	var cam_forward = camera.basis.z * 15.0
	var cam_target = camera.position - cam_forward
	var bow_to_cam_target = cam_target - bow.global_position
	#print(bow_to_cam_target)
	var vel = bow_to_cam_target.normalized() * 10
	ball.global_position = bow.global_position + bow_to_cam_target
