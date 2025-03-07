extends Node


var mouse_sensitivity: float = 0.1
var other_sensitivity: float = 0.5

var min_yaw: float = 0
var max_yaw: float = 360

var min_pitch: float = -70.0
var max_pitch: float = 80.0

var look_direction: Vector2

@onready var target: Node3D = get_parent()


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event) -> void:
	look_direction = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Trigger whenever the mouse moves.
	if event is InputEventMouseMotion:
		var pcam_rotation_degrees: Vector3
		# Assigns the current 3D rotation of the SpringArm3D node - to start off where it is in the editor.
		pcam_rotation_degrees = target.rotation_degrees
		# Change the X rotation.
		pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity
		# Clamp the rotation in the X axis so it can go over or under the target.
		pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_pitch, max_pitch)
		# Change the Y rotation value.
		pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity
		# Sets the rotation to fully loop around its target, but without going below or exceeding 0 and 360 degrees respectively.
		pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_yaw, max_yaw)
		# Change the SpringArm3D node's rotation and rotate around its target.
		target.rotation_degrees = pcam_rotation_degrees


func _process(delta: float) -> void:
	if look_direction:
		var pcam_rotation_degrees: Vector3
		# Assigns the current 3D rotation of the SpringArm3D node - to start off where it is in the editor.
		pcam_rotation_degrees = target.rotation_degrees
		# Change the X rotation.
		pcam_rotation_degrees.x += look_direction.y * other_sensitivity
		# Clamp the rotation in the X axis so it can go over or under the target.
		pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_pitch, max_pitch)
		# Change the Y rotation value.
		pcam_rotation_degrees.y -= look_direction.x * other_sensitivity
		# Sets the rotation to fully loop around its target, but without going below or exceeding 0 and 360 degrees respectively.
		pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_yaw, max_yaw)
		# Change the SpringArm3D node's rotation and rotate around its target.
		target.rotation_degrees = pcam_rotation_degrees
