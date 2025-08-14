extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.set_collider(player.stand_height, player.stand_hitbox_y)
	player.animation_player.play("sprint")
	print("Sprinting")
	

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	var input_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move_with_input(input_direction, player.sprint_mult)
	player.move_and_slide()
	
	if input_direction == Vector2.ZERO:
		player.animation_player.play("idle")
	else:
		player.animation_player.play("sprint")
	
	var is_moving := ( 
		Input.is_action_pressed("move_left") or
		Input.is_action_pressed("move_right") or
		Input.is_action_pressed("move_forward") or
		Input.is_action_pressed("move_backward")
	)
	
	if not is_moving:
		player.velocity.x = 0
		player.velocity.z = 0
	
	if Input.is_action_just_pressed("attack") and player.is_on_floor():
		finished.emit(SLASH_1)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(SPRINT_JUMPING)
	elif !player.is_on_floor():
		finished.emit(FALLING)
	elif not Input.is_action_pressed("sprint"):
		finished.emit(WALKING)
	elif Input.is_action_just_pressed("crouch") and player.is_on_floor():
		finished.emit(SQUATTING)
	elif not is_moving:
		finished.emit(IDLE)
