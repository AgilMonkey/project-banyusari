extends Control


@onready var health_bar = $HealthBar


func set_healthbar_value(val):
	health_bar.value = val
