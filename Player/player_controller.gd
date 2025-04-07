extends CharacterBody3D

@export var move_speed : float = 5.0
@export var sprint_speed : float = 8.0
@export var jump_force : float = 8.0
@export var gravity : float = 20.0

@onready var camera : Camera3D = $SpringArmPivot/Camera3D

var move_diff = move_speed

func _physics_process(delta: float) -> void:
	# Gravity
	velocity.y -= gravity * delta
	
	# Jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		
	# Crouching
	if Input.is_action_pressed("crouch"):
		print("CROUCHING")
	
	# Movement
	var move_input : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var move_direction : Vector3 = Vector3(move_input.x, 0, move_input.y).normalized()
	move_direction = move_direction.rotated(Vector3.UP, camera.global_rotation.y)
	
	if Input.is_action_pressed("sprint"):
		velocity.x = move_direction.x * sprint_speed
		velocity.z = move_direction.z * sprint_speed
	else:
		velocity.x = move_direction.x * move_speed
		velocity.z = move_direction.z * move_speed
	
	move_and_slide()
