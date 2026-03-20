extends Node3D
class_name PlayerFollower

@export var player : Player

@export var main_player := false
@onready var player_sprite: PlayerSprite = $PlayerSprite

func _ready() -> void:
	var ratio := player.player_radius / player.radius
	player_sprite.pixel_size = TAU * (2.0 * ratio**2 / 1080.0) / sin(ratio * TAU) * PI/2.0
	global_basis = player.basis


func _physics_process(_delta: float) -> void:
	if not is_node_ready():
		return
	if not player:
		if player_sprite:
			player_sprite.queue_free()
		if not main_player:
			queue_free()
		return
	global_basis = player.basis
