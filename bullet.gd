class_name Bullet extends ColorRect

@export var min_size := 10.0
@export var max_size := 540.0

const SCREEN_SIZE := 1080 * Vector2.ONE

@export var world : World

@onready var radius := world.radius

var sphere_pos : Vector3

var basis : Basis = Basis.IDENTITY

const BULLET_FOLLOWER = preload("uid://pref304axug5")

@export var forward_max_speed := 50.0 # pixels/s
@export var forward_accel := 50.0 # pixels/s^2

@export var roll_max_speed := PI # rad/s
@export var roll_accel := PI # rad/s^2

@export var player_radius := 10.0

var forward_rad_max_speed : float
var forward_rad_accel : float

var velocity := Vector2.ZERO # local x rot, local y rot (rad)

func _ready() -> void:
	forward_rad_max_speed = forward_max_speed / radius
	forward_rad_accel = forward_accel / radius
	velocity.x = forward_rad_max_speed
	(material as ShaderMaterial).set_shader_parameter("size_inverse", 0.5 * radius / player_radius)
	sphere_pos = basis.z
	await get_tree().physics_frame
	visible = true
	var bf : BulletFollower = BULLET_FOLLOWER.instantiate()
	bf.bullet = self
	world.sphere_world.add_child(bf)

func _physics_process(delta: float) -> void:
	basis = basis.rotated(basis.x.normalized(), velocity.x * delta).orthonormalized()
	sphere_pos = basis.z
	size = Vector2.ONE * (lerpf(max_size, min_size, (world.basis.z.dot(basis.z) + 1) * 0.5))
	scale = SCREEN_SIZE / size
	#doesn't do anything now, still rendered at same resolution
	(material as ShaderMaterial).set_shader_parameter("world_rot", world.basis) #TODO: understand why not inverse lol
	(material as ShaderMaterial).set_shader_parameter("player_rot", basis.inverse())
