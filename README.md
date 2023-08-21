# gecoduet

2d godot version of ecoduet

# Design

## Component design

```bash
world
├───actors
│       ecogaiasystem.gd
│       ecogaiasystem.tscn
│       ecosystem.gd
│       ecosystem.tscn
│       elder.tscn
│       elder_static.tscn
│       elder_totem.gd
│       elder_totem.tscn
│       elder_totem_spawn.tscn
│
├───animals
│       AnimalRoam.gd
│       eco_animal_bear.tscn
│       eco_animal_controller.gd
│       eco_animal_rabbit.tscn
│       eco_flora.tscn
│
├───components
│       Spawner.tscn
│
├───levels
│       world.tscn
│       world_gaia.tscn
│       world_totems.tscn
│
├───menu
├───toplevel
│       main.gd
│       main.tscn
│
└───UI
        mutality_graph.tscn
        UI_mutuality.tscn
```