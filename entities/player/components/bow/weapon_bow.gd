extends Node3D


var inp_hold_bow := false
var bow_hold_t := 0.0

@onready var camera = get_viewport().get_camera_3d()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		inp_hold_bow = true
	elif Input.is_action_just_released("shoot"):
		shoot()
		
		bow_hold_t = 0.0
		inp_hold_bow = false


func _process(delta: float) -> void:
	if inp_hold_bow:
		bow_hold_t += delta


func shoot():
	var cam_ray_hit_pos = cast_ray_center_screen()
	
	$RayCast3D.look_at(cam_ray_hit_pos)
	var ray_hit = $RayCast3D.collide_with_areas
	if ray_hit:
		print("A")
	
	if $RayCast3D.is_colliding():
		print("B")


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
