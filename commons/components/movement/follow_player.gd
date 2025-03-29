class_name FollowPlayer
extends Node

@export var speed := 15.0
@export var follow: Node3D

@onready var character: CharacterBody3D = get_parent()
@onready var navigation: NavigationAgent3D =  character.find_child("NavigationAgent3D")


func _ready() -> void:
	follow = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if follow:
		navigation.target_position = follow.position
	
	var destination = navigation.get_next_path_position()
	var local_destination = destination - character.global_position
	var direction = local_destination.normalized()
	
	#DebugDraw3D.draw_arrow(character.position, character.position + direction * 2.0, Color.GREEN, 0.2)
	
	character.velocity = direction * speed
	character.move_and_slide()
