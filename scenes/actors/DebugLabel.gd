extends Label


@export var pawn : Animal

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if pawn:
        self.set_text(str(pawn.velocity.round()))
    else:
        self.set_text("(0,0)")


