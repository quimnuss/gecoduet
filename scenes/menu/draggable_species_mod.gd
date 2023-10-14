extends ColorRect

@export var species : Constants.Species = Constants.Species.BEAR

var dropped_on_target: bool = false

var t = preload("res://scenes/menu/theme.theme")

@export var is_negative : bool = false
@export var red_modulate : Color = Color(1,0,0)
@export var green_modulate : Color = Color(0,1,0)

func _get_drag_data(_at_position: Vector2):
    print("draggable has run")
    if not dropped_on_target:
        set_drag_preview(_get_preview_label())
        return self

func _get_preview_label() -> Control:
    var preview : Label = Label.new()
    preview.text = SpeciesConstants.species_emojis[species]
    preview.set_theme(t)
    preview.set("theme_override_font_sizes/font_size", 12)
    preview.set_rotation(.2)
    if is_negative:
        preview.modulate = red_modulate
    else:
        preview.modulate = green_modulate

    return preview

func _get_preview_control() -> Control:
    """
    The preview control must not be in the scene tree. You should not free the control, and
    you should not keep a reference to the control beyond the duration of the drag.
    It will be deleted automatically after the drag has ended.
    """
    var preview = ColorRect.new()
    preview.size = size
    var preview_color = color
    preview_color.a = .5
    preview.color = preview_color
    preview.set_rotation(.1) # in readians
    return preview

func _on_item_dropped_on_target(draggable):
    print("[Draggable] Signal item_dropped_on_target received")
    if draggable.get_instance_id() != self.get_instance_id():
        return
    print("[Draggable] Iven been dropped, removing myself from source container")
    queue_free()
