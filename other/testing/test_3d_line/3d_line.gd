@tool
extends Node3D

@export var thickness: float = 1.0
@export var verts: PackedVector3Array


func _process(_delta):
	pass
	if len(verts) > 1:
		# Let's try drawing line
		for vert_i in verts.size():
			var next_verts_i = vert_i + 1
			if next_verts_i > verts.size():
				break
			
			var point_a = verts[vert_i]
			var point_b = verts[vert_i]

# TODO Make the draw from point a to b shit fukc i don't know I want to fucking die
func draw_cylinder_from_point(p_a: Vector3, p_b: Vector3, _thickness):
	var new_cylinder_mesh: CylinderMesh = CylinderMesh.new()
	new_cylinder_mesh.top_radius = _thickness
	new_cylinder_mesh.bottom_radius = _thickness
	
	# Set up the mesh instance first
	var new_mesh_instance: MeshInstance3D = MeshInstance3D.new()
	
	var pa_to_pb = p_b - p_a
