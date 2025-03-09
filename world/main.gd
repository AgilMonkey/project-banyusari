extends Node3D


@onready var player := $Player


func _ready() -> void:
	player.health.health_reached_zero.connect(game_over)
	player.health.health_changed.connect(func(val):
		$CanvasLayer/UI/HealthbarUI.set_healthbar_value(val)
		)


func game_over():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player.disable_player()
	$CanvasLayer/UI/RestartUI.show()


func _on_restart_ui_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
