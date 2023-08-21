extends Node2D
class_name Elder

@export var elder_resource: Resource
@export var animal_resource: Resource

@onready var me = $Animal
@onready var name_label = $Animal/NameLabel
var animal_child = preload("res://scenes/animals/eco_animal_bear.tscn")
@export var mutuality : Dictionary #<String,float>

var density : float = 0.3
var animal_children = []

var major_driver = [null,0,null,0]

signal extinct


# Called when the node enters the scene tree for the first time.
func _ready():
	me.animal_resource = self.animal_resource
	me.set_from_resource()
#    me.animation.set_sprite_frames(self.animal_resource.animation_frames)
	self.name = self.animal_resource.name
	me.apply_scale(Vector2(1.4,1.4))

	name_label.set_text(self.name)
	me.speed = 45
	# GLV
	birth_children(int(density))

func lotka(densities : Dictionary):
	var total_delta_d = 0

	major_driver = [null,0,null,0]

	for species in mutuality:
		var mutual = mutuality[species]
		var delta_d = 0
		if species == "none":
			delta_d = self.density*mutual
		else:
			var d_other = densities.get(species, 0)
			delta_d = mutual*d_other*self.density

		if delta_d < major_driver[1]:
			major_driver[0] = species
			major_driver[1] = delta_d
		if delta_d > major_driver[3]:
			major_driver[2] = species
			major_driver[3] = delta_d

		total_delta_d += delta_d
	prints(self.name,"major driver",major_driver)
	density += total_delta_d
	if density < 0.02:
		density = 0
	elif density > 100:
		density = 100
	return density # is it confusing to change internal state but also return?

func kill_elder():
	me.kill()
	$ChildrenSync.stop()
	await get_tree().create_timer(2).timeout
	queue_free()

func check_extinction(density: float) -> bool:
	if density < 0.01:
		prints("elder",self.name,"went extinct with density",density)
		for child in animal_children:
			child.kill()
		kill_elder()
		return true
	return false

func kill_children(num_children: int):
	var num_children_to_kill = min(num_children,len(animal_children))
	while num_children_to_kill > 0:
		num_children_to_kill -= 1
		var child = animal_children.pop_back()
		prints("Kill",child)
		child.kill()
		remove_child(child)

func birth_children(num_children: int):
	num_children = min(10,num_children)
	for i in range(num_children):
		var new_child = animal_child.instantiate()
		new_child.animal_resource = self.animal_resource
		new_child.position = me.position
		animal_children.append(new_child)
		add_child(new_child)

func sync_children_to_density():
	var delta_children : int = ceil(self.density) - len(animal_children)
	if delta_children < 0:
		kill_children(-delta_children)
	elif delta_children > 0:
		birth_children(delta_children)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_children_sync_timeout():
	sync_children_to_density()


func _on_renamed():
	prints("renamed",self.name)
	name_label.set_text(self.name)


func _on_animal_tree_exiting():
	self.queue_free()
