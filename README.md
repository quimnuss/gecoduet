# gecoduet

2d godot version of ecoduet

# Design

## quick and dirty static plant

make a flag to disable movement

spawn always in a random point at radius

## Component design

```bash
world
├─ actors
    ├─ ecogaiasystem.tscn | ecosystem.tscn ~
        ├═ elder.tscn (UIplaced)
            ├─ elder_totem.tscn ~
            ├─ GLV Component ~ density?
            ├─ Spawner
            ├─ Species (control)
                ├═ Lifeform¹

    ├─ ¹lifeform.tscn ~
        ├─ Movement (optional)
        ├─ MovementController
        ├─ Navigation2d
        ├─ AnimationSprite2d
        ├─ Sprite
        ├─ FSM
            ├─ Behaviour {Predator,Prey,Static}
        ├─ DeathLogic
    ├─ LifeformFactory ? resource -> lifeform



    ├─ elder_totem.gd
    ├─ elder_totem_spawn.tscn

    ├─ Oracle

├─lifeforms
    ├─ lifeform_res.res
        ├─ speed
        ├─ movementtype
        ├─ species
        ├─ glv_reference?
        ├─ SpriteFrames
        ├─ Sprite2D
    ├─ lifeform (plant)
    ├─ lifeform_dynamic extends lifeform
├─components
       ├─ Spawner.tscn
       ├─ Movement
       ├─ FSM

├─levels
       ├─ world.tscn
       ├─ world_gaia.tscn
       ├─ world_totems.tscn

├─menu
    ├─ Sidebar

├─toplevel
       ├─ main.gd
       ├─ main.tscn

└───UI
        ├─ mutality_graph.tscn
        ├─ UI_mutuality.tscn
```

### Component description

#### Spawner

returns the next available position for spawning

* RandomSpawner: random position at a distance, not checking collisions
* SpiralSpawner: orderly spawns in a grid, following a spiral
* RandomSpawner: checks non-collifing grid positions
* InplaceSpawner: just spawns in the parent position

the starting position is where the user clicked or a random point in range.
Map bounds should always be checked for spawning.

Also signals birth or adds child to Species Component

Recieves signal of death to free slots

#### Oracle

The Oracle entity computes the equilibrium point to know if the current glv has an equilibrium.
If there is an equilibrium outside of the death zone, runs a 20 step simulation to know if any
of the species will traverse the zone of death.

## UI design

- User selects species from side bar 
    - button -> scroll -> select -> sprite placed on button press
    - spawns elder+2 (or lifeform if elder already exists)

- User selects tools from side bar to change environmental conditions which change glv

environmental conditions are humidity, heat, wind... which changes glvs.
We will have a few different equilibrium or non-equilibrium points
that the player can change to move the equilibrium point or oscillation.

## credit

[trees](https://ninjikin.itch.io/trees)
[fruits](https://ninjikin.itch.io/fruit)
[veggies](https://kiriuozoru.itch.io/pixel-art-assets-2d-veggies)
[sproutland](https://cupnooble.itch.io/sprout-lands-asset-pack)
[animals](https://lyaseek.itch.io/miniffanimals)
