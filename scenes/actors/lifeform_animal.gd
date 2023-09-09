extends CharacterBody2D

class_name Animal

var speed = 200.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var resource : LifeformAnimalResource = preload("res://data/lifeform_bear.tres")

@onready var animation = $AnimatedSprite2D
@onready var state_machine = $StateChart
@onready var movement = $Movement
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

var species : Constants.Species

var debug = false

var controlled = false

func _ready():
	self.animation.set_sprite_frames(resource.animation_frames)
	self.name = resource.name
	self.set_scale(Vector2(resource.scale,resource.scale))
	self.speed = resource.speed
	self.species = resource.species
	sprite.set_texture(resource.texture)
	sprite.hframes = resource.texture_shape[0]
	sprite.vframes = resource.texture_shape[1]

	animation_player.add_animation_library("animal",resource.animation_library)
	movement.pawn = self
	animation.pawn = self


func _physics_process(delta):

#	if Input.is_action_just_pressed("ui_accept"):
#		velocity.y = JUMP_VELOCITY
#
	var direction = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	if direction:
		velocity = direction * speed * Vector2(1,-1)
		controlled = true
	elif controlled:
		velocity = velocity.lerp(Vector2(0,0), delta*speed/10)
#
	if velocity == Vector2.ZERO:
		controlled = false


	var debug_pressed = Input.is_action_pressed("ui_debug")
	if debug_pressed:
#		var move_mode = ["chase_prey","chase_leader","avoid_predator"].pick_random()
#		prints("switching to",move_mode)
#		movement.move_mode = move_mode
#		state_machine.set_trigger("die")
		kill()

#	state_machine.set_param("velocity", velocity.length())
	state_machine.set_expression_property("velocity",velocity.length())
	state_machine.send_event("velocity_update")
	move_and_slide()
	pass

func set_target_lifeform(target_lifeform : Node2D):
	self.movement.target_lifeform = target_lifeform

func set_highlight(turn_on = true, blueish = false):
	var highlight : Sprite2D = $Highlight
	highlight.visible = turn_on
	if blueish:
		highlight.modulate = Color(0, 0, 1) # blue shade
	

func kill():
	state_machine.send_event("death")
	await get_tree().create_timer(4).timeout
	queue_free()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	state_machine.set_param("velocity", safe_velocity.length())
