extends Resource

class_name LifeformAnimalResource

@export var lifeform_type : String = "animal"
@export var mobility_type : String = "run"
@export var name : String
@export var species : Constants.Species
@export var scale : float = 1
@export var speed: float = 100
@export var spriteframes : SpriteFrames
@export var animation_library : AnimationLibrary
@export var texture : CompressedTexture2D
@export var texture_shape : Vector2i
@export var texture_coords : Vector2i
# in case we ever have a non uniform spritesheet
@export var region : Rect2i
