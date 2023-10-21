extends Stage

var is_in_zone : bool = false

func _on_portal_entered(body):
	if body is PlayerController:
		is_in_zone = true

func _on_portal_exit(body):
	if body is PlayerController:
		is_in_zone = false

func _process(delta):
	if Input.is_action_just_pressed("next_stage"):
		GameManager.enter_hub()
