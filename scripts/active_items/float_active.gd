extends Item


@export var gravity = -200
@export var float_duration = 1.5

var _player
var low_g
var high_g

func on_active(player : PlayerController) -> SceneTreeTimer:
	high_g = player.high_gravity
	low_g = player.low_gravity
	player.high_gravity = gravity
	player.low_gravity = gravity
	_player = player
	get_tree().create_timer(float_duration).timeout.connect(done_floating)
	return _start_cooldown_timer(use_cooldown, player)

func _on_timeout():
	pass

func done_floating():
	_player.high_gravity = high_g
	_player.low_gravity = low_g
