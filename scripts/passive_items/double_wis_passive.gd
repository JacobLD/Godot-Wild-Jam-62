extends Item


@export var wis_mult : int = 2

func on_add(player : PlayerController):
	player.wis_mult = wis_mult
	player.set_wis(player.wis)


func on_remove(player : PlayerController):
	var new_wis = player.wis / wis_mult
	player.set_wis(new_wis)
