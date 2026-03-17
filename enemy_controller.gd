extends Node

@export var player : Player

var time_until_next_shot := 1.0

func _physics_process(delta: float) -> void:
	player.input_dir.y = 1
	player.input_dir.x = sin(Time.get_ticks_msec() / 1000.0)
	time_until_next_shot -= delta
	if time_until_next_shot < 0:
		player.is_shot_just_pressed = true
		time_until_next_shot = randf_range(0.1, 2.0)
		return
	if player.is_shot_just_pressed:
		player.is_shot_just_pressed = false
		
