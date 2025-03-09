extends RigidBody3D


var on_floor = false

@onready var health := $HealthComponent


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	on_floor = false
	var i := 0
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		on_floor = normal.dot(Vector3.UP) > 0.98 # this can be dialed in
		if on_floor:
			break
		#  1.0 would be perfectly straight up
		#  0.0 is a wall
		# -1.0 is a ceiling
		i += 1


func disable_player():
	enable_input(self, false)


func enable_input(node, enable):
	node.set_process_input(enable)
	for n in node.get_children():
		enable_input(n, enable)


func _on_player_hitbox_on_hit(damage: Variant) -> void:
	health.damage(damage)
