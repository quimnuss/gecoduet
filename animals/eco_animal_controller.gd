extends CharacterBody2D

@export var animal_resource: Resource
@export var animal_exposed_var : int # trying to expose child exports to the parent export

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var nav = $NavigationAgent2D

var speed = 70.0
const JUMP_VELOCITY = -400.0
var debug = false
var state = "alive"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var possessed = false

func _ready():
#    navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
    nav.pawn = self
    set_from_resource()

func set_from_resource():
    var frames : SpriteFrames = self.animal_resource.animation_frames
    self.animation.set_sprite_frames(self.animal_resource.animation_frames)
    self.name = self.animal_resource.name
    self.set_scale(Vector2(self.animal_resource.scale,self.animal_resource.scale))

func _process(delta):
    pass

func kill():
    state = "die"
    await get_tree().create_timer(2).timeout
    queue_free()

func updateAnimation():
    var animationString = "idle"
    if state == "alive":
        if velocity.length_squared() > 0:
            animationString = "run"

        if velocity.x < 0:
            animation.flip_h = true
        elif velocity.x > 0:
            animation.flip_h = false
    else:
        animationString = "die"
        velocity = Vector2.ZERO

    if animation.sprite_frames.has_animation(animationString): # silence carrot running for now
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
            velocity = direction * speed * Vector2(1,-1)
        else:
            velocity = velocity.move_toward(Vector2(0,0), speed/10)
    else:
        pass

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
