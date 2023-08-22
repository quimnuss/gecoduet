extends Node2D

class_name EcoSpawner

@export var spawnable : PackedScene
@export var navigable_zone : NavigationAgent2D
@export var species : Constants.Species
	
var world_width : int = 1000
var world_height : int = 600

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# should we let the spawner decide where the spawn point start is?
# we will always have a position, either by player placing or elder logic
#func random_point_in_bounds():
#	var x = randi_range(100, world_width)
#	var y = randi_range(100, world_height)
#	return Vector2(x,y)
#
#func random_valid_point():
#	if not navigable_zone:
#		return random_point_in_bounds()
#	else:
#		return random_point_in_bounds()
#		# TODO
#		#navigable_zone.set_target_position(get_random_point(200))
#		#return navigable_zone.is_target_reachable()

func random_in_radius(spawnpoint : Vector2, radius = 200):
	var x = randi_range(10, radius)
	var y = randi_range(10, radius)
	# TODO check is target reachable or in bounds
	var proposal = spawnpoint + Vector2(x,y)
	var bound_proposal = proposal.clamp(Vector2(100,100), Vector2(world_width, world_height))
	return bound_proposal

func spawn(spawn_center : Vector2 = Vector2(300,300)):
	if spawnable:
		var spawn_position = random_in_radius(spawn_center)
		var child_spawn = spawnable.instantiate()
		child_spawn.set_global_position(spawn_position)
		child_spawn.add_to_group("lifeform")
		child_spawn.add_to_group(Constants.Species.keys()[species])
		return child_spawn
	
