extends Label


@export var pawn : Flora

var predator

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_predator(new_predator):
	self.predator = new_predator

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var debug_text = ""
	if pawn:
		debug_text += str(pawn.name)
		if predator:
			debug_text += "\n" + predator.name
			debug_text += "\n" + str(int(pawn.global_position.distance_to(pawn.movement.target_lifeform.global_position)))


	self.set_text(debug_text)


