extends Node2D

var elders : Array[SpeciesElder] = []
var density_map : Dictionary = {}

var species_elder_scene = preload("res://scenes/actors/species_elder.tscn")

@onready var glv_timer = $DensitySyncTimer

@export var sample_elders : Array[SpeciesElder]

signal elder_registered

# Called when the node enters the scene tree for the first time.
func _ready():
    # editor instanced elder
    for sample_elder in sample_elders:
        register_species(sample_elder)

func register_species(elder):
    # add a species to the manager (here) and register it to the UI
    # probably the easier is to have a filtrable UI with alive/extinct species
    elders.append(elder)

func fetch_density():
    for elder in elders:
        density_map[Constants.species_name(elder.species)] = elder.get_density()

func _on_density_sync_timer_timeout():
    fetch_density()
    var elders_to_remove = []
    for elder in elders:
        var current_density = elder.glv.lotka(self.density_map)
        var is_extinct = elder.check_extinction(current_density)
        if is_extinct:
            elders_to_remove.append(elder)
            density_map[Constants.species_name(elder.species)] = 0
    for elder in elders_to_remove:
        elders.erase(elder)
    fetch_density() # one of the sync_densities might be unnecessary if only this function changes densities
    prints("Density map",self.density_map)

func create_species(species : Constants.Species):
    # TODO does not work. sample_elders can't be sleeping node... I have to figure out how to defer initialization...
    for living_elder in elders:
        if species == living_elder.species:
            prints("Species",Constants.species_name(species),"already living")
            living_elder.increase_density(1)
            return null
    var new_elder = species_elder_scene.instantiate()
    new_elder.name = Constants.species_name(species)
    new_elder.species = species
    elders.append(new_elder)
    new_elder.elder_extinct.connect(_on_elder_extinct)
    add_child(new_elder)
    return new_elder

func _on_elder_extinct(elder : SpeciesElder):
    prints(elder,"is extinct")
    elders.erase(elder)


func _on_hud_create_species(species):
    create_species(species)
