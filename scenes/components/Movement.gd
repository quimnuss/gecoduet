extends Node2D

@export var pawn : CharacterBody2D
@export var nav : NavigationAgent2D

var elapsed = 2

var movement_delta : float = 0

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

func stop():
	pawn.velocity = Vector2.ZERO # when last target is out of bounds this does not work for some reason
	elapsed = 0

func velocity_to_nav_target():
	var agent_position : Vector2 = pawn.global_position
	var target = nav.get_next_path_position()
	var distance = (target - agent_position)
	var distance_to_end = (nav.get_final_position() - agent_position)
	var speed = pawn.speed
	# also nav.distance_to_target()
	# todo fix spinning
	if distance_to_end.length() < 20:
		speed = pawn.speed/5
	var velocity = distance.normalized() * speed
	# TODO figure out how to get avoidance working correctly
	if false and nav.avoidance_enabled:
		nav.set_velocity(velocity)
	else:
		pawn.velocity = velocity
	
	#pawn.velocity = velocity
	if pawn.debug:
		prints(pawn.name, pawn.global_position, pawn.position, agent_position, "->", target, pawn.velocity)
	return pawn.velocity

# todo state-machine elapsed
func _on_state_machine_player_updated(state, delta):
	movement_delta = pawn.speed * delta
	match state:
		"seek_move", "idle":
			pawn.velocity = Vector2.ZERO # this should not be necessary but for some reason it is
			elapsed += delta
			if elapsed > 3:
				elapsed = 0
				for tries in 10:
					var target = get_random_point(50)
					nav.set_target_position(target)
					if nav.is_target_reachable():
						if pawn.debug:
							prints(target,"is reachable.")
						velocity_to_nav_target()
						break
		"run":
			if nav.is_target_reachable() and not (nav.distance_to_target() < 15):
				velocity_to_nav_target()
			elif not nav.is_target_reachable():
				if pawn.debug:
					print(nav.get_final_position(), " is unreachable. Next pos ", nav.get_next_path_position())
				self.stop()
			else:
				self.stop()
		_:
			self.stop()

func _on_navigation_finished():
	self.stop()

func _on_state_machine_player_transited(from, to):
	match from:
		"idle":
			pass
		"run":
			match to:
				"idle":
					pass


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
#	pawn.global_position = pawn.global_position.move_toward(pawn.global_position + safe_velocity, movement_delta)
	print(safe_velocity)
	pawn.velocity = safe_velocity
	if pawn.debug:
		prints(pawn.name, pawn.global_position, pawn.position, pawn.global_position, "->", nav.get_next_path_position(), pawn.velocity)
	pawn.move_and_slide()
	return 

