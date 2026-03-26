extends State

@export var player : FiedPlayer

func get_movement_input() -> Vector2:
	var player_basis := player.basis
	var ball_basis := (player.world as BallBall).ball.basis
	
	var forward_input := 1.0
	
	var right_vector := player_basis.z.cross(ball_basis.z).normalized()
	
	var player_right := player.basis.x
	
	var player_up := player.basis.z
	
	var angle := player_right.signed_angle_to(right_vector, player_up)
	
	var side_input := angle / PI
	
	return Vector2(side_input, forward_input)
