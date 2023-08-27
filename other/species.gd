extends RefCounted

class_name Constants

enum Species {CARROT, BEAR, RABBIT, TREE}

static func species_name(species):
	return Species.keys()[species].to_lower()
