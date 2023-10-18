class_name AttackPlayerAction extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var clone : AIController = actor
	clone.wants_to_attack = clone.is_in_attack_range()
	return SUCCESS

func interrupt(actor: Node, _blackboard: Blackboard) -> void:
	actor.stop()
