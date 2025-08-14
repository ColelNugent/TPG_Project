extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.set_collider(player.crouch_height, player.crouch_hitbox_y)
	player.animation_player.play("crouchwalk")
	print("crouch walking")
	

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	var input_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move_with_input(input_direction, player.crouch_mult)
	player.move_and_slide()
	
	var is_moving := ( 
		Input.is_action_pressed("move_left") or
		Input.is_action_pressed("move_right") or
		Input.is_action_pressed("move_forward") or
		Input.is_action_pressed("move_backward")
	)
	
	if Input.is_action_just_pressed("jump") and player.can_stand():
		finished.emit(JUMPING)
	elif !player.is_on_floor():
		finished.emit(FALLING)
	elif (Input.is_action_pressed("sprint") or Input.is_action_just_pressed("crouch")) and player.can_stand():
		finished.emit(STANDUP)
	elif not is_moving:
		finished.emit(IDLE_CROUCH)
