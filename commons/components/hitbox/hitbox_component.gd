class_name HitboxComponent
extends Area3D


signal on_hit(damage)


func _on_area_entered(area: Area3D) -> void:
	if "damage" in area:
		on_hit.emit(area.damage)
