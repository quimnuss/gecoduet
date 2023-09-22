extends Node

@export var predators : Array[Animal]
@export var preys : Array[Animal]

var guard = 0

func _ready():
    for prey in preys:
        prey.movement.move_mode = "avoid_predator"


func _process(delta):
    if guard > 0:
        guard -= delta
    var debug_pressed = Input.is_action_pressed("ui_debug")
    if debug_pressed and guard <= 0:
        guard = 3
        var predator = predators.pick_random()
        var prey = preys.pick_random()
        if not prey:
            prints("no prey!!")
            return
        predator.set_highlight(true,true)
        predator.movement.set_move_mode(Constants.MoveMode.CHASE_PREY, prey)
        prey.movement.set_move_mode(Constants.MoveMode.AVOID_PREDATOR, predator)


        prints(predator.name,"switching to",Constants.move_mode_name(predator.movement.move_mode))

