extends Node3D
class_name BulletFollower

@export var bullet : Bullet
@onready var bullet_sprite: BulletSprite = $BulletSprite

func _ready() -> void:
	bullet_sprite.pixel_size = 2.0 * bullet.player_radius / bullet.radius / 1080.0

func _physics_process(_delta: float) -> void:
	if not bullet:
		queue_free()
		return
	global_basis = bullet.basis
