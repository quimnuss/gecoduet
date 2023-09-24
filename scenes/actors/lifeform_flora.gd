extends StaticBody2D

class_name Flora

@export var resource : LifeformAnimalResource = preload("res://data/lifeform_carrot.tres")

@onready var sprite = $Sprite2D

var is_selectable : bool = true

var species : Constants.Species = Constants.Species.NONE

signal dying

const WAIT_FOR_KILLER_TIMEOUT = 5

func _ready():
	sprite.set_texture(resource.texture)
	sprite.hframes = resource.texture_shape[0]
	sprite.vframes = resource.texture_shape[1]
	sprite.set_frame_coords(resource.texture_coords)
	self.name = resource.name
	self.set_scale(Vector2(resource.scale,resource.scale))
	self.sprite.set_scale(Vector2(resource.scale,resource.scale))

	self.species = resource.species
	assert(self.species != Constants.Species.NONE)
	var species_name = Constants.species_name(self.species)
	add_to_group(species_name)
	
	GlobalSettings.globals_changed.connect(_update_global_settings)
	_update_global_settings()

func kill():
	self.set_scale(self.get_scale()*0.3)
	var species_name = Constants.species_name(self.species)
	self.remove_from_group(species_name)
	dying.emit()
	# let the death animation play
	await get_tree().create_timer(2).timeout
	queue_free()

func set_hunted(predator):
	set_status_effect(Constants.StatusEffect.DYING, true)
	if $DebugLabelFlora:
		$DebugLabelFlora.add_predator(predator.name)
	await get_tree().create_timer(WAIT_FOR_KILLER_TIMEOUT).timeout
	if predator != null:
		prints(self.name, "distance to predator before dying:",self.global_position.distance_to(predator.global_position))
	kill()

func hunt(prey):
	set_status_effect(Constants.StatusEffect.CHASE_PREY, true)
	prey.connect("dying", end_hunt)

func end_hunt(prey):
	set_status_effect(Constants.StatusEffect.CHASE_PREY, false)

func _input(event):
	if event.is_action_pressed("ui_debug_action"):
#		var move_mode = ["chase_prey","chase_leader","avoid_predator"].pick_random()
#		prints("switching to",move_mode)
#		movement.move_mode = move_mode
#		state_machine.set_trigger("die")
		kill()

func _update_global_settings():
	if $DebugLabel:
		$DebugLabel.visible = GlobalSettings.debug_show_label

func set_status_effect(status : Constants.StatusEffect, visible = true):
	match status:
		Constants.StatusEffect.CHASE_PREY:
			$StatusBar/Hunting.set_visible(visible)
		Constants.StatusEffect.DYING:
			$StatusBar/Dying.set_visible(visible)
