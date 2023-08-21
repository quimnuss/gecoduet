extends Node2D

@export var mutuality : Dictionary #<String,float>
# should this be a component as well?
@export var density : float

signal density_change
signal density_number_change

var major_driver = [null,0,null,0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func lotka(densities : Dictionary):
	var total_delta_d = 0

	major_driver = [null,0,null,0]

	for species in mutuality:
		var mutual = mutuality[species]
		var delta_d = 0
		if species == "none":
			delta_d = self.density*mutual
		else:
			var d_other = densities.get(species, 0)
			delta_d = mutual*d_other*self.density

		if delta_d < major_driver[1]:
			major_driver[0] = species
			major_driver[1] = delta_d
		if delta_d > major_driver[3]:
			major_driver[2] = species
			major_driver[3] = delta_d

		total_delta_d += delta_d
	prints(self.name,"major driver",major_driver)
	density += total_delta_d
	if density < 0.02:
		density = 0
	elif density > 100:
		density = 100
	return density # is it confusing to change internal state but also return?



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
