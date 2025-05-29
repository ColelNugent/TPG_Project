extends CharacterBody3D

@onready var armature = $Armature
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var anim_tree = $AnimationTree

@export var move_speed : float = 5.0
@export var sprint_speed : float = 12
@export var jump_force : float = 8.0
@export var gravity : float = 20.0

@export var min_zoom := 3.0
@export var max_zoom := 10.0
@export var zoom_speed := 7.0
var target_zoom := 7.0

const LERP_VAL = 0.15
var mouse_locked := true

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_locked = true
	target_zoom = spring_arm.spring_length

func _unhandled_input(event: InputEvent) -> void:
	# Zoom
	if event.is_action_pressed("wheel_up"):
		target_zoom = clamp(target_zoom - 1, min_zoom, max_zoom)
	if event.is_action_pressed("wheel_down"):
		target_zoom = clamp(target_zoom + 1, min_zoom, max_zoom)
		
	# Lock mouse when tab is clicked
	if event.is_action_pressed("toggle_mouse_capture"):
		if mouse_locked:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			mouse_locked = false
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			mouse_locked = true
			
	if event is InputEventMouseMotion and mouse_locked:
		spring_arm_pivot.rotate_y(-event.relative.x * .005)
		spring_arm.rotate_x(-event.relative.y * .005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
		
func _physics_process(delta: float) -> void:
	# Gravity
	velocity.y -= gravity * delta
	
	# Jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	# Movement
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	if direction:
		velocity.x = lerp(velocity.x, direction.x * move_speed, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * move_speed, LERP_VAL)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
	else:
		velocity.x = lerp(velocity.x, direction.x * 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * 0.0, LERP_VAL)
		
	if Input.is_action_pressed("sprint"):
		velocity.x = direction.x * sprint_speed
		velocity.z = direction.z * sprint_speed
	else:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed

	anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / move_speed)
	spring_arm.spring_length = lerp(spring_arm.spring_length, target_zoom, zoom_speed * delta)
	
	move_and_slide()
