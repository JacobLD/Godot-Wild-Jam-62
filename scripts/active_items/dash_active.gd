extends Item

@export var dash_time = 1.0

var _player

func on_active(player : PlayerController):
	player.dashing = true
	_player = player
	get_tree().create_timer(dash_time).timeout.connect(on_timeout)

func on_timeout():
	_player.dashing = false
