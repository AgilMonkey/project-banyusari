extends Node

signal player_bow_hold_percent_changed(value)

var player


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
