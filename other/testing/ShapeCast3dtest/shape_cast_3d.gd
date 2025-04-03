extends ShapeCast3D


func _ready() -> void:
	await get_tree().process_frame
	print(collision_result.size())
	#for i in get_collision_count():
		#print(get_collider(i))
