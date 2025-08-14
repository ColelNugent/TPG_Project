extends PlayerState

var is_charging_jump := false
var launch_timer : SceneTreeTimer
var state_active := false

func enter(previous_state_path: String, data := {}) -> void:
	state_active = true
	is_charging_jump = true
	player.animation_player.play("jump")
	
	launch_timer = get_tree().create_timer(0.5)
	_start_delayed_launch()
	

func _start_delayed_launch() -> void:
	await launch_timer.timeout
	if not state_active:
		return
	player.velocity.y = player.jump_velocity
	is_charging_jump = false
	print("jumping")
	
func exit() -> void:
	state_active = false
	is_charging_jump = false

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	var input_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move_with_input(input_direction, NO_SPEED_MULT)
	player.move_and_slide()
	
	if is_charging_jump:
		return
	
	var is_moving := ( 
		Input.is_action_pressed("move_left") or
		Input.is_action_pressed("move_right") or
		Input.is_action_pressed("move_forward") or
		Input.is_action_pressed("move_backward")
	)
	
	if player.velocity.y < 0 and !(player.is_on_floor()):
		finished.emit(FALLING)
