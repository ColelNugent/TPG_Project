extends MeshInstance3D

@export var rotate_rate : float = 20.0
var target_y_rot : float = 0.0

@onready var player : CharacterBody3D = get_parent()

func _process(delta: float) -> void:
	_smooth_rotation(delta)
	
func _smooth_rotation(delta):
	var velocity = -player.velocity
	if velocity.x != 0 or velocity.z != 0:
		target_y_rot = atan2(velocity.x, velocity.z)
		
	rotation.y = lerp_angle(rotation.y, target_y_rot, rotate_rate * delta)
	
