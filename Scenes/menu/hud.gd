extends Control

var emoji_to_species : Dictionary = {
	'🐺': Constants.Species.BEAR,
	'🐇': Constants.Species.RABBIT,
	'🥕': Constants.Species.CARROT,
	'🦊': Constants.Species.TREE,
	'🐦': Constants.Species.TREE,
	'🐝': Constants.Species.TREE,
	'🐛': Constants.Species.TREE,
	'🐟': Constants.Species.TREE,
	'🌱': Constants.Species.TREE,
	'🍒': Constants.Species.TREE
}

signal create_species(lifeform : Constants.Species)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_species_button_pressed(caller: Button):
	prints("pressed",caller)
	var species_emoji = caller.get_text()
	var species = emoji_to_species[species_emoji]
	create_species.emit(species)

func _on_species_name_button_pressed(name : String):
	var species = Constants.Species.get(name.to_upper())
	if species:
		create_species.emit(species)
	else:
		prints("species",name,"unknown. Species:",Constants.Species.keys())
	
