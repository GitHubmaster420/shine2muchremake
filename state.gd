class_name State extends Node

var active := false

func on_state_entered() -> void:
	active = true

func on_state_exited() -> void:
	active = false

func get_movement_input() -> Vector2:
	return Vector2.ZERO
