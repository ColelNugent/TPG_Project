extends PlayerState

var isSquatDone := false

func enter(previous_state_path: String, data := {}) -> void:
	isSquatDone = false
	player.animation_player.play("squatdown")
	
	if not player.animation_player.is_connected("animation_finished", Callable(self, "on_anim_finished")):
		player.animation_player.animation_finished.connect(on_anim_finished)
		
	print("squatting")
	

func on_anim_finished(anim_name: StringName) -> void:
	if anim_name == "squatdown":
		isSquatDone = true

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
	
	if !player.is_on_floor():
		finished.emit(FALLING)
	elif isSquatDone and is_moving:
		finished.emit(WALK_CROUCH)
	elif isSquatDone and !is_moving:
		finished.emit(IDLE_CROUCH)


func exit() -> void:
	if player.animation_player.is_connected("animation_finished", Callable(self, "on_anim_finished")):
		player.animation_player.animation_finished.disconnect(on_anim_finished)
