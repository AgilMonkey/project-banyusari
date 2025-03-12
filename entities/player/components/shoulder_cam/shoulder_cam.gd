@tool
extends SpringArm3D


@export var cam_length := 8.0
@export var cam_pivot := Vector2.ZERO


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		var offset_z = find_z_from_x_y(cam_pivot.x, cam_pivot.y, cam_length)
		var offset = Vector3(cam_pivot.x, cam_pivot.y, offset_z)
		var to_offset = offset - position
		
		offset_spring_arm(to_offset)
		offset_child()


func offset_spring_arm(to_offset):
	if cam_length == 0:
		transform = Transform3D.IDENTITY
		return
	
	spring_length = cam_length
	transform = transform.looking_at(-to_offset)


func offset_child():
	for child in get_children():
		child.position.z = cam_length
		child.rotation.x = -rotation.x
		child.rotation.y = -rotation.y
		child.global_rotation.z = 0.0


func find_z_from_x_y(x, y, l):
	var x_pow_2 = pow(x, 2)
	var y_pow_2 = pow(y, 2)
	var l_pow_2 = pow(l, 2)
	
	var z = sqrt(l_pow_2 - x_pow_2 - y_pow_2)
	return z
