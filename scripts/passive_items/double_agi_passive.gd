extends Item


@export var agi_mult : int = 2

func on_add(player : PlayerController):
	player.agi_mult = agi_mult
	player.set_agi(player.agi)


func on_remove(player : PlayerController):
	var new_agi = player.agi / agi_mult
	player.set_agi(new_agi)
