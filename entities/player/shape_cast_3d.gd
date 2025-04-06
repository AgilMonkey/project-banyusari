extends ShapeCast3D


func get_nodes_from_shapecast() -> Array:
	force_shapecast_update()  # The magic sauce.

	var number_of_nodes = get_collision_count()  # Necessary to know how many times to iterate.
	var nodes_in_shapecast = []

	for i in range(number_of_nodes):
		var node = get_collider(i)  # Here you get one node at a time from the ShapeCast2D
		nodes_in_shapecast.append(node)          # and put them in a list.

	return nodes_in_shapecast
