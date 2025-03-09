extends Node3D


func _on_restart_ui_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
