extends State

@export var player : Player

func get_movement_input() -> Vector2:
	var player_basis := player.basis
	var goal_pos := Vector3.DOWN
	
	var forward_input := 1.0
	
	var right_vector := player_basis.z.cross(goal_pos).normalized()
	
	var player_right := player.basis.x
	
	var player_up := player.basis.z
	
	var angle := player_right.signed_angle_to(right_vector, player_up)
	
	var side_input := angle / PI
	
	return Vector2(side_input, forward_input)
