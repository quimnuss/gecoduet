extends Label

@export var species : Constants.Species

func _get_drag_data(_at_position: Vector2):
    print("draggable has run label")
    return self
    
    
