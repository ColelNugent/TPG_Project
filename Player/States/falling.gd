extends PlayerState

@export var landing_speed_thres : float = 9.0

var pre_move_vy := 0.0
var curSpeed := NO_SPEED_MULT

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("falling")
	print("falling")
	

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	var input_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if Input.is_action_pressed("sprint"):
		curSpeed *= player.sprint_mult
		
	move_with_input(input_direction, curSpeed)
	curSpeed = NO_SPEED_MULT
	
	pre_move_vy = player.velocity.y
	player.move_and_slide()
	
	if not player.is_on_floor():
		return
	
	var impact_speed : float = -pre_move_vy
	if impact_speed >= landing_speed_thres:
		finished.emit(LANDING)
		return
	
	var is_moving := ( 
		Input.is_action_pressed("move_left") or
		Input.is_action_pressed("move_right") or
		Input.is_action_pressed("move_forward") or
		Input.is_action_pressed("move_backward")
	)
	
	if Input.is_action_pressed("sprint") and is_moving:
		finished.emit(SPRINTING)
	elif is_moving:
		finished.emit(WALKING)
	else:
		finished.emit(IDLE)
