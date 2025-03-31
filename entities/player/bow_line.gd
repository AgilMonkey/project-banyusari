extends MeshInstance3D


func _ready():
	var new_immediate_mesh: ImmediateMesh = ImmediateMesh.new()
	
	new_immediate_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES, material_override)
	new_immediate_mesh.surface_add_vertex(position)
	new_immediate_mesh.surface_add_vertex(-basis.z * 100)
	new_immediate_mesh.surface_end()
	
	mesh = new_immediate_mesh
