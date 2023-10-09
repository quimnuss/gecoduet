extends Node

@export var predators : Array[Animal]
@export var preys : Array[Animal]

var guard = 0

func _ready():
    pass

func _process(delta):
    if guard > 0:
        guard -= delta
    var debug_pressed = Input.is_action_pressed("ui_debug")
    if debug_pressed and guard <= 0:
        guard = 3
        var predator = predators.pick_random()
        var prey = preys.pick_random()
        if not prey:
            prints(prey,"is no prey!!",preys)
            return
        predator.set_target_lifeform(prey)
        predator.state_machine.send_event('chase')

        prints(predator.name,"switching to chase")

