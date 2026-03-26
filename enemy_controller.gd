extends Node

@export var player : Player

var time_until_next_shot := 5.0

var hold_time : float

@onready var beam_mode := player.world.shoot_beams

func _ready() -> void:
	if beam_mode:
		time_until_next_shot = 2.5

func _physics_process(delta: float) -> void:
	player.input_dir.y = 1
	player.input_dir.x = sin(Time.get_ticks_msec() / 500.0)
	time_until_next_shot -= delta
	if time_until_next_shot < 0:
		player.is_shot_just_pressed = true
		if beam_mode:
			hold_time = randf_range(0.1, 1.0)
			time_until_next_shot = INF
		else:
			time_until_next_shot = randf_range(0.1, 2.0)
		return
	if player.is_shot_just_pressed:
		player.is_shot_just_pressed = false
	if beam_mode:
		if player.is_shot_pressed:
			hold_time -= delta
			if hold_time < 0.0:
				player.is_shot_just_released = true
				time_until_next_shot = randf_range(0.25, 2.0)
				return
	if player.is_shot_just_released:
		player.is_shot_just_released = false
		
