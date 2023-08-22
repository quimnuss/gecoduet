extends Node2D

@export var lifeforms : Array[Node2D]

@onready var spawner : EcoSpawner = $Spawner

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func choose_breeder() -> Node2D:
	return lifeforms.pick_random()

func _on_density_integer_increased(num_births : int):
	var breeder = choose_breeder()
	if not breeder:
		prints("no lifeforms for breeding",self.name)
	while num_births > 0:
		num_births -= 1
		var lifeform = spawner.spawn(breeder.get_global_position())
		lifeforms.append(lifeform)
	
	
