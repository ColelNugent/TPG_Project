extends PlayerState

var isLandingDone := false

func enter(previous_state_path: String, data := {}) -> void:
	isLandingDone = false
	player.velocity.x = 0.0
	player.velocity.z = 0.0
	player.animation_player.play("landing")
	
	if not player.animation_player.is_connected("animation_finished", Callable(self, "on_anim_finished")):
		player.animation_player.animation_finished.connect(on_anim_finished)
	
	print("landing")
	

func on_anim_finished(anim_name: StringName) -> void:
	if anim_name == "landing":
		isLandingDone = true

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if not isLandingDone:
		return
	
	var is_moving := ( 
		Input.is_action_pressed("move_left") or
		Input.is_action_pressed("move_right") or
		Input.is_action_pressed("move_forward") or
		Input.is_action_pressed("move_backward")
	)
	
	if Input.is_action_pressed("sprint") and player.is_on_floor():
		finished.emit(SPRINTING)
	elif is_moving and player.is_on_floor():
		finished.emit(WALKING)
	elif not is_moving and player.is_on_floor():
		finished.emit(IDLE)

func exit() -> void:
	if player.animation_player.is_connected("animation_finished", Callable(self, "on_anim_finished")):
		player.animation_player.animation_finished.disconnect(on_anim_finished)
