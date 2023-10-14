extends ActionLeaf
class_name MoveToAttackRangeAction

func tick(actor:Node, blackboard:Blackboard) -> int:
	var player = GameManager.getPlayer()
	if player == null:
		return FAILURE
	
	
	
	return SUCCESS
