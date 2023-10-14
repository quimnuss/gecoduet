extends TextureRect

signal drop_received(amount : float, species : Constants.Species)

func _on_mouse_entered():
    self.visible = true

func _on_mouse_exit():
    self.visible = false


func _can_drop_data(position: Vector2, data) -> bool:
    var can_drop = true
    return can_drop


func _drop_data(_position: Vector2, drop: Variant) -> void:
    prints("dropped: ",drop)
    var amount = 0
    if drop.is_negative:
        amount = -0.1
    elif not drop.is_negative:
        amount = 0.1
    
    var species : Constants.Species = drop.species
    prints("dropzone will emit",species,amount)
    drop_received.emit(amount, species)
    
