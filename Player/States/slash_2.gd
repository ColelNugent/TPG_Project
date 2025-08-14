extends PlayerState

const COMBO_WINDOW_SEC : float = 0.2
const LUNGE_TIME := 0.07
const LUNGE_SPEED := 9.5

var lunge_timer : float = 0.0
var isSlashDone := false
var combo_window_active := false
var combo_timer : SceneTreeTimer

func enter(previous_state_path: String, data := {}) -> void:
	isSlashDone = false
	lunge_timer = LUNGE_TIME
	combo_window_active = false
	combo_timer = null
	
	player.unholstered_weapon.visible = true
	player.holstered_weapon.visible = false
	player.velocity.x = 0.0
	player.velocity.z = 0.0
	player.animation_player.play("slash_2")
	
	if not player.animation_player.is_connected("animation_finished", Callable(self, "on_anim_finished")):
		player.animation_player.animation_finished.connect(on_anim_finished)
		
	print("slash 2")
	

func on_anim_finished(anim_name: StringName) -> void:
	if anim_name == "slash_2":
		isSlashDone = true
		combo_window_active = true
		combo_timer = get_tree().create_timer(COMBO_WINDOW_SEC, false)
		combo_timer.timeout.connect(on_combo_timeout)

func on_combo_timeout() -> void:
	combo_window_active = false
	
	var is_moving := ( 
		Input.is_action_pressed("move_left") or
		Input.is_action_pressed("move_right") or
		Input.is_action_pressed("move_forward") or
		Input.is_action_pressed("move_backward")
	)
	
	if not is_queued_for_deletion():
		finished.emit(WALKING)
	else:
		finished.emit(IDLE)


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
	
	if isSlashDone and combo_window_active and Input.is_action_pressed("attack") and player.is_on_floor():
		finished.emit(SLASH_3)
		return

func exit() -> void:
	if player.animation_player.is_connected("animation_finished", Callable(self, "on_anim_finished")):
		player.animation_player.animation_finished.disconnect(on_anim_finished)
	
	if combo_timer:
		if combo_timer.timeout.is_connected(on_combo_timeout):
			combo_timer.timeout.disconnect(on_combo_timeout)
	combo_window_active = false
	player.unholstered_weapon.visible = false
	player.holstered_weapon.visible = true
