extends CharacterBody2D

class_name Animal

var speed = 200.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var resource : LifeformAnimalResource = preload("res://data/lifeform_bear.tres")

@onready var state_machine = $StateChart
@onready var movement = $Movement
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

var species : Constants.Species

var debug = false

var controlled = false

func _ready():
    self.set_name(resource.name)
    self.set_scale(Vector2(resource.scale,resource.scale))
    self.speed = resource.speed
    self.species = resource.species
    if resource.mobility_type == 'fly':
        self.set_collision_mask_value(2,false)
    sprite.set_texture(resource.texture)
    sprite.hframes = resource.texture_shape[0]
    sprite.vframes = resource.texture_shape[1]
    prints("animation library",resource.animation_library.get_animation_list())
    for library in animation_player.get_animation_library_list():
        animation_player.remove_animation_library(library)
    animation_player.add_animation_library("animal",resource.animation_library)
    var has_idle = animation_player.has_animation('animal/idle')
    movement.pawn = self
    $StateChartDebugger.visible = false

func _input(event):
    if event.is_action_pressed("ui_state_debug"):
        if $StateChartDebugger:
            $StateChartDebugger.visible = !$StateChartDebugger.visible

    if event.is_action_pressed("ui_debug_navigation"):
        if $NavigationAgent2D:
            $NavigationAgent2D.debug_enabled = !$NavigationAgent2D.debug_enabled

    if event.is_action_pressed("ui_debug_action"):
#		var move_mode = ["chase_prey","chase_leader","avoid_predator"].pick_random()
#		prints("switching to",move_mode)
#		movement.move_mode = move_mode
#		state_machine.set_trigger("die")
        kill()

# un-estated input processing
func _physics_process(delta):
    pass

func _physics_input_process(delta):

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

#	state_machine.set_param("velocity", velocity.length())

    # this logic should be in the state machine somehow
    if velocity.x < 0:
        sprite.set_flip_h(true)
    elif velocity.x > 0:
        sprite.set_flip_h(false)

#	state_machine.set_expression_property("velocity",velocity.length())
#	state_machine.send_event("velocity_update")
    move_and_slide()


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

func _on_idle_state_entered():
    state_machine.send_event("seek")


func _on_run_anim_state_physics_processing(delta):
    _physics_input_process(delta)
    if velocity.length_squared() <= 0.1:
        state_machine.send_event("stopped")
    else:
        #prints("velocity",self.name,velocity.length_squared())
        pass

func _on_idle_anim_state_physics_processing(delta):
    _physics_input_process(delta)
    if not velocity.length_squared() <= 0.05:
        state_machine.send_event("is_moving")

