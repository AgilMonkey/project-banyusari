@tool
class_name KeepRotation
extends Node


@export var rot := Vector3.ZERO


func _process(delta: float) -> void:
	get_parent().rotation = rot
