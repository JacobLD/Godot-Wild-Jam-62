extends InputController
class_name PlayerInputController

func jump_just_pressed() -> bool:
	return Input.is_action_just_pressed("jump")

func jump_pressed() -> bool:
	return Input.is_action_pressed("jump")

func input_direction() -> float:
	return Input.get_axis("strafe_left", "strafe_right")

func block_pressed() -> bool:
	return Input.is_action_pressed("block")

func active_just_pressed() -> bool:
	return Input.is_action_just_pressed("use_active")

func attack_just_pressed() -> bool:
	return Input.is_action_just_pressed("attack")

func sprint_is_pressed() -> bool:
	return Input.is_action_pressed("sprint")
