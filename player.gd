class_name Player extends ColorRect

@export var world : World

@onready var radius := world.radius

var sphere_pos : Vector3

var basis : Basis = Basis.IDENTITY

const LASER_SHOOT = preload("uid://d3j1fcdkn7le8")

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
const LASER_BEAM = preload("uid://ch3lygrrqiqd0")

@export var player_radius := 10.0

@export var controlled_by_player := false

var is_shot_just_pressed := false

var is_shot_just_released := false

var is_shot_pressed := false

var input_dir := Vector2.ZERO

var created_at_start := true

var current_beam : LaserBeam

func _ready() -> void:
	forward_rad_max_speed = forward_max_speed / radius
	forward_rad_accel = forward_accel / radius
	(material as ShaderMaterial).set_shader_parameter("size_inverse", 0.5 * radius / player_radius)
	world.players.append(self)
	
	if created_at_start:
		basis = Basis.from_euler(Vector3(yaw, pitch, roll))
	sphere_pos = basis.z
	(material as ShaderMaterial).set_shader_parameter("world_rot", world.basis) #TODO: understand why not inverse lol
	(material as ShaderMaterial).set_shader_parameter("player_rot", basis.inverse())

func _physics_process(delta: float) -> void:
	velocity.x = move_toward(velocity.x, input_dir.x * roll_max_speed, delta * roll_accel)
	velocity.y = move_toward(velocity.y, input_dir.y * forward_rad_max_speed, delta * forward_rad_accel)
	basis = basis.rotated(basis.z.normalized(), velocity.x * delta).orthonormalized()
	basis = basis.rotated(basis.x.normalized(), velocity.y * delta).orthonormalized()
	sphere_pos = basis.z
	(material as ShaderMaterial).set_shader_parameter("world_rot", world.basis) #TODO: understand why not inverse lol
	(material as ShaderMaterial).set_shader_parameter("player_rot", basis.inverse())
	
	if is_shot_just_pressed:
		is_shot_pressed = true
		if not world.shoot_beams:
			world.audio_stream_player.stream = LASER_SHOOT
			world.audio_stream_player.play()
			var b : Bullet = BULLET.instantiate()
			b.visible = false
			(b as Bullet).basis = basis.rotated(basis.x, ((player_radius + b.player_radius) / radius * PI + 0.001))
			(b as Bullet).world = world
			world.non_euclidean_world.add_child(b)
			b.position = Vector2.ZERO
			world.bullets.append(b)
		else:
			current_beam = LASER_BEAM.instantiate()
			current_beam.start_point = basis.z.rotated(basis.x, ((player_radius + current_beam.radius) / radius * PI + 0.001))
			current_beam.rotate_around = basis.x
			current_beam.world = world
			world.non_euclidean_world.add_child(current_beam)
			current_beam.position = Vector2.ZERO
	if world.shoot_beams:
		if is_shot_pressed:
			current_beam.start_point = basis.z.rotated(basis.x, ((player_radius + current_beam.radius) / radius * PI + 0.001))
			current_beam.rotate_around = basis.x
			current_beam.position = Vector2.ZERO
		if is_shot_just_released:
			is_shot_pressed = false
			if current_beam:
				current_beam.is_shot = true
			current_beam = null

func _exit_tree() -> void:
	if current_beam:
		current_beam.queue_free()
