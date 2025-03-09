extends Node


signal health_changed(val)
signal health_reached_zero

@export var max_health: int = 100
var cur_health: int
var cur_health_percent: float:
	get:
		return clamp(float(cur_health) / max_health, 0.0, 1.0)


func _ready() -> void:
	cur_health = max_health


func add(val):
	cur_health += val
	cur_health = min(cur_health, max_health)
	
	health_changed.emit(cur_health)


func damage(val):
	cur_health -= val
	cur_health = max(cur_health, 0)
	if cur_health <= 0:
		health_reached_zero.emit()
	
	health_changed.emit(cur_health)
