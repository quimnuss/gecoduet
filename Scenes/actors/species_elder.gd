extends Node2D

@export var lifeforms : Array[Node2D]

@onready var spawner : EcoSpawner = $EcoSpawner

func _init():
	pass
		

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var main_scene = ProjectSettings.get_setting("application/run/main_scene")
	var current_scene = get_tree().current_scene.scene_file_path
	if main_scene == current_scene:
		pass
	else: # not main scene
		var carrot_scene = load("res://scenes/actors/lifeform_static.tscn")
		spawner.spawnable = carrot_scene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func choose_breeder() -> Node2D:
	return lifeforms.pick_random()

func _on_density_integer_increased(num_births : int):
	var breeder = choose_breeder()
	prints("spawning",num_births)
	while num_births > 0:
		num_births -= 1
		var lifeform
		if not breeder:
			prints("no lifeforms for breeding",self.name)
			lifeform = spawner.spawn()
		else:
			lifeform = spawner.spawn(breeder.get_global_position())
		lifeforms.append(lifeform)
	
	
