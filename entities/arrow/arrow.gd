extends RigidBody3D


@export var damage := 50


func _ready() -> void:
	await get_tree().create_timer(10.0).timeout
	call_deferred("queue_free")


func _physics_process(delta: float) -> void:
	pass
	#transform.basis.z = transform.basis.z.move_toward(-linear_velocity.normalized(), delta*10.0)


func _on_body_entered(body: Node) -> void:
	freeze = true
	call_deferred("reparent", body)
	
	if body.has_method("damage"):
		body.damage(damage)


func _on_arrow_hurtbox_body_entered(body: Node3D) -> void:
	$ArrowHurtbox.call_deferred("set_process_mode", ProcessMode.PROCESS_MODE_DISABLED)
