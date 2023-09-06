extends CharacterBody2D


var speed = 200.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var resource : LifeformAnimalResource = preload("res://data/lifeform_bear.tres")

@onready var animation = $AnimatedSprite2D
@onready var state_machine = $StateMachinePlayer
@onready var movement = $Movement

var species : Constants.Species

var debug = false

var controlled = false

func _ready():
    self.animation.set_sprite_frames(resource.animation_frames)
    self.name = resource.name
    self.set_scale(Vector2(resource.scale,resource.scale))
    self.speed = resource.speed
    self.species = resource.species
    movement.pawn = self
    animation.pawn = self


func _physics_process(delta):

    if Input.is_action_just_pressed("ui_accept"):
        velocity.y = JUMP_VELOCITY

    var direction = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
    if direction:
        velocity = direction * speed * Vector2(1,-1)
        controlled = true
    elif controlled:
        velocity = velocity.lerp(Vector2(0,0), delta*speed/10)

    if velocity == Vector2.ZERO:
        controlled = false

    var debug_pressed = Input.is_action_pressed("ui_debug")
    if debug_pressed:
#		state_machine.set_trigger("die")
        kill()

    state_machine.set_param("velocity", velocity.length())
    move_and_slide()

func kill():
    state_machine.set_trigger("die")
    await get_tree().create_timer(4).timeout
    queue_free()
