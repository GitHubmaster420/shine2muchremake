class_name World extends Node2D

@onready var world_surface: ColorRect = $SubViewportContainer/SubViewport/NonEuclideanWorld/WorldSurface
@onready var player: Player = $SubViewportContainer/SubViewport/NonEuclideanWorld/Player


@onready var sphere_world: Node3D = $SubViewport/SphereWorld
@onready var non_euclidean_world: Node2D = $SubViewportContainer/SubViewport/NonEuclideanWorld

const EXPLOSION = preload("uid://c2d7cuatruidk")
const ENEMY_FOLLOWER = preload("uid://invktu518qg5")

@export var radius := 100.0

var basis : Basis

var players : Array[Player]

var bullets : Array[Bullet]

@export var enemy_scene : PackedScene

@export var score_label : Label

var score := 0:
	set(v):
		if not score_label:
			return
		score = v
		score_label.text = "Score: " + str(score)

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	var handled : Array[Player]
	for p in players:
		if not p:
			continue
		handled.append(p)
		for o in players:
			if not o:
				continue
			if o in handled:
				continue
			
			if (p.sphere_pos).angle_to(o.sphere_pos) < (p.player_radius + o.player_radius) / radius * PI:
				players.erase(p)
				p.queue_free()
				
		for o in bullets:
			if (p.sphere_pos).angle_to(o.sphere_pos) < (p.player_radius + o.player_radius) / radius * PI:
				audio_stream_player.stream = EXPLOSION
				audio_stream_player.play()
				players.erase(p)
				p.queue_free()
				
				o.queue_free()
				bullets.erase(o)
				if p != player:
					score += 100
					if not player:
						return
					var new_enemy : Player = enemy_scene.instantiate()
					new_enemy.created_at_start = false
					new_enemy.basis = player.basis.rotated(player.basis.x.rotated(player.basis.z, randf_range(-PI, PI)), randf_range(PI/2.0, PI))
					new_enemy.world = self
					new_enemy.visible = true
					non_euclidean_world.add_child(new_enemy)
					var pf : PlayerFollower = ENEMY_FOLLOWER.instantiate()
					pf.player = new_enemy
					sphere_world.add_child(pf)
					new_enemy.position = Vector2.ZERO
					players.append(new_enemy)
					
	if not player:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
		return
	basis = player.basis
	(world_surface.material as ShaderMaterial).set_shader_parameter("world_rot", basis)
