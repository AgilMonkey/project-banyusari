@tool
extends Node3D


## IDK A FUCKING STUPID TOOL FOR AUTOMATING THE SPRING LENGTH SHIT IDFK


@export var cam_length := 8.0
@export var cam_pivot := Vector2(1.2, 0.6)

var spring_arm_x: SpringArm3D
var spring_arm_z: SpringArm3D


func _ready() -> void:
	spring_arm_x = Utility.find_type(self, SpringArm3D)
	spring_arm_z = spring_arm_x.get_child(0)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		var offset_z = find_z_from_x_y(cam_pivot.x, cam_pivot.y, cam_length)
		var offset = Vector3(cam_pivot.x, cam_pivot.y, offset_z)
		
		change_spring_arm_length(offset)
		offset_child(offset)


func change_spring_arm_length(offset):
	spring_arm_x.position.y = cam_pivot.y
	spring_arm_x.spring_length = offset.x
	spring_arm_z.spring_length = offset.z
	
	spring_arm_x.rotation.y = deg_to_rad(90)
	spring_arm_z.rotation.y = deg_to_rad(-90)
	
	spring_arm_z.margin = spring_arm_x.margin
	spring_arm_z.collision_mask = spring_arm_x.collision_mask


func offset_child(offset):
	spring_arm_z.position.x = 0
	spring_arm_z.position.y = 0
	spring_arm_z.position.z = cam_pivot.x
	
	for child in spring_arm_z.get_children():
		child.position.x = 0
		child.position.y = 0
		child.position.z = cam_length


func find_z_from_x_y(x, y, l):
	var x_pow_2 = pow(x, 2)
	var y_pow_2 = pow(y, 2)
	var l_pow_2 = pow(l, 2)
	
	var z = sqrt(l_pow_2 - x_pow_2 - y_pow_2)
	return z
