extends RigidBody3D


func _ready() -> void:
	await get_tree().create_timer(10.0).timeout
	call_deferred("queue_free")


func _physics_process(delta: float) -> void:
	pass
	#transform.basis.z = transform.basis.z.move_toward(-linear_velocity.normalized(), delta*10.0)


func _on_body_entered(body: Node) -> void:
	freeze = true
	call_deferred("reparent", body)
