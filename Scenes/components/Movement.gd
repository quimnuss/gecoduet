extends Node2D

@export var pawn : CharacterBody2D
@export var nav : NavigationAgent2D

var elapsed = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func polar2cartesian(travel_radius, angle):
	return Vector2(travel_radius*sin(angle), travel_radius*cos(angle))

func get_random_point(travel_radius: int):
	var angle = randf_range(0, 2*PI)
	var distance = randi_range(100,travel_radius)
	var ideal_position = pawn.global_position + polar2cartesian(distance, angle)

	if ideal_position.y < 0:
		ideal_position.y = -ideal_position.y
	if ideal_position.x < 0:
		ideal_position.x = -ideal_position.x

	return ideal_position

func _on_state_machine_player_updated(state, delta):
	match state:
		"idle":
			pawn.velocity = Vector2.ZERO # this should not be necessary but for some reason it is
			elapsed += delta
			if elapsed > 3:
				for tries in 10:
					nav.set_target_position(get_random_point(200))
					if nav.is_target_reachable():
						break
				elapsed = 0
				state = "roaming"
		"run/Entry":
			if nav.is_target_reachable() and not nav.is_target_reached():
				var agent_position : Vector2 = pawn.global_position
				var target = nav.get_next_path_position()
				pawn.velocity = (target - agent_position).normalized() * pawn.speed
				if pawn.debug:
					prints(pawn.name, pawn.global_position, pawn.position, agent_position, "->", target, pawn.velocity)
			elif not nav.is_target_reachable():
				print(nav.get_final_position(), " is unreachable. Next pos ", nav.get_next_path_position())
				nav.stop()
			else:
				nav.stop()

