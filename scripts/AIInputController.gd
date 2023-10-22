extends InputController

var wants_to_jump = false
var input_dir : float = 0.0
var blocking : bool = false
var wants_to_use_active : bool = false
var wants_to_attack : bool = false
var wants_to_walk : bool = false

func jump_just_pressed() -> bool:
	return wants_to_jump

func jump_pressed() -> bool:
	return wants_to_jump

func input_direction() -> float:
	return input_dir

func block_pressed() -> bool:
	return blocking

func active_just_pressed() -> bool:
	return wants_to_use_active

func attack_just_pressed() -> bool:
	return wants_to_attack

func walk_is_pressed() -> bool:
	return wants_to_walk
