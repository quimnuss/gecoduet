#extends CollisionShape2D
#
#func _input(event: InputEvent) -> void:
#    if event is InputEventScreenDrag:
#        get_parent().position += event.relative

extends Node


var dragging = false
var click_radius = 32 # Size of the sprite.


func _input(event):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if (event.position - get_parent().position).length() < click_radius:
            # Start dragging if the click is on the sprite.
            if not dragging and event.pressed:
                dragging = true
        # Stop dragging if the button is released.
        if dragging and not event.pressed:
            dragging = false

    if event is InputEventMouseMotion and dragging:
        # While dragging, move the sprite with the mouse.
         get_parent().global_position = event.position
