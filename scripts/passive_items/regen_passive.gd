extends Item


@export var regen_amount : float = 1
@export var regen_interval : float = 5

var timer : Timer = Timer.new()
var _player : PlayerController

func on_add(player : PlayerController):
	add_child(timer)
	timer.one_shot = false
	timer.timeout.connect(on_heal)
	timer.start(regen_interval)
	_player = player


func on_remove(player : PlayerController):
	timer.stop()


func on_heal():
	_player.add_health(regen_amount)
