extends StaticBody2D

@onready var totem_sprite = $Sprite2D

var species : Constants.Species = Constants.Species.CARROT

# Called when the node enters the scene tree for the first time.
func _ready():
	totem_sprite.set_frame(species)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
