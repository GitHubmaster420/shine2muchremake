extends ColorRect
class_name Field

@export var world : World

var goal_1_radius : float = 10.0: ## Weird units, ratio between this and world radius is multiplied by pi
	set(v):
		goal_1_radius = v
		 
		var ratio := v / world.radius

		(material as ShaderMaterial).set_shader_parameter("goal_1_radius", ratio)

var goal_2_radius : float = 10.0:
	set(v):
		goal_2_radius = v
		
		var ratio := v / world.radius

		
		(material as ShaderMaterial).set_shader_parameter("goal_2_radius", ratio)

@onready var goal_radius_at_start := goal_1_radius

func reset_field():
	goal_1_radius = goal_radius_at_start
	goal_2_radius = goal_radius_at_start
