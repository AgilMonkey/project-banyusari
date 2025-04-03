extends Node3D


@export var min_bow_hold_t = 0.5
@export var perfect_bow_hold_t = 1.0
@export var charged_bow_hold_t = 2.0
@export var charged_shot_cooldown_t = 10.0

@export var dmg_normal_shot = 25
@export var dmg_perfect_shot = 50
@export var dmg_charged_shot = 100

var inp_hold_bow := false
var bow_hold_t := 0.0
var can_do_charged_shot := true

@onready var camera = get_viewport().get_camera_3d()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		inp_hold_bow = true
	elif Input.is_action_just_released("shoot"):
		if bow_hold_t >= charged_bow_hold_t and can_do_charged_shot:
			charged_shoot()
		elif bow_hold_t > min_bow_hold_t:
			shoot()
		
		bow_hold_t = 0.0
		inp_hold_bow = false


func _process(delta: float) -> void:
	if inp_hold_bow:
		bow_hold_t += delta
	
	
	Global.player_bow_hold_percent_changed.emit(bow_hold_t)


func shoot():
	var cam_ray_hit_pos = cast_ray_center_screen()
	
	$RayCast3D.look_at(cam_ray_hit_pos)
	
	$RayCast3D.force_raycast_update()
	var ray_hit = $RayCast3D.get_collider()
	if ray_hit is HitboxComponent:
		var damage: float
		if bow_hold_t >= perfect_bow_hold_t - 0.25 and bow_hold_t <= perfect_bow_hold_t + 0.25:
			damage = dmg_perfect_shot
		else:
			damage = dmg_normal_shot
		ray_hit.on_hit.emit(damage)


func charged_shoot():
	var cam_ray_hit_pos = cast_ray_center_screen()
	
	$RayCast3DWall.look_at(cam_ray_hit_pos)
	
	var space_state := get_world_3d().direct_space_state
	$RayCast3DWall.force_raycast_update()
	if $RayCast3DWall.is_colliding():
		var dist_to_hit = global_position.distance_to($RayCast3DWall.get_collision_point())
		$RayCast3DWall/ShapeCast3D.shape.height = dist_to_hit
		$RayCast3DWall/ShapeCast3D.position.z = -dist_to_hit / 2.0
	else:
		var dist_to_hit = 1000.0
		$RayCast3DWall/ShapeCast3D.shape.height = dist_to_hit
		$RayCast3DWall/ShapeCast3D.position.z = -dist_to_hit / 2.0
	
	var nodes = $RayCast3DWall/ShapeCast3D.get_nodes_from_shapecast()
	for node in nodes:
		if node is HitboxComponent:
			node.on_hit.emit(dmg_charged_shot)
	
	charge_shot_cooldown()


func charge_shot_cooldown():
	can_do_charged_shot = false
	await get_tree().create_timer(charged_shot_cooldown_t).timeout
	can_do_charged_shot = true


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
