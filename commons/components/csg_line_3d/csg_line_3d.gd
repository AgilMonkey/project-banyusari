@tool
extends Node3D

@export var line_radius := 0.1
@export var line_resolution := 180

var points: PackedVector3Array

func _process(delta: float) -> void:
	var circle = PackedVector2Array()
	
	for degree in line_resolution:
		var x = line_radius * sin(PI * 2 * degree / line_resolution)
		var y = line_radius * cos(PI * 2 * degree / line_resolution)
		var cords = Vector2(x, y)
		circle.append(cords)
	
	$CSGPolygon3D.polygon = circle
	
	if not Engine.is_editor_hint():
		var curve: Curve3D = $Path3D.curve
		curve.point
