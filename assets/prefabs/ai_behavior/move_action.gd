class_name MoveToTargetAction extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var clone : AIController = actor
	
	if clone.is_in_attack_range():
		clone.move_direction = 0
		return SUCCESS
	
	var player : PlayerController = GameManager.getPlayer()
	if player == null or clone == null:
		return FAILURE
	
	var delta_x = player.position.x - clone.position.x
	if delta_x < 0:
		clone.move_direction = -1
	if delta_x > 0:
		clone.move_direction = 1
	
	return RUNNING

func interrupt(actor: Node, _blackboard: Blackboard) -> void:
	actor.stop()
