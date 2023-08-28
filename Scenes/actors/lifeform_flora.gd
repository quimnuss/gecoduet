extends StaticBody2D

@export var resource : LifeformAnimalResource = preload("res://data/lifeform_carrot.tres")

@onready var sprite = $Sprite2D

func _ready():
	var animation_frame = resource.animation_frames.get_frame_texture('idle', 0)
	self.sprite.set_texture(animation_frame) 
	self.name = resource.name
	self.set_scale(Vector2(resource.scale,resource.scale))
	self.sprite.set_scale(Vector2(resource.scale,resource.scale))

