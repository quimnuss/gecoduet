extends CharacterBody2D


var speed = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var resource : LifeformAnimalResource = preload("res://data/lifeform_bear.tres")

@onready var animation = $AnimatedSprite2D

func _ready():
	self.animation.set_sprite_frames(resource.animation_frames)
	self.name = resource.name
	self.set_scale(Vector2(resource.scale,resource.scale))
	prints("Animal ready")
	

func _physics_process(delta):
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	if direction:
		velocity = direction * speed * Vector2(1,-1)
	else:
		velocity = velocity.move_toward(Vector2(0,0), speed/10)

	move_and_slide()
