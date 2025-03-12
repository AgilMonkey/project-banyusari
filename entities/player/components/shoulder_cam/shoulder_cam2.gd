@tool
extends SpringArm3D


## IDK A FUCKING STUPID TOOL FOR AUTOMATING THE SPRING LENGTH SHIT IDFK


@export var cam_length := 8.0
@export var cam_pivot := Vector2.ZERO

@onready var z_spring_arm: SpringArm3D = get_child(0)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		var offset_z = find_z_from_x_y(cam_pivot.x, cam_pivot.y, cam_length)
		var offset = Vector3(cam_pivot.x, cam_pivot.y, offset_z)
		
		change_spring_arm_length(offset)
		offset_child(offset)


func change_spring_arm_length(offset):
	position.y = cam_pivot.y
	spring_length = offset.x
	z_spring_arm.spring_length = offset.z
	
	rotation.y = deg_to_rad(90)
	z_spring_arm.rotation.y = deg_to_rad(-90)
	
	z_spring_arm.margin = margin
	z_spring_arm.collision_mask = collision_mask


func offset_child(offset):
	for child in z_spring_arm.get_children():
		child.position.x = offset.x
		child.position.z = offset.z


func find_z_from_x_y(x, y, l):
	var x_pow_2 = pow(x, 2)
	var y_pow_2 = pow(y, 2)
	var l_pow_2 = pow(l, 2)
	
	var z = sqrt(l_pow_2 - x_pow_2 - y_pow_2)
	return z
