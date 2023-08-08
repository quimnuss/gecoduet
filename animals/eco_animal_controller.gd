extends CharacterBody2D

func _ready():
    set_process(true)
#    navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func _process(delta):
    if Input.is_action_pressed("ui_exit"):
        get_tree().quit()

@onready var animation = $AnimatedSprite2D
@onready var nav = $NavigationAgent2D

const SPEED = 70.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var possessed = false

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

    if possessed:
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
    else:
        if nav.state == "roaming" and nav.is_target_reachable() and not nav.is_target_reached():
            var target = nav.get_next_path_position()
            var vel = (target - position).normalized() * SPEED
            velocity = vel
#            print_debug("not reached: ", nav.get_final_position(), target, position, velocity)
        elif not nav.is_target_reachable():
            print(nav.get_final_position(), " is unreachable. Next pos ", nav.get_next_path_position())
            velocity = Vector2(0,0)
            nav.state = "idle"
        else:
            # TODO this doesn't reset elapsed and introduces many bugs
            velocity = Vector2(0,0)
            nav.state = "idle"

    updateAnimation()
    move_and_slide()


#@export var movement_speed: float = 4.0
#@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")
#
#func set_movement_target(movement_target: Vector2):
#    navigation_agent.set_target_position(movement_target)
#
#func _physics_process(delta):
#    if navigation_agent.is_navigation_finished():
#        return
#
#    var next_path_position: Vector2 = navigation_agent.get_next_path_position()
#    var current_agent_position: Vector2 = global_position
#    var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * movement_speed
#    if navigation_agent.avoidance_enabled:
#        navigation_agent.set_velocity(new_velocity)
#    else:
#        _on_velocity_computed(new_velocity)
#
#func _on_velocity_computed(safe_velocity: Vector2):
#    velocity = safe_velocity
#    updateAnimation()
#    move_and_slide()
