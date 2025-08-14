extends PlayerState

const LUNGE_TIME := 0.07
const LUNGE_SPEED := 9.5

var lunge_timer : float = 0.0
var isSlashDone := false

func enter(previous_state_path: String, data := {}) -> void:
	isSlashDone = false
	lunge_timer = LUNGE_TIME
	
	player.unholstered_weapon.visible = true
	player.holstered_weapon.visible = false
	player.velocity.x = 0.0
	player.velocity.z = 0.0
	player.animation_player.play("slash_3")
	
	if not player.animation_player.is_connected("animation_finished", Callable(self, "on_anim_finished")):
		player.animation_player.animation_finished.connect(on_anim_finished)
		
	print("slash 3")
	

func on_anim_finished(anim_name: StringName) -> void:
	if anim_name == "slash_3":
		isSlashDone = true

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	
	if lunge_timer > 0.0:
		lunge_timer -= delta
		var fwd : Vector3 = player.model.global_transform.basis.z.normalized()
		player.velocity.x = fwd.x * LUNGE_SPEED
		player.velocity.z = fwd.z * LUNGE_SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, LUNGE_SPEED * 6.0 * delta)
		player.velocity.z = move_toward(player.velocity.z, 0.0, LUNGE_SPEED * 6.0 * delta)
	
	player.move_and_slide()
	
	var is_moving := ( 
		Input.is_action_pressed("move_left") or
		Input.is_action_pressed("move_right") or
		Input.is_action_pressed("move_forward") or
		Input.is_action_pressed("move_backward")
	)
	
	if Input.is_action_pressed("attack") and isSlashDone:
		finished.emit(SLASH_1)
	elif is_moving and isSlashDone:
		finished.emit(WALKING)
	elif !is_moving and isSlashDone:
		finished.emit(IDLE)

func exit() -> void:
	if player.animation_player.is_connected("animation_finished", Callable(self, "on_anim_finished")):
		player.animation_player.animation_finished.disconnect(on_anim_finished)
	
	player.unholstered_weapon.visible = false
	player.holstered_weapon.visible = true
