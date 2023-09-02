extends AnimatedSprite2D

@export var pawn : CharacterBody2D

func _on_state_machine_player_updated(state, delta):
	if self.sprite_frames.has_animation(state):
		if pawn.velocity.x < 0:
			self.flip_h = true
		elif pawn.velocity.x > 0:
			self.flip_h = false
		self.play(state)
