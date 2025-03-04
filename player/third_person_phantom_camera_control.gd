extends Node


@export var sensitivity = 60.0

var mouse_rel: Vector2


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_rel = event.relative


func _process(delta: float) -> void:
	print(mouse_rel)
