extends State

@export var player : FiedPlayer

func get_movement_input() -> Vector2:
	var player_basis := player.basis
	var goal_pos := Vector3.UP
	
	
	
	var right_vector := player_basis.z.cross(goal_pos)
	
	var right_distance := right_vector.length()
	
	var forward_input := sqrt(minf(right_distance, 1.0))
	
	var player_right := player.basis.x
	
	var player_up := player.basis.z
	
	var angle := player_right.signed_angle_to(right_vector / right_distance, player_up)
	
	var side_input := angle / PI
	
	return Vector2(side_input, forward_input)
