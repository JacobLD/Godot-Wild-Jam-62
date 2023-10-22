extends Item


@export var chance_to_dodge : float = 0.05

func on_add(player : PlayerController):
	player.dodge_chance = chance_to_dodge


func on_remove(player : PlayerController):
	player.dodge_chance = 0
