extends Node2D

class_name Constants

enum Species {
	CARROT, BEAR, RABBIT, TREE, BIRD, BOAR, DEER, FOX, WOLF, FISH, BERRY
}

enum MoveMode {
	DEFAULT, CHASE_PREY, CHASE_LEADER, AVOID_PREDATOR
}

static func species_name(species : Constants.Species):
	return Species.keys()[species].to_lower()

static func move_mode_name(move_mode : Constants.MoveMode):
	return MoveMode.keys()[move_mode].to_lower()
