extends Item


@export var str_mult : int = 2

func on_add(player : PlayerController):
	player.str_mult = str_mult
	player.set_str(player.str)


func on_remove(player : PlayerController):
	var new_str = player.str / str_mult
	player.set_str(new_str)
