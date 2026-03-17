class_name World extends Node2D

@onready var world_surface: ColorRect = $WorldSurface
@onready var player: Player = $Player

@export var radius := 100.0

var basis : Basis

var players : Array[Player]

var bullets : Array[Bullet]

func _physics_process(_delta: float) -> void:
	var handled : Array[Player]
	for p in players:
		handled.append(p)
		for o in players:
			if o in handled:
				continue
			if (p.sphere_pos).angle_to(o.sphere_pos) < (p.player_radius + o.player_radius) / radius * PI:
				p.queue_free()
				players.erase(p)
		for o in bullets:
			if (p.sphere_pos).angle_to(o.sphere_pos) < (p.player_radius + o.player_radius) / radius * PI:
				p.queue_free()
				players.erase(p)
				o.queue_free()
				bullets.erase(o)
	if not player:
		return
	basis = player.basis
	(world_surface.material as ShaderMaterial).set_shader_parameter("world_rot", basis)
