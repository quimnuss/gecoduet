extends Node2D

@onready var spawner = $EcoSpawner

func _ready():
	spawner.species = Constants.Species.RABBIT
	$Marker.set_global_position(spawner.DEFAULT_SPAWN_CENTER)

func _process(delta):
	var switch_species = Input.get("ui_next_species")
	if switch_species:
		spawner.species = (spawner.species + 1)%Constants.Species.size()
		prints("Switched to",Constants.species_name(spawner.species))
