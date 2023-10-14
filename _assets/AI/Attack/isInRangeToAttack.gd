class_name IsInRangeToAttack extends ConditionLeaf


func tick(actor:Node, blackboard:Blackboard) -> int:
	if blackboard.has_value("attack_range") && blackboard.has_value("target"):
		return SUCCESS
	return FAILURE
