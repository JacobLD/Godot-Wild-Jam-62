extends ConditionLeaf
class_name MoveToPlayerAction

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var clone : AIController = actor
	if clone == null:
		return FAILURE

	if clone.is_in_attack_range():
		return SUCCESS
	
	return FAILURE

func interrupt(actor: Node, _blackboard: Blackboard) -> void:
	actor.stop()
