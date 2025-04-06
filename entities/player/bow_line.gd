extends MeshInstance3D


func _process(delta: float) -> void:
	var new_immediate_mesh: ImmediateMesh = ImmediateMesh.new()
	
	new_immediate_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	new_immediate_mesh.surface_set_color(Color.WHITE)
	
	var thickness = 50.0
	
	var point_a := position
	var point_b := position + -basis.z * 5.0
	
	var scale_factor := 100.0
	
	var dir:= point_a.direction_to(point_b)
	var EPISILON = 0.00001
	
	# Draw cube line
	var normal := Vector3(-dir.y, dir.x, 0).normalized() \
		if (abs(dir.x) + abs(dir.y) > EPISILON) \
		else Vector3(0, -dir.z, dir.y).normalized()
	normal *= thickness / scale_factor
	
	var vertices_strip_order = [4, 5, 0, 1, 2, 5, 6, 4, 7, 0, 3, 2, 7, 6]
	var local_b = (point_b - point_a)
	
	for v in range(14):
		var vertex = normal \
			if vertices_strip_order[v] < 4 \
			else normal + local_b
		var final_vert = vertex.rotated(
			dir,
			PI * (0.5 * (vertices_strip_order[v] % 4) + 0.25)
		)
		
		final_vert += point_a
		new_immediate_mesh.surface_add_vertex(final_vert)
	new_immediate_mesh.surface_end()
	
	mesh = new_immediate_mesh
