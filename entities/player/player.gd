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
