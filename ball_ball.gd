extends World
class_name BallBall

signal ball_controller_changed(player : FiedPlayer)

@export var ball : Ball
@export var field  : Field

var team_1_points := 0:
	set(v):
		team_1_points = v
		update_score()

var team_2_points := 0:
	set(v):
		team_2_points = v
		update_score()

func update_score():
	if not score_label:
		return
	score_label.text = "Score: " + str(team_1_points) + " - " + str(team_2_points)

func _ready() -> void:
	update_score()
	reset_game()

func reset_game():
	ball.player_controlling = null
	ball.last_touch_player = null
	for p : FiedPlayer in players:
		if p.on_team_1:
			p.basis = Basis.IDENTITY.rotated(Vector3.RIGHT, PI / 2.0)
		else:
			p.basis = Basis.IDENTITY.rotated(Vector3.RIGHT, -PI / 2.0)
	ball.basis = Basis.IDENTITY.rotated(Vector3.UP, randf_range(-PI, PI))
	ball.velocity = Vector2.ZERO
	field.reset_field()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if not player:
		return
	basis = player.basis
	(world_surface.material as ShaderMaterial).set_shader_parameter("world_rot", basis)
	do_ball_check()
	do_goal_check()

func do_ball_check():
	var o := ball
	for p : FiedPlayer in players:
		if p.has_ball or p.in_recoil:
			continue
		if (p.sphere_pos).angle_to(o.sphere_pos) < (p.player_radius + o.player_radius) / radius * PI:
			ball.player_controlling = p

func do_goal_check():
	var goal_scored := false
	var goal_1_radius := field.goal_1_radius
	var goal_1_pos := Vector3.DOWN
	if ball.sphere_pos.angle_to(goal_1_pos) < (goal_1_radius + ball.player_radius) / radius * PI:
		team_1_points += 1
		goal_scored = true
	var goal_2_radius := field.goal_2_radius
	var goal_2_pos := Vector3.UP
	if ball.sphere_pos.angle_to(goal_2_pos) < (goal_2_radius + ball.player_radius) / radius * PI:
		team_2_points += 1
		goal_scored = true
	if goal_scored:
		reset_game()
	
