extends Node

@export var player : Player

func _physics_process(_delta: float) -> void:
	player.input_dir = Input.get_vector("left", "right", "down", "up")
	player.is_shot_just_pressed = Input.is_action_just_pressed("ui_accept")
