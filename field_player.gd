class_name FiedPlayer extends Player

var in_recoil := false

var has_ball := false

var time_until_recoil := 1.0

@export var on_team_1 : bool

func _ready() -> void:
	forward_rad_max_speed = forward_max_speed / radius
	forward_rad_accel = forward_accel / radius
	(material as ShaderMaterial).set_shader_parameter("size_inverse", 0.5 * radius / player_radius)
	world.players.append(self)

func _physics_process(delta: float) -> void:
	velocity.x = move_toward(velocity.x, input_dir.x * roll_max_speed, delta * roll_accel)
	velocity.y = move_toward(velocity.y, input_dir.y * forward_rad_max_speed, delta * forward_rad_accel)
	basis = basis.rotated(basis.z.normalized(), velocity.x * delta).orthonormalized()
	basis = basis.rotated(basis.x.normalized(), velocity.y * delta).orthonormalized()
	sphere_pos = basis.z
	(material as ShaderMaterial).set_shader_parameter("world_rot", world.basis) #TODO: understand why not inverse lol
	(material as ShaderMaterial).set_shader_parameter("player_rot", basis.inverse())
	
	if has_ball:
		var b := (world as BallBall).ball
		(b).basis = basis.rotated(basis.x, ((player_radius + b.player_radius) / radius * PI + 0.001))
		if is_shot_just_pressed:
			
			b.velocity.x = b.forward_rad_max_speed
			b.velocity.y = velocity.x
			b.player_controlling = null
			b.position = Vector2.ZERO
	
	if in_recoil:
		time_until_recoil -= delta
		if time_until_recoil < 0:
			in_recoil = false
