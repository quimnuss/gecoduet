extends Control

var emoji_to_species : Dictionary = {
	'🐺': Constants.Species.BEAR,
	'🐇': Constants.Species.RABBIT,
	'🥕': Constants.Species.CARROT,
	'🐦': Constants.Species.BIRD,
	'🐝': Constants.Species.BOAR,
	'🦊': Constants.Species.FOX,
	'🐛': Constants.Species.DEER,
	'🐟': Constants.Species.FISH,
	'🌱': Constants.Species.TREE,
	'🍒': Constants.Species.BERRY
}

signal create_species(lifeform : Constants.Species)

func _on_species_name_button_pressed(species_name : String):
	var species = Constants.Species.get(species_name.to_upper())
	if species != null:
		create_species.emit(species)
	else:
		prints("species",species_name.to_upper(),"unknown. Species:",Constants.Species.keys())
