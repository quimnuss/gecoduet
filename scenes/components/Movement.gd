extends Node2D

@export var pawn : CharacterBody2D
@export var nav : NavigationAgent2D

var tired_timer = 2

var movement_delta : float = 0

var move_mode : Constants.MoveMode = Constants.MoveMode.DEFAULT

var target_lifeform : Node2D = null

@export var state_machine : StateChart

var world_size : Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height"))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the tired_timer time since the previous frame.
func _process(delta):
	pass

func polar2cartesian(travel_radius, angle):
	return Vector2(travel_radius*sin(angle), travel_radius*cos(angle))

func set_move_mode(new_move_mode : Constants.MoveMode, target_lifeform : Node2D):
	self.target_lifeform = target_lifeform
	prints(pawn.name,"switched to", Constants.move_mode_name(new_move_mode))
	self.move_mode = new_move_mode
	match self.move_mode:
		Constants.MoveMode.CHASE_PREY:
			self.target_lifeform.set_highlight(true)
		_:
			self.target_lifeform.set_highlight(false)

func bound_to_world(point : Vector2):
	
	var margin = 10
		
	if point.x < margin:
		point.x = -point.x
	elif point.x > world_size.x - margin:
		point.x = 2*(world_size.x - margin) - point.x
	
	if point.y < margin:
		point.y = -point.y
	elif point.y > world_size.y - margin:
		point.y = 2*(world_size.y - margin) - point.y
	return point


func get_random_point(travel_radius: int):
	var angle = randf_range(0, 2*PI)
	var distance = randi_range(100, travel_radius)
	var ideal_position = pawn.global_position + polar2cartesian(distance, angle)

	ideal_position = bound_to_world(ideal_position)

	return ideal_position

func follow_leader():
	pass

func avoid_predator():
	pass

func chase_prey():
	pass

func stop():
	pawn.velocity = Vector2.ZERO # when last target is out of bounds this does not work for some reason
	tired_timer = 0

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

func nav_target_selector() -> Vector2:
	var target = get_random_point(200)	
	match move_mode:
		Constants.MoveMode.CHASE_PREY:
			target = target_lifeform.global_position
			pass
		Constants.MoveMode.CHASE_LEADER:
			pass
		Constants.MoveMode.AVOID_PREDATOR:
			pass
	return target

func _on_navigation_finished():
	state_machine.send_event("target_reached")
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

func _on_seek_target_state_entered():
	var target
	for try in range(10):
		target = nav_target_selector()	

		nav.set_target_position(target)
		if nav.is_target_reachable():
			if pawn.debug:
				prints(target,"is reachable.")
			state_machine.send_event("has_target")
			return
	prints(target,"is unreachable",pawn.global_position - target)
	state_machine.send_event("cancel_seek")

func _set_velocity_given_move_mode():
	match move_mode:
		Constants.MoveMode.CHASE_PREY:
			var target = target_lifeform.global_position
			nav.set_target_position(target)
			if(nav.distance_to_target() < 5):
				state_machine.send_event("target_reached")
			else:
				velocity_to_nav_target()
		Constants.MoveMode.AVOID_PREDATOR:
			var predator_position = target_lifeform.global_position
			var predator_distance = (predator_position - self.global_position)
			var away_direction = predator_distance.normalized()
			var away_angle = randf_range(0,0.2) if predator_distance.length() > 30 else 0.5*PI
			var opposite = self.global_position - away_direction.rotated(away_angle*PI)*100
			nav.set_target_position(opposite)
			if(nav.distance_to_target() < 5):
				state_machine.send_event("target_reached")
			else:
				velocity_to_nav_target()
		Constants.MoveMode.DEFAULT,_:
			if nav.is_target_reachable() and not (nav.distance_to_target() < 15):
				velocity_to_nav_target()
			elif not nav.is_target_reachable():
				if pawn.debug:
					print(nav.get_final_position(), " is unreachable. Next pos ", nav.get_next_path_position())
				state_machine.send_event("target_reached")
			else:
				state_machine.send_event("target_reached")

func _on_run_state_entered():
	_set_velocity_given_move_mode()

func _on_run_state_physics_processing(delta):
	_set_velocity_given_move_mode()

func _on_idle_state_entered():
	self.stop()

func _on_death_state_entered():
	self.stop()
