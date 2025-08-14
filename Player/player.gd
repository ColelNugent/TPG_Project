class_name Player extends CharacterBody3D

@export var speed := 3.75
@export var jump_velocity := 8
@export var gravity := -15
@export var sprint_mult := 2.5
@export var crouch_mult := .65
@export var crouch_height := 1.0
@export var stand_height := 2.0
@export var crouch_hitbox_y := 0.5
@export var stand_hitbox_y := 1.0

# When changing models make sure these are referenced correctly
@onready var animation_player := $ProtoPlayer/AnimationPlayer
@onready var state_debugger_ui := $StateDebuggerUI
@onready var camera := $SpringArm3D/Camera3D
@onready var model := $ProtoPlayer
@onready var hitbox := $Hitbox
@onready var holstered_weapon := $ProtoPlayer/Armature/Skeleton3D/BackAttachment
@onready var unholstered_weapon := $ProtoPlayer/Armature/Skeleton3D/HandAttachment

func set_collider(height: float, local_y: float) -> void:
	var cap := hitbox.shape as CapsuleShape3D
	cap.height = height
	hitbox.position.y = local_y

func can_stand() -> bool:
	var current_cap := hitbox.shape as CapsuleShape3D
	var probe := CapsuleShape3D.new()
	probe.radius = current_cap.radius
	probe.height = stand_height
	
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = probe
	var t : Transform3D = global_transform
	t.origin.y += stand_hitbox_y
	params.transform = t
	params.collision_mask = collision_mask
	params.exclude = [get_rid()]
	
	var space := get_world_3d().direct_space_state
	var hits := space.intersect_shape(params, 1)
	return hits.is_empty()
