extends Node3D


@onready var player := $Player


func _ready() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.process_mode = Node.PROCESS_MODE_DISABLED
	
	player.health.health_reached_zero.connect(game_over)
	player.health.health_changed.connect(func(val):
		$CanvasLayer/UI/HealthbarUI.set_healthbar_value(val)
		)


func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_L):
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.process_mode = Node.PROCESS_MODE_INHERIT
	
	if Input.is_key_pressed(KEY_P):
		get_tree().reload_current_scene()


func game_over():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player.disable_player()
	$CanvasLayer/UI/RestartUI.show()


func _on_restart_ui_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
