extends Node3D


@onready var player := $Player


func _ready() -> void:
	player.health.health_reached_zero.connect(game_over)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_K and event.is_released():
			player.health.damage(5)
			$CanvasLayer/UI/HealthbarUI.set_healthbar_value(player.health.cur_health)


func game_over():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player.disable_player()
	$CanvasLayer/UI/RestartUI.show()


func _on_restart_ui_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
