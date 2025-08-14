class_name PlayerState extends State

const IDLE = "Idle"
const WALKING = "Walking"
const SPRINTING = "Sprinting"
const JUMPING = "Jumping"
const SPRINT_JUMPING = "Sprint_Jumping"
const FALLING = "Falling"
const LANDING = "Landing"
const SQUATTING = "Squatting"
const IDLE_CROUCH = "Idle_Crouch"
const WALK_CROUCH = "Walk_Crouch"
const STANDUP = "Standup"
const SLASH_1 = "Slash_1"
const SLASH_2 = "Slash_2"
const SLASH_3 = "Slash_3"

const NO_SPEED_MULT := 1

var player : Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. 
	It needs the owner to be a Player node.")

func move_with_input(input_vector: Vector2, speed_scale: float = 1.0) -> void:
	var cam_xform: Transform3D = player.camera.global_transform
	var forward: Vector3 = cam_xform.basis.z
	var right: Vector3 = cam_xform.basis.x

	var direction: Vector3 = (right * input_vector.x + forward * input_vector.y).normalized()

	if direction != Vector3.ZERO:
		player.velocity.x = direction.x * player.speed * speed_scale
		player.velocity.z = direction.z * player.speed * speed_scale

		var look_target: Vector3 = player.global_transform.origin + direction
		var look_dir: Vector3 = (look_target - player.model.global_transform.origin).normalized()
		var target_rotation_y: float = atan2(look_dir.x, look_dir.z)

		player.model.rotation.y = lerp_angle(
			player.model.rotation.y,
			target_rotation_y,
			10.0 * get_physics_process_delta_time()
		)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, player.speed)
		player.velocity.z = move_toward(player.velocity.z, 0.0, player.speed)
