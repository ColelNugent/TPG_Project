extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("sprint_jump")
	player.velocity.y = player.jump_velocity
	print("Sprint jumping")


func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	var input_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move_with_input(input_direction, player.sprint_mult)
	player.move_and_slide()
	
	var is_moving := ( 
		Input.is_action_pressed("move_left") or
		Input.is_action_pressed("move_right") or
		Input.is_action_pressed("move_forward") or
		Input.is_action_pressed("move_backward")
	)
	
	if player.velocity.y < 0 and !(player.is_on_floor()):
		finished.emit(FALLING)
	elif player.is_on_floor() and is_moving:
		finished.emit(WALKING)
	elif player.is_on_floor() and !is_moving:
		finished.emit(IDLE)
