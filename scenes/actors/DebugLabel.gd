extends Label


@export var pawn : Animal

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

var foo : Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var debug_text = ""
    if pawn:
        debug_text += str(pawn.velocity.round())
        if pawn.movement and pawn.movement.target_lifeform and is_instance_valid(pawn.movement.target_lifeform):
            debug_text += "\n" + str(int(pawn.global_position.distance_to(pawn.movement.target_lifeform.global_position)))


    self.set_text(debug_text)


