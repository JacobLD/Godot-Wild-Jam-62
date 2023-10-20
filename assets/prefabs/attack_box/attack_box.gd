extends Area2D

func attack(damage):
	var areas : Array = get_overlapping_areas()
	for area in areas:
		if(area.is_in_group("hitbox")):
			area.take_damage(damage)
