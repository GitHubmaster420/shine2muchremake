extends Node

@export var player : FiedPlayer

@export var current_state : State

var reaction_time := 0.1

@export var chase_ball : State
@export var defend_goal : State
@export var attack_goal : State

func _ready() -> void:
	(player.world as BallBall).ball_controller_changed.connect(on_player_controlling_changed)

func on_player_controlling_changed(_player : FiedPlayer):
	if not _player:
		current_state = chase_ball
	elif player.on_team_1 == _player.on_team_1:
		current_state = attack_goal
	else:
		current_state = defend_goal

func _physics_process(delta: float) -> void:
	await get_tree().create_timer(reaction_time).timeout
	player.input_dir = current_state.get_movement_input()
