extends Item

@export var dash_time = 1.0

var _player

func on_active(player : PlayerController) -> SceneTreeTimer:
	player.dashing = true
	_player = player
	return _start_cooldown_timer(use_cooldown, player)

func _on_timeout():
	_player.dashing = false
