extends Node2D

class_name SpeciesElder

@export var species : Constants.Species = Constants.Species.CARROT
var res_mutuality = preload("res://data/glv.json")

@onready var spawner : EcoSpawner = $EcoSpawner
@onready var glv : GLV = $GLV

signal elder_extinct(elder : SpeciesElder)

func _init():
	pass
		

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var main_scene = ProjectSettings.get_setting("application/run/main_scene")
	var current_scene = get_tree().current_scene.scene_file_path
	if main_scene == current_scene:
		spawner.species = self.species
	else: # not main scene
		spawner.species = self.species
	prints(res_mutuality.get_data())
	var species_name = Constants.species_name(self.species)
	glv.mutuality = res_mutuality.get_data()[species_name]
	glv.display_name = species_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_density() -> float:
	return glv.density
	
func set_density(density : float):
	glv.set_density(density)
	
func increase_density(delta_density : float):
	self.set_density(get_density() + delta_density)

func kill_elder():
	$ChildrenSync.stop()
	await get_tree().create_timer(2).timeout
	queue_free()

func check_extinction(density: float) -> bool:
	if density < 0.1:
		prints("elder",self.name,"went extinct with density",density)
		spawner.kill_all_children()
		kill_elder()
		elder_extinct.emit(self)
		return true
	return false

func _on_density_integer_increased(num_births : int):
	prints("spawning",num_births)
	while num_births > 0:
		num_births -= 1
		spawner.spawn()


	
	
