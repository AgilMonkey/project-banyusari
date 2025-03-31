extends Node3D

# TODO
# - Value for how long input is pressed
# - Min power and max power
# - Get the forward point
# - Add line

@export var max_bow_t := 3.0
@export var min_bow_power := 10.0
@export var max_bow_power := 40.0
@export var bow_forward_range := 100.0

var inp_hold_bow := false
var bow_hold_t := 0.0
var bow_hold_percent := 0.0:
	get:
		return clampf(bow_hold_t / max_bow_t, 0.0, 1.0)
var arrow_power := 0.0:
	get:
		var selisih_bow_power_max_min := max_bow_power - min_bow_power
		return min_bow_power + (selisih_bow_power_max_min * bow_hold_percent)

@onready var cur_cam: Camera3D = get_viewport().get_camera_3d()
@onready var bow_line: MeshInstance3D = $BowLine


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		inp_hold_bow = true
	elif Input.is_action_just_released("shoot"):
		bow_hold_t = 0.0
		inp_hold_bow = false


func _process(delta: float) -> void:
	if inp_hold_bow:
		bow_hold_t += delta
	
	#bow_line.verts = PackedVector3Array([global_position, get_bow_direction()])


func get_bow_direction() -> Vector3:
	var camera_forward_range := cur_cam.global_position + (-cur_cam.transform.basis.z * bow_forward_range) 
	return camera_forward_range - global_position
