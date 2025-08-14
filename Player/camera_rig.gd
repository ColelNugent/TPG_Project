extends SpringArm3D

@onready var camera := $Camera3D
@export var mouse_sensitivity := 0.3

var input_dir : Vector2
var mouse_dir : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	toggle_mouse()
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		input_dir = -Input.get_vector("view_left", "view_right", "view_up", "view_down")
		rotation_degrees.x += mouse_dir.y + input_dir.y
		rotation_degrees.y += mouse_dir.x + input_dir.x
		mouse_dir = Vector2()
		rotation_degrees.x = clampf(rotation_degrees.x, -70, 70)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_dir = -event.relative * mouse_sensitivity

func toggle_mouse() -> void:
	if Input.is_action_just_pressed("toggle_mouse") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("toggle_mouse") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
