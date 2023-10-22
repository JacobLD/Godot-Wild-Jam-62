extends Item

@export var dash_time = 1.0

var _player

func on_active(player : PlayerController) -> SceneTreeTimer:
	player.dashing = true
	_player = player
	get_tree().create_timer(dash_time).timeout.connect(on_end)
	return _start_cooldown_timer(use_cooldown, player)

func _on_timeout():
	pass


func on_end():
	_player.dashing = false
