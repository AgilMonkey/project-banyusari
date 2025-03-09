extends CharacterBody3D


@onready var hitbox := $EnemyHitbox
@onready var health := $HealthComponent


func _ready() -> void:
	hitbox.on_hit.connect(damage)

	var old_material = $Gfx.material_override
	var new_material = old_material.duplicate()
	$Gfx.material_override = new_material


func damage(val):
	health.damage(val)
	lower_mat_color()


func lower_mat_color():
	var material: StandardMaterial3D = $Gfx.material_override
	var color := material.albedo_color

	color.v = health.cur_health_percent
	material.albedo_color = color


func _on_health_component_health_reached_zero() -> void:
	queue_free()
