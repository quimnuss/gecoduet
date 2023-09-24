extends StaticBody2D

class_name Flora

@export var resource : LifeformAnimalResource = preload("res://data/lifeform_carrot.tres")

@onready var sprite = $Sprite2D

var is_selectable : bool = true

var species : Constants.Species = Constants.Species.NONE

func _ready():
	sprite.set_texture(resource.texture)
	sprite.hframes = resource.texture_shape[0]
	sprite.vframes = resource.texture_shape[1]
	sprite.set_frame_coords(resource.texture_coords)
	self.name = resource.name
	self.set_scale(Vector2(resource.scale,resource.scale))
	self.sprite.set_scale(Vector2(resource.scale,resource.scale))

	self.species = resource.species
	var species_name = Constants.species_name(self.species)
	add_to_group(species_name)

func kill():
	self.set_scale(self.get_scale()*0.3)
	await get_tree().create_timer(2).timeout
	queue_free()

func set_hunted(predator):
	await get_tree().create_timer(3).timeout
	kill()

func hunt(prey):
	pass

func _input(event):
	if event.is_action_pressed("ui_debug_action"):
#		var move_mode = ["chase_prey","chase_leader","avoid_predator"].pick_random()
#		prints("switching to",move_mode)
#		movement.move_mode = move_mode
#		state_machine.set_trigger("die")
		kill()
