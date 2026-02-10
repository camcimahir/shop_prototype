extends Node3D

@onready var world_env: WorldEnvironment = $WorldEnvironment

var time_passed: float = 0.0

func _process(delta):
	time_passed += delta * 5.0 
	
	var pulse = (sin(time_passed) + 1.0) / 2.0
	
	var new_color = Color.RED.lerp(Color.BLUE, pulse)
	
	if world_env and world_env.environment:
		world_env.environment.background_color = new_color
