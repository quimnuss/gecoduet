extends AnimatedSprite2D

@export var pawn : CharacterBody2D

func _on_state_machine_player_updated(state, delta):
	match state:
		"death":
			pass
		_:
			if self.sprite_frames.has_animation(state):
				if pawn.velocity.x < -10:
					self.flip_h = true
				elif pawn.velocity.x > 10:
					self.flip_h = false
				self.play(state)


func _on_state_machine_player_transited(from, to):
	match to:
		"death":
			self.play("die")
