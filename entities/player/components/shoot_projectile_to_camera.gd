extends Node3D


@export var ball: Node3D

var inp_hold_bow := false
var bow_hold_t := 0.0

@onready var projectile = preload("uid://duemupw1p28ta")
@onready var camera = get_viewport().get_camera_3d()
@onready var main_scene = Utility.find_type(get_tree().get_root(), Node3D)


func _ready() -> void:
	ball.call_deferred("reparent", main_scene)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		inp_hold_bow = true
	elif Input.is_action_just_released("shoot"):
		var bow_hold_percent = clampf(bow_hold_t / 1.0, 0.0, 1.0)
		if bow_hold_percent > 0.60 and bow_hold_percent < 0.80:
			shoot_arrow(100)
		elif bow_hold_t >= 0.85:
			shoot_arrow(50)
		elif bow_hold_percent > 0.5:
			shoot_arrow(25)
		
		bow_hold_t = 0.0
		inp_hold_bow = false


func _process(delta: float) -> void:
	if inp_hold_bow:
		bow_hold_t += delta
	
	# UI STUFF
	var bow_hold_percent = clampf(bow_hold_t / 1.0, 0.0, 1.0)
	Global.player_bow_hold_percent_changed.emit(bow_hold_percent)


func shoot_arrow(dmg):
	var new_arrow: RigidBody3D = add_arrow_to_scene()
	new_arrow.damage = dmg
	var cam_target = cast_ray_center_screen()
	var bow_to_cam_target = cam_target - global_position
	var vel_speed = 30.0 * clamp(bow_hold_t / 1.0, 0.0, 1.0) 
	var vel = bow_to_cam_target.normalized() * vel_speed
	new_arrow.look_at(cam_target)
	new_arrow.apply_impulse(vel)


func add_arrow_to_scene():
	var arrow: RigidBody3D = projectile.instantiate()
	main_scene.add_child(arrow)
	arrow.global_position = global_position
	return arrow


func cast_ray_center_screen():
	var space_state = get_world_3d().direct_space_state

	var screen_real_size = get_viewport().get_visible_rect().size
	var center_screen = screen_real_size / 2
	var origin = camera.project_ray_origin(center_screen)
	var end = origin + camera.project_ray_normal(center_screen) * 100.0
	var query = PhysicsRayQueryParameters3D.create(origin, end)

	var result = space_state.intersect_ray(query)
	
	if result:
		return result["position"]
	return end
