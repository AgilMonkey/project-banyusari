extends Node3D


@export var default_material: StandardMaterial3D  ## Only change the color

@export var normal_color: Color
@export var perfect_color: Color
@export var charged_color: Color

@export var weapon_bow: Node3D

@onready var arrow_trail: PackedScene = preload("uid://bf5v1j8tkokci")
@onready var main_scene: Node3D = Utility.find_type(get_tree().get_root(), Node3D)


func _ready() -> void:
	weapon_bow.on_cast_normal_shot.connect(cast_normal_shot)
	weapon_bow.on_cast_perfect_shot.connect(cast_perfect_shot)
	weapon_bow.on_cast_charged_shot.connect(cast_charged_shot)
	
	# First time instantiate to avoid lag
	# Weird hack lmfao
	await get_tree().process_frame
	var trans: Transform3D = Transform3D.IDENTITY
	trans.origin = Vector3.ONE * 5000.0
	cast_normal_shot(trans, 1.0)


func cast_normal_shot(_global_transform: Transform3D, range: float):
	var new_trail: Node3D = arrow_trail.instantiate()
	var trail_mesh: MeshInstance3D = new_trail.get_node("MeshInstance3D")
	
	new_trail.global_transform = _global_transform
	new_trail.scale.z = range
	
	var new_material: StandardMaterial3D = default_material.duplicate()
	new_material.albedo_color = normal_color
	new_material.emission = normal_color
	new_trail.get_node("MeshInstance3D").material_override = new_material
	
	main_scene.add_child(new_trail)
	
	var trail_mat: StandardMaterial3D = trail_mesh.material_override
	var tween = (
		create_tween()
		.set_ease(Tween.EASE_IN)
		.tween_property(trail_mesh, "transparency", 1.0, 0.2)
	)
	await tween.finished
	new_trail.queue_free()


func cast_perfect_shot(_global_transform: Transform3D, range: float):
	var new_trail: Node3D = arrow_trail.instantiate()
	var trail_mesh: MeshInstance3D = new_trail.get_node("MeshInstance3D")
	
	new_trail.global_transform = _global_transform
	new_trail.scale.z = range
	
	var new_material: StandardMaterial3D = default_material.duplicate()
	new_material.albedo_color = perfect_color
	new_material.emission = perfect_color
	new_trail.get_node("MeshInstance3D").material_override = new_material
	
	main_scene.add_child(new_trail)
	
	var trail_mat: StandardMaterial3D = trail_mesh.material_override
	var tween = (
		create_tween()
		.set_ease(Tween.EASE_IN)
		.tween_property(trail_mesh, "transparency", 1.0, 0.2)
	)
	await tween.finished
	new_trail.queue_free()


func cast_charged_shot(_global_transform: Transform3D, range: float):
	var new_trail: Node3D = arrow_trail.instantiate()
	var trail_mesh: MeshInstance3D = new_trail.get_node("MeshInstance3D")
	
	new_trail.global_transform = _global_transform
	new_trail.scale.x = 5.0
	new_trail.scale.y = 5.0
	new_trail.scale.z = range
	
	var new_material: StandardMaterial3D = default_material.duplicate()
	new_material.albedo_color = charged_color
	new_material.emission = charged_color
	new_trail.get_node("MeshInstance3D").material_override = new_material
	
	
	main_scene.add_child(new_trail)
	
	var trail_mat: StandardMaterial3D = trail_mesh.material_override
	var tween = create_tween().set_ease(Tween.EASE_IN).tween_property(trail_mesh, "transparency", 1.0, 0.4)
	await tween.finished
	new_trail.queue_free()
