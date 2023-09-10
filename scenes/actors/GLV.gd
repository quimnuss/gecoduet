extends Node2D

class_name GLV

@export var mutuality : Dictionary #<String,float>
# should this be a component as well?
@export var density : float = 1.5

# how slow are step changes. (the dt size of the differential equation)
@export var time_stretch : float = 10.0

var display_name : String = 'GLV'

signal density_change
signal density_number_change

# major negative and positive drivers
var major_driver = [null,0,null,0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func lotka(densities : Dictionary):
	var total_delta_d = 0
	var previous_density = self.density
	var new_density

	major_driver = [null,0,null,0]

	for species in mutuality:
		var mutual = mutuality[species]/time_stretch
		var delta_d = 0
		if species == "none":
			delta_d = previous_density*mutual
		else:
			var d_other = densities.get(species, 0)
			delta_d = mutual*d_other*previous_density

		if delta_d < major_driver[1]:
			major_driver[0] = species
			major_driver[1] = delta_d
		if delta_d > major_driver[3]:
			major_driver[2] = species
			major_driver[3] = delta_d

		total_delta_d += delta_d
	prints(self.display_name,"major driver",major_driver)
	new_density = previous_density + total_delta_d
	if new_density < 0.02:
		new_density = 0
	elif new_density > 100:
		new_density = 100
	
	self.set_density(new_density)
	
	return new_density # is it confusing to change internal state but also return?

func set_density(density : float):
	var previous_density = self.density
	self.density = density
	
	if abs(density - previous_density) > 0.0001:
		density_change.emit(density)
	
	if abs(int(previous_density) - int(density)) > 1:
		density_number_change.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
