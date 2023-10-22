extends PlayerController
class_name AIController


@export var patrol_points : Array[NodePath]

var player_in_zone = false

func _process(delta):
	super._process(delta)
	$brain.tick(self)

func _on_player_enter_zone(body):
	if body.is_in_group("player"):
		player_in_zone = true


func _on_player_exit_zone(body):
	if body.is_in_group("player"):
		player_in_zone = false
