extends CharacterBody2D

class_name Animal

var speed = 200.0
var acceleration = 100.0
const JUMP_VELOCITY = -400.0
const MOVING_THRESHOLD = 0.05

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var resource : LifeformAnimalResource = preload("res://data/lifeform_bear.tres")

@onready var state_machine = $StateChart
@onready var movement = $Movement
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var highlight = $Highlight

var predator_species : Array[Constants.Species] = []

signal selected

var species : Constants.Species

var debug = false

#TODO handle unselectable spawn
var is_selected = false

var sensed_predators : Array[Animal] = []
var predator_sensed_count = 0


func _ready():
    self.set_name.call_deferred(resource.name)
    self.set_scale(Vector2(resource.scale,resource.scale))
    self.speed = resource.speed
    self.species = resource.species
    if resource.mobility_type == 'fly':
        self.set_collision_mask_value(2,false)
    sprite.set_texture(resource.texture)
    sprite.hframes = resource.texture_shape[0]
    sprite.vframes = resource.texture_shape[1]
    prints(resource.name,"animation library",resource.animation_library.get_animation_list())
    for library in animation_player.get_animation_library_list():
        animation_player.remove_animation_library(library)
    animation_player.add_animation_library("animal",resource.animation_library)
    var has_idle = animation_player.has_animation('animal/idle')
    movement.pawn = self
    $StateChartDebugger.visible = false
    input_pickable = true

    if get_parent() == get_tree().root:
        $NavigationRegion2D.set_enabled(true)
        set_selected(true)
    else:
        set_selected(false)

    _set_predator_species()

func _input(event):
    if event.is_action_pressed("ui_state_debug"):
        if $StateChartDebugger:
            $StateChartDebugger.visible = false

    if event.is_action_pressed("ui_debug_navigation"):
        if $NavigationAgent2D:
            $NavigationAgent2D.debug_enabled = !$NavigationAgent2D.debug_enabled

    if event.is_action_pressed("ui_debug_action"):
#		var move_mode = ["chase_prey","chase_leader","avoid_predator"].pick_random()
#		prints("switching to",move_mode)
#		movement.move_mode = move_mode
#		state_machine.set_trigger("die")
        kill()

func _input_event(viewport, event, shape_idx):

    if event.is_action_pressed("ui_select_actor"):

        if event is InputEventMouseButton and event.is_double_click():
            var was_selected = get_selected()
            set_selected(!get_selected())
            prints(self.name,"selected?",was_selected,"->",get_selected())
        else:
            $StateChartDebugger.visible = !$StateChartDebugger.visible

# un-estated input processing
func _physics_process(delta):
    pass

func _physics_input_process(delta):

    if get_selected():
        var direction = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
        if direction:
            velocity = direction * speed * Vector2(1,-1)
            state_machine.send_event("posess")
        else:
            velocity = velocity.lerp(Vector2(0,0), delta*acceleration)

        if Input.is_action_pressed("ui_deselect_actor"):
            state_machine.send_event("unposess")
            set_selected(false)

            velocity = velocity.lerp(Vector2(0,0), delta*acceleration)

    # this logic should be in the state machine somehow
    if velocity.x < -0.01:
        sprite.set_flip_h(true)
    elif velocity.x > 0.01:
        sprite.set_flip_h(false)

    move_and_slide()

func _set_predator_species():
    var _res_mutuality = preload("res://data/glv.json")
    var species_name = Constants.species_name(self.species)
    var mutuality : Dictionary = _res_mutuality.get_data().get(species_name,{})
    var predator_species_names : Array[String] = []
    for other_species_name in mutuality:
        var other_species = Constants.Species.get(other_species_name.to_upper(), null)
        if other_species_name.to_upper() == 'NONE':
            continue
        if not other_species:
            prints("species",other_species_name.to_upper(),"not found in",Constants.Species.keys())
            continue

        if self.species != other_species and mutuality[other_species_name] < -0.03:
            predator_species.append(other_species)
            predator_species_names.append(other_species_name)
        else:
            prints(other_species_name,"is not a predator with",mutuality[other_species_name])

    prints("predators of",species_name,"has predators",predator_species_names)

func set_target_lifeform(target_lifeform : Node2D):
    self.movement.target_lifeform = target_lifeform

func set_selected(turn_on):
    set_highlight(turn_on)
    is_selected = turn_on
    if is_selected:
        state_machine.send_event("posess")
    else:
        state_machine.send_event("unposess")
    # how to deal with deselect on click?
        selected.emit(self)

func get_selected():
    return is_selected

func set_highlight(turn_on = true, blueish = false):
    highlight.visible = turn_on
    if blueish:
        highlight.modulate = Color(0, 0, 1) # blue shade

func kill():
    state_machine.send_event("death")
    await get_tree().create_timer(4).timeout
    queue_free()

func _on_idle_state_entered():
    state_machine.set_expression_property("predator_sensed_count", predator_sensed_count)

func _on_run_anim_state_physics_processing(delta):
    _physics_input_process(delta)
    if velocity.length_squared() <= MOVING_THRESHOLD:
        state_machine.send_event("stopped")
    else:
        #prints("velocity",self.name,velocity.length_squared())
        pass

func _on_idle_anim_state_physics_processing(delta):
    _physics_input_process(delta)
    if not velocity.length_squared() <= MOVING_THRESHOLD:
        state_machine.send_event("is_moving")

func _on_sensory_radius_body_entered(body : Animal):
    #prints(body.name,"entered",self.name,"sensory")
    if body is Animal:
        # todo use GLV to determine predators at setup or dynamically
        if self.species != body.species and body.species in predator_species:
            sensed_predators.append(body)
            predator_sensed_count += 1
            state_machine.set_expression_property("predator_sensed_count", predator_sensed_count)
            state_machine.send_event("predator_sensed")

func _on_sensory_radius_body_exited(body):
    #prints(body.name,"exited",self.name,"sensory")
    if body is Animal:
        # todo use GLV to determine predators at setup or dynamically
        if self.species != body.species and body.species in predator_species:
            sensed_predators.erase(body)
            predator_sensed_count -= 1
            state_machine.set_expression_property("predator_sensed_count", predator_sensed_count)
            state_machine.send_event("predator_lost")
