extends Node3D

# TODO
# 1. Value for how long input is pressed

@export var max_bow_t := 3.0

var inp_hold_bow := false
var bow_hold_t := 0.0
var bow_hold_p := 0.0:
	get:
		return clampf(bow_hold_t / max_bow_t, 0.0, 1.0)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		inp_hold_bow = true
	elif Input.is_action_just_released("shoot"):
		var bow_hold_percent = clampf(bow_hold_t / 1.0, 0.0, 1.0)
		
		bow_hold_t = 0.0
		inp_hold_bow = false


func _process(delta: float) -> void:
	if inp_hold_bow:
		bow_hold_t += delta
	
	print(bow_hold_p)
