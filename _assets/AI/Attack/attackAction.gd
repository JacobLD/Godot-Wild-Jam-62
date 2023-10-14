extends ActionLeaf
class_name AttackAction

func tick(actor:Node, blackboard:Blackboard) -> int:
	var is_attacking : bool = true # This will be gotten from the animation player
	if is_attacking:
		return RUNNING
	
	return SUCCESS
