extends Node2D

var res_rabbit = preload("res://data/animal_rabbit.tres")
var res_bear = preload("res://data/animal_bear.tres")

var res_mutuality = preload("res://data/elder_glv.tres")

var res_elder = preload("res://scenes/actors/elder.tscn")

var totem = preload("res://scenes/actors/elder_totem.tscn")

var elders = []
var density_map : Dictionary = {}

@onready var glv_timer = $Timer

@export var sample_elders : Array[Elder]

signal elder_registered

# Called when the node enters the scene tree for the first time.
func _ready():
	# editor instanced elder
#	for sample_elder in sample_elders:
#		register_species(sample_elder)
	pass

func register_species(elder):
	# add a species to the manager (here) and register it to the UI
	# probably the easier is to have a filtrable UI with alive/extinct species
	pass

func sync_density():
	for elder in elders:
		density_map[elder.name] = elder.density

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	sync_density()
	var elders_to_remove = []
	for elder in elders:
		var current_density = elder.lotka(self.density_map)
		var is_extinct = elder.check_extinction(current_density)
		if is_extinct:
			elders_to_remove.append(elder)
			density_map[elder.name] = 0
	for elder in elders_to_remove:
		elders.erase(elder)
	sync_density() # one of the sync_densities might be unnecessary if only this function changes densities
	prints("Density map",self.density_map)
