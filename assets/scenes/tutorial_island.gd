extends Stage

func _on_area_2d_body_entered(body):
	if body is PlayerController and !GameManager.changing_stages:
		GameManager.enter_hub()
