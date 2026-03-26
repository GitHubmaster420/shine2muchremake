extends ColorRect
class_name LaserBeam

@export var world : World

@onready var world_radius := world.radius

@export var radius : float = 5.0

@export var start_point : Vector3
@export var end_point := Vector3.ZERO

@export var velocity : float = 10.0 #in pixels

var rotate_around : Vector3

var is_shot := false:
	set(v):
		is_shot = v
		if is_shot:
			(material as ShaderMaterial).set_shader_parameter("alpha_m", 1.0)

var wrap_around := false:
	set(v):
		wrap_around = v
		(material as ShaderMaterial).set_shader_parameter("wrap_around", wrap_around)

var length : float = 0:
	set(v):
		length = v
		wrap_around = length > PI
		

@export var grow_rate : float = 500.0

var triggered := false

func _ready() -> void:
	(material as ShaderMaterial).set_shader_parameter("cosRadius", cos(radius / world_radius * PI))# multiplied by pi bc world radius is stupid
	(material as ShaderMaterial).set_shader_parameter("alpha_m", 0.25)
	(material as ShaderMaterial).set_shader_parameter("A", start_point * world.basis)
	if not end_point:
		end_point = start_point
	(material as ShaderMaterial).set_shader_parameter("B", end_point * world.basis)

func _physics_process(delta: float) -> void:
	if not is_shot:
		length += grow_rate / world_radius * delta
		end_point = start_point.rotated(rotate_around, length)
	else:
		if not triggered:
			triggered = true
			world.beams.append(self)
			
		start_point = start_point.rotated(rotate_around, delta * velocity / world_radius)
		end_point = end_point.rotated(rotate_around, delta * velocity / world_radius)
	(material as ShaderMaterial).set_shader_parameter("A", start_point * world.basis)
	(material as ShaderMaterial).set_shader_parameter("B", end_point * world.basis)
