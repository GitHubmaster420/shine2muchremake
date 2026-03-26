extends Camera3D

@export var player_follower : PlayerFollower

var rot_matrix : Basis

func _ready() -> void:
	rot_matrix = basis

func _physics_process(_delta: float) -> void:
	global_basis = player_follower.basis * rot_matrix
