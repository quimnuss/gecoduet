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

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _on_species_name_button_pressed(name : String):
    var species = Constants.Species.get(name.to_upper())
    if species != null:
        create_species.emit(species)
    else:
        prints("species",name.to_upper(),"unknown. Species:",Constants.Species.keys())
