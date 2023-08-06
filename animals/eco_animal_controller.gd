extends CharacterBody2D


func _ready():
    set_process(true)

func _process(delta):
    if Input.is_action_pressed("ui_exit"):
        get_tree().quit()

@onready var animation = $AnimatedSprite2D

const SPEED = 70.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func updateAnimation():
    var animationString = "idle"
    if velocity.length_squared() > 0:
        animationString = "run"

    if velocity.x < 0:
        animation.flip_h = true
    elif velocity.x > 0:
        animation.flip_h = false

    animation.play(animationString)

func _physics_process(delta):
    # Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta

    # Handle Jump.
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    #TODO ensure norm of velocity is speed so diagonal is not faster
    # also down should probably be half

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var direction = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
    if direction:
        velocity = direction * SPEED * Vector2(1,-1)
    else:
        velocity = velocity.move_toward(Vector2(0,0), SPEED/10)

    updateAnimation()
    move_and_slide()
