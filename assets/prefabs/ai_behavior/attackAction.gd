class_name AttackPlayerAction extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var clone : AIController = actor
	
	if !clone.is_in_attack_range():
		clone.wants_to_attack = false
		return SUCCESS
	
	clone.wants_to_attack = true
	return SUCCESS

func interrupt(actor: Node, _blackboard: Blackboard) -> void:
	actor.stop()
