#@tool

extends Node2D

class_name EcoSpawner

@export var base_animal : PackedScene = preload("res://scenes/actors/lifeform_animal.tscn")
@export var base_flora : PackedScene  = preload("res://scenes/actors/lifeform_static.tscn")

@export var navigable_zone : NavigationAgent2D

@export var species : Constants.Species = Constants.Species.BEAR
	
var world_width : int = 1000
var world_height : int = 600

const DEFAULT_DEBUG_TIMER : float = 1
var debug_timer : float = DEFAULT_DEBUG_TIMER

const DEFAULT_SPAWN_CENTER : Vector2 = Vector2(200,200)

var viewport_size : Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height"))

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello")
	$Marker.set_position(DEFAULT_SPAWN_CENTER)


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

func _process(delta):
	debug_timer -= delta

	if Engine.is_editor_hint():
		if debug_timer < 0:
			debug_timer = DEFAULT_DEBUG_TIMER
			prints("spawn")
			spawn()
			prints(Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height")))

		var children : Array[Node] = self.get_children()
		if children.size() > 10:
			prints("delete one of",children.size(),"children")
			var child = children.pick_random()
			if child.name != "Marker":
				child.queue_free()
			else:
				prints("Selected marker, skipping.")

func polar2cartesian(r,alpha:float):
	var x = r * cos(alpha)
	var y = r * sin(alpha)
	return Vector2(x,y)

func random_in_radius(spawnpoint : Vector2, radius = 200):
	var r = randi_range(10, radius)
	var alpha = randf_range(0,2*PI)
	# TODO check is target reachable or in bounds
	var proposal = spawnpoint + polar2cartesian(r,alpha)
	var bound_proposal = proposal.clamp(Vector2(100,100), viewport_size)
	return bound_proposal


func spawn(spawn_center : Vector2 = DEFAULT_SPAWN_CENTER):
	prints("triggered spawn",self.species,"around",spawn_center)
	var spawn_position = random_in_radius(spawn_center, 200)
	# The scene path could also be in the resource, no need for the factory after all...
	var child_spawn = _spawn_from_resource(self.species)
	add_child(child_spawn)
	prints(spawn_position)
	child_spawn.set_position(spawn_position)
	child_spawn.add_to_group("lifeform")
	child_spawn.add_to_group(Constants.Species.keys()[species])
	return child_spawn

func _spawn_from_resource(species: Constants.Species) -> Node:
	var species_name : String = Constants.species_name(species)
	var lifeform_resource = load("res://data/lifeform_"+species_name+".tres")
	match lifeform_resource.lifeform_type:
		"flora" :
			return _set_from_flora_resource(lifeform_resource)
		"animal" :
			return _set_from_animal_resource(lifeform_resource)
		_:
			prints("Lifeform type",lifeform_resource.type,"unknown to creation factory")
			return null

func _set_from_animal_resource(animal_resource):
	var frames : SpriteFrames = animal_resource.animation_frames
	var new_animal = base_animal.instantiate()
	new_animal.resource = animal_resource
	return new_animal

func _set_from_flora_resource(flora_resource):
	var new_flora = base_flora.instantiate()
	new_flora.sprite2d = flora_resource.sprite
	new_flora.name = flora_resource.name
	new_flora.set_scale(Vector2(flora_resource.scale,flora_resource.scale))
	return new_flora
