extends PlayerState

var isStandDone := false

func enter(previous_state_path: String, data := {}) -> void:
	isStandDone = false
	player.animation_player.play("standup")
	
	if not player.animation_player.is_connected("animation_finished", Callable(self, "on_anim_finished")):
		player.animation_player.animation_finished.connect(on_anim_finished)
		
	print("standing")
	

func on_anim_finished(anim_name: StringName) -> void:
	if anim_name == "standup":
		isStandDone = true

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
	
	if !is_moving and player.is_on_floor() and isStandDone:
		finished.emit(IDLE)
	elif is_moving and player.is_on_floor() and isStandDone:
		finished.emit(WALKING)
	elif is_moving and player.is_on_floor() and isStandDone and Input.is_action_pressed("sprint"):
		finished.emit(SPRINTING)

func exit() -> void:
	if player.animation_player.is_connected("animation_finished", Callable(self, "on_anim_finished")):
		player.animation_player.animation_finished.disconnect(on_anim_finished)
