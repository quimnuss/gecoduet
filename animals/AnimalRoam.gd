extends NavigationAgent2D

@onready var pawn = $Animal
@onready var region = $NavigationRegion2D

# Called when the node enters the scene tree for the first time.
func _ready():
    self.set_target_position(Vector2(128,40))
    pass # Replace with function body.

func polar2cartesian(travel_radius,angle):
    return Vector2(travel_radius*sin(angle), travel_radius*cos(angle))

func getRandomReachablePoint(travel_radius: int):
    var angle = randf_range(0, 2*PI)
    var distance = randi_range(100,travel_radius)
    var ideal_position = self.get_parent().position + polar2cartesian(distance, angle)

    if ideal_position.y < 0:
        ideal_position.y = -ideal_position.y
    if ideal_position.x < 0:
        ideal_position.x = -ideal_position.x

    return ideal_position

var state = "idle"
var elapsed = 2

var debug_target = Vector2(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    match state:
        "idle":
            elapsed += delta
            if elapsed > 3:
                self.set_target_position(getRandomReachablePoint(300))
#                elapsed = 0
                state = "roaming"

func stop():
    print("Reached!")
    state = "idle"
    elapsed = 0
    self.get_parent().velocity = Vector2(0,0)

func _on_target_reached():
    pass

func _on_waypoint_reached(details):
    print(details)


func _on_navigation_finished():
    stop()
