extends Sprite2D

@export var is_negative : bool = false

@export var red_modulate : Color = Color(1,0,1)

@export var species : Constants.Species = Constants.Species.RABBIT:
    set(new_species):
        species = new_species
        self.set_frame(species)
        _set_frame_from_species(species)

# Called when the node enters the scene tree for the first time.

func _init():
    if is_negative:
        self.set_modulate(red_modulate)

    self.frame = species

func _ready():
    if is_negative:
        self.set_modulate(red_modulate)

#    _set_frame_from_species(species)

func _set_frame_from_species(species : Constants.Species):
    self.set_frame_coords(Vector2i(0,species-1))
