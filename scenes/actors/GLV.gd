extends Node2D

class_name GLV

@export var mutuality : Dictionary #<String,float>
# should this be a component as well?
@export var density : float = 1.5

# how slow are step changes. (the dt size of the differential equation)
@export var time_stretch : float = 10.0

var display_name : String = 'NONE'
# dictionary species-float with the species debt
var mutuality_drivers : Dictionary

signal density_change
signal density_number_change

# major negative and positive drivers
var major_driver = [null,0,null,0]

@export var my_species : Constants.Species = Constants.Species.NONE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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

		mutuality_drivers[species] = mutuality_drivers.get(species,0) + delta_d

		total_delta_d += delta_d

	new_density = previous_density + total_delta_d
	if new_density < 0.02:
		new_density = 0
	elif new_density > 100:
		new_density = 100

# replacing instant set density with natural deferred set density
#	self.set_density(new_density)
	set_density_natural(previous_density, new_density, mutuality_drivers)

	return new_density # is it confusing to change internal state but also return?

func set_density(density : float):
	var previous_density = self.density
	self.density = density

	if abs(density - previous_density) > 0.0001:
		density_change.emit(density)

	var density_number_variation : int = ceil(density) - ceil(previous_density)
	if abs(density_number_variation) > 0:
		density_number_change.emit(density_number_variation)

# TODO returns the integer ceil +/- drivers and adjusts the mutuality_drivers debt bag accordingly
func _get_integer_drivers(mutuality_drivers):
	var drivers = {}
	for species in mutuality_drivers:
		var mutual : float = mutuality_drivers[species] 
		var delta_number : int = ceil(mutual)
		drivers[species] = delta_number
		mutuality_drivers[species] -= delta_number
	
	return drivers

func _order_kill(my_species, driver, num_kills):
	var killer_candidates = get_tree().get_nodes_in_group(driver)
	var prey_candidates = get_tree().get_nodes_in_group(Constants.species_name(my_species))

	for kill in num_kills:
		var killer = killer_candidates.pick_random()
		var prey = prey_candidates.pick_random()
		prey_candidates.erase(prey)
		
		prey.set_hunted(killer)
		killer.hunt(prey)

func set_density_natural(previous_density : float, density : float, current_mutuality_drivers):
	self.density = density

#	if abs(density - previous_density) > 0.0001:
#		density_change.emit(density)
	
	var density_number_variation : int = ceil(density) - ceil(previous_density)
	prints(self.display_name,"pre-settling mutuality_drivers is",current_mutuality_drivers)
	var drivers = _get_integer_drivers(current_mutuality_drivers)
	prints(self.display_name,"with density",previous_density,density,"has drivers",drivers,"remainder of",current_mutuality_drivers)
	for driver in drivers:
		var delta_pop : int = drivers[driver]
		if delta_pop > 0:
			match driver:
				"none":
					density_number_change.emit(delta_pop)
				_: # simbiosis (also self)
					# TODO feedback user another species helped
					density_number_change.emit(delta_pop)
		elif delta_pop < 0:
			match driver:
				"none": # natural death rate
					density_number_change.emit(delta_pop)
				_:
#					density_number_change.emit(delta_pop)
					_order_kill(my_species, driver, -delta_pop)
				
	# TODO we should guarantee sync, otherwise drivers might take to long to kill on their own
	# e.g. 10 drivers of -0.1  get one kill but seperatelly would take 10 iterations and would instantly kill 10
	# to do this the major decimal driver should get one extra kill/birth
	#density_number_change.emit(density_number_variation)


