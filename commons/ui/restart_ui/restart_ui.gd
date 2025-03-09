extends Control


signal restart_button_pressed


func _on_restart_button_pressed() -> void:
	restart_button_pressed.emit()
