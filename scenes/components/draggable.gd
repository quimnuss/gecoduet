extends CollisionShape2D

func _input(event: InputEvent) -> void:
    if event is InputEventScreenDrag:
        get_parent().position += event.relative
