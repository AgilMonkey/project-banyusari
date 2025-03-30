extends CharacterBody3D


var on_floor = false

@onready var health := $HealthComponent
@onready var controller: Node = $CharacterBodyPlayerController


func disable_player():
	enable_input(self, false)


func enable_input(node, enable):
	node.set_process_input(enable)
	for n in node.get_children():
		enable_input(n, enable)


func _on_player_hitbox_on_hit(damage: Variant) -> void:
	health.damage(damage)
