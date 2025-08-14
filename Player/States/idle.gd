extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.set_collider(player.stand_height, player.stand_hitbox_y)
	player.velocity.x = 0.0
	player.animation_player.play("idle")
	print("idle")
	

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	
	var is_moving := ( 
		Input.is_action_pressed("move_left") or
		Input.is_action_pressed("move_right") or
		Input.is_action_pressed("move_forward") or
		Input.is_action_pressed("move_backward")
	)
	
	if Input.is_action_just_pressed("attack") and player.is_on_floor():
		finished.emit(SLASH_1)
	elif Input.is_action_just_pressed("jump") and player.is_on_floor():
		finished.emit(JUMPING)
	elif is_moving and player.is_on_floor():
		finished.emit(WALKING)
	elif Input.is_action_just_pressed("crouch") and player.is_on_floor():
		finished.emit(SQUATTING)
	elif !player.is_on_floor():
		finished.emit(FALLING)
