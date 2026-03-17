class_name Player extends ColorRect

@export var world : World

@onready var radius := world.radius

var sphere_pos : Vector3

var basis : Basis = Basis.IDENTITY

@export_range(-PI, PI, 0.1) var yaw := 0.0
@export_range(-PI, PI, 0.1) var pitch := 0.0
@export_range(-PI, PI, 0.1) var roll := 0.0

@export var forward_max_speed := 50.0 # pixels/s
@export var forward_accel := 50.0 # pixels/s^2

@export var roll_max_speed := PI # rad/s
@export var roll_accel := PI # rad/s^2

var forward_rad_max_speed : float
var forward_rad_accel : float

var velocity := Vector2.ZERO # local x rot, local y rot (rad)
const BULLET = preload("uid://bm51xp3emdojp")

@export var player_radius := 10.0

@export var controlled_by_player := false

var is_shot_just_pressed := false

var input_dir := Vector2.ZERO

var created_at_start := true

func _ready() -> void:
	forward_rad_max_speed = forward_max_speed / radius
	forward_rad_accel = forward_accel / radius
	(material as ShaderMaterial).set_shader_parameter("size_inverse", 0.5 * radius / player_radius)
	world.players.append(self)
	
	if created_at_start:
		basis = Basis.from_euler(Vector3(yaw, pitch, roll))
	sphere_pos = basis.z

func _physics_process(delta: float) -> void:
	velocity.x = move_toward(velocity.x, input_dir.x * roll_max_speed, delta * roll_accel)
	velocity.y = move_toward(velocity.y, input_dir.y * forward_rad_max_speed, delta * forward_rad_accel)
	basis = basis.rotated(basis.z, velocity.x * delta)
	basis = basis.rotated(basis.x, velocity.y * delta)
	sphere_pos = basis.z
	(material as ShaderMaterial).set_shader_parameter("world_rot", world.basis) #TODO: understand why not inverse lol
	(material as ShaderMaterial).set_shader_parameter("player_rot", basis.inverse())
	
	if is_shot_just_pressed:
		var b : Bullet = BULLET.instantiate()
		b.visible = false
		(b as Bullet).basis = basis.rotated(basis.x, ((player_radius + b.player_radius) / radius * PI + 0.001))
		(b as Bullet).world = world
		world.add_child(b)
		world.bullets.append(b)
