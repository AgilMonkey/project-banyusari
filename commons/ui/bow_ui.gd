extends Control


func _ready() -> void:
	Global.player_bow_hold_percent_changed.connect(
		func (value):
			%BowHoldProgress.value = value
			)
