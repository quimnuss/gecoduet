extends Node2D

var res_rabbit = preload("res://data/animal_rabbit.tres")
var res_bear = preload("res://data/animal_bear.tres")

var res_mutuality = preload("res://data/elder_glv.tres")

var res_elder = preload("res://actors/elder.tscn")
var elders = []
var density_map : Dictionary = {}

@onready var glv_timer = $Timer
#@onready var sample_elder = $sample_elder

# Called when the node enters the scene tree for the first time.
func _ready():
    # editor instanced elder
#    add_elder(sample_elder)

    # script instanced elder
    spawn_elder("carrot")
    spawn_elder("bear")
    spawn_elder("rabbit")

func spawn_elder(elder_name : String, spawn_position : Vector2 = Vector2.ZERO):

    var elder = res_elder.instantiate()
    elder.animal_resource = load("res://data/animal_"+elder_name+".tres")
    elder.mutuality = res_mutuality.get_data()[elder_name]
    add_elder(elder)
    return elder

func add_elder(elder):
    elders.append(elder)
    add_child(elder) # calls _ready
    density_map[elder.name] = elder.density

func sync_density():
    for elder in elders:
        density_map[elder.name] = elder.density

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_timer_timeout():
    sync_density()
    var elders_to_remove = []
    for elder in elders:
        var current_density = elder.lotka(self.density_map)
        var is_extinct = elder.check_extinction(current_density)
        if is_extinct:
            elders_to_remove.append(elder)
            density_map[elder.name] = 0
    for elder in elders_to_remove:
        elders.erase(elder)
    sync_density() # one of the sync_densities might be unnecessary if only this function changes densities
    prints("Density map",self.density_map)
