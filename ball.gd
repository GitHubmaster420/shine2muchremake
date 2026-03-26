class_name Ball extends ColorRect

@export var recoil_time := .5

var player_controlling : FiedPlayer:
	set(v):
		if v == player_controlling:
			return
		
		if player_controlling:
			player_controlling.has_ball = false
			player_controlling.in_recoil = true
			player_controlling.time_until_recoil = recoil_time
		player_controlling = v
		world.ball_controller_changed.emit(player_controlling)
		if player_controlling:
			if player_controlling == last_touch_player:
				if player_controlling.on_team_1:
					field.goal_2_radius += goal_self_pass_growth
				else:
					field.goal_1_radius += goal_self_pass_growth
			last_touch_player = player_controlling
			player_controlling.has_ball = true
			velocity = Vector2.ZERO

var last_touch_player : FiedPlayer = null

@export var world : BallBall
@onready var radius := world.radius

@export var field : Field

var sphere_pos : Vector3

var basis : Basis = Basis.IDENTITY

@export var forward_max_speed := 50.0 # pixels/s
@export var forward_accel := 50.0 # pixels/s^2

@export var roll_max_speed := PI # rad/s
@export var roll_accel := PI # rad/s^2

@export var player_radius := 10.0

var forward_rad_max_speed : float
var forward_rad_accel : float

var velocity := Vector2.ZERO # local x rot, local y rot (rad)

@export var goal_growth_when_controlled := 5.0 #pixels/s
@export var goal_self_pass_growth := 10.0 #pixeld

func _ready() -> void:
	forward_rad_max_speed = forward_max_speed / radius
	forward_rad_accel = forward_accel / radius
	(material as ShaderMaterial).set_shader_parameter("size_inverse", 0.5 * radius / player_radius)
	sphere_pos = basis.z
	#await get_tree().physics_frame
	#visible = true

func _physics_process(delta: float) -> void:
	basis = basis.rotated(basis.x.normalized(), velocity.x * delta).orthonormalized()
	basis = basis.rotated(basis.z.normalized(), velocity.y * delta).orthonormalized()
	sphere_pos = basis.z
	(material as ShaderMaterial).set_shader_parameter("world_rot", world.basis) #TODO: understand why not inverse lol
	(material as ShaderMaterial).set_shader_parameter("player_rot", basis.inverse())
	if player_controlling:
		if player_controlling.on_team_1:
			field.goal_1_radius += goal_growth_when_controlled * delta
		else:
			field.goal_2_radius += goal_growth_when_controlled * delta
