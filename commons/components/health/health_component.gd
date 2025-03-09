extends Node


signal health_reached_zero

@export var max_health: int = 100
var cur_health: int


func _ready() -> void:
	cur_health = max_health


func add(val):
	cur_health += val
	cur_health = min(cur_health, max_health)


func damage(val):
	cur_health -= val
	cur_health = max(cur_health, 0)
	if cur_health <= 0:
		health_reached_zero.emit()
