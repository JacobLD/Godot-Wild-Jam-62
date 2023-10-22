extends Item


@export var heal : float
var _used = false

func on_active(player : PlayerController) -> SceneTreeTimer:
	if _used:
		return
	_used = true
	player.add_health(heal)
	return _start_cooldown_timer(99999999, player)
