extends Node3D

@export var player_follower : PlayerFollower

func _physics_process(delta: float) -> void:
	basis = player_follower.basis * Basis.FLIP_Z * Basis.FLIP_X
