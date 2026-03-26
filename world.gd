class_name World extends Node2D

@export var world_surface: ColorRect
@export var player: Player

@export var shoot_beams := false

@export var sphere_world: Node3D
@export var non_euclidean_world: Node2D

const EXPLOSION = preload("uid://c2d7cuatruidk")
const ENEMY_FOLLOWER = preload("uid://invktu518qg5")

@export var radius := 100.0

var basis : Basis

var players : Array[Player]

var bullets : Array[Bullet]

var beams : Array[LaserBeam]

@export var enemy_scene : PackedScene

@export var score_label : Label

const LASER_BEAM = preload("uid://ch3lygrrqiqd0")


var score := 0:
	set(v):
		if not score_label:
			return
		score = v
		score_label.text = "Score: " + str(score)

@export var audio_stream_player: AudioStreamPlayer


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
		for beam in beams:
			if not beam:
				continue
			var original_wrap = beam.wrap_around
			var a := beam.start_point
			var b := beam.end_point
			var n := beam.start_point.cross(beam.end_point).normalized()
			var c := p.basis.z
			var c_proj := (c - n * c.dot(n))
			var side_1 := a.cross(c_proj).dot(n)
			var side_2 := c_proj.cross(b).dot(n)
			var inside := side_1 > 0 and side_2 > 0
			if beam.wrap_around:
				inside = not inside
			var d_a := c.dot(a)
			var d_b := c.dot(b)
			var closer := b if d_b > d_a else a
			var _p := closer if not inside else c_proj
			var d := c.dot(_p)
			if d > cos((p.player_radius + beam.radius) / radius * PI):
				audio_stream_player.stream = EXPLOSION
				audio_stream_player.play()
				players.erase(p)
				p.queue_free()
				
				#o.queue_free()
				#beams.erase(o)
				
				var beam_rot_dir := beam.rotate_around
				
				var intersection_point := _p
				
				var b1_start := beam.start_point
				
				var angle := p.player_radius / radius * PI
				
				var b1_end := intersection_point.rotated(beam_rot_dir, -angle)
				
				var start_cross := b1_start.cross(b1_end)
				
				var create_start := (start_cross.dot(beam_rot_dir) > 0)
				
				var b2_start := intersection_point.rotated(beam_rot_dir, angle)
				var b2_end := beam.end_point
				
				var end_cross := b2_start.cross(b2_end)
				
				var create_end := (end_cross.dot(beam_rot_dir) > 0)
				
				if create_end and create_start:
					print("creating both")
					var new_beam : LaserBeam = LASER_BEAM.instantiate()
					beam.wrap_around = (beam_rot_dir.dot(start_cross) < 0)
					beam.start_point = b1_start
					beam.end_point = b1_end
					new_beam.start_point = b2_start
					new_beam.end_point = b2_end
					new_beam.world = self
					new_beam.rotate_around = beam.rotate_around
					non_euclidean_world.add_child(new_beam)
					new_beam.wrap_around = (beam_rot_dir.dot(end_cross) < 0)
					new_beam.is_shot = true
				elif create_start:
					beam.start_point = b1_start
					beam.end_point = b1_end
					beam.wrap_around = (beam_rot_dir.dot(start_cross) < 0)
				elif create_end:
					beam.wrap_around = (beam_rot_dir.dot(end_cross) < 0)
					beam.start_point = b2_start
					beam.end_point = b2_end
				else:
					beams.erase(beam)
					beam.queue_free()
				
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
	basis.z = player.basis.z
	basis.x = basis.x.slerp(player.basis.x, _delta * 10.0)
	basis.y = basis.z.cross(basis.x)
	(world_surface.material as ShaderMaterial).set_shader_parameter("world_rot", basis)
