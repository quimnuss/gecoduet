extends RefCounted

class_name LifeformFactory

var res_mutuality = preload("res://data/elder_glv.tres")
@export var base_animal : PackedScene = preload("res://scenes/actors/lifeform_animal.tscn")
@export var base_flora : PackedScene  = preload("res://scenes/actors/lifeform_flora.tscn")

func spawn(species: Constants.Species) -> Node:
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

