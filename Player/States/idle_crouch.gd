extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.set_collider(player.crouch_height, player.crouch_hitbox_y)
	player.velocity.x = 0.0
	player.animation_player.play("crouchidle")
	print("idle crouching")
	

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	
	var is_moving := ( 
		Input.is_action_pressed("move_left") or
		Input.is_action_pressed("move_right") or
		Input.is_action_pressed("move_forward") or
		Input.is_action_pressed("move_backward")
	)
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor() and player.can_stand():
		finished.emit(JUMPING)
	elif is_moving and player.is_on_floor():
		finished.emit(WALK_CROUCH)
	elif Input.is_action_just_pressed("crouch") and player.is_on_floor() and player.can_stand():
		finished.emit(STANDUP)
		
