extends Item


@export var additional_iframe_time : float = 0.2

func on_add(player : PlayerController):
	player.i_frame_time += additional_iframe_time


func on_remove(player : PlayerController):
	player.i_frame_time -= additional_iframe_time
