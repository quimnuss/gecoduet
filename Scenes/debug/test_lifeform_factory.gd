extends Node2D

@onready var spawner = $EcoSpawner

func _ready():
	pass

func _process(delta):
	var switch_species = Input.get("ui_next_species")
	if switch_species:
		spawner.species = (spawner.species + 1)%Constants.Species.size()
		prints("Switched to",Constants.species_name(spawner.species))
