extends ColorRect

@export var world : World

var basis : Basis = Basis.IDENTITY.rotated(Vector3.UP, PI)

func _physics_process(delta: float) -> void:
	(material as ShaderMaterial).set_shader_parameter("world_rot", world.basis) #TODO: understand why not inverse lol
	(material as ShaderMaterial).set_shader_parameter("player_rot", basis.inverse())
