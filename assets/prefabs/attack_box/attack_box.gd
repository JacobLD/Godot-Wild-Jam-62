extends Area2D

@export var owned_by : NodePath

func attack(damage):
	var areas : Array = get_overlapping_areas()
	if owned_by.is_empty():
		print("Attack box needs owner")
		return
		
	for area in areas:
		if !area.is_in_group("hitbox"):
			continue
			
		var controller_node = get_node(owned_by)
		if controller_node.is_in_group("player") and area.get_parent().is_in_group("clone"):
			area.take_damage(controller_node.damage, controller_node)
			continue
		
		if controller_node.is_in_group("clone") and area.get_parent().is_in_group("player"):
			area.take_damage(controller_node.damage, controller_node)
			continue
		
		area.take_damage(controller_node.damage)
