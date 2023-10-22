extends Sprite2D


var is_in_zone : bool = false
var activated : bool = false

signal time_to_go

func _process(delta):
	if Input.is_action_pressed("next_stage") and !activated:
		activated = true
		begin_exit()

func _on_portal_entered(body):
	if body is PlayerController:
		is_in_zone = true

func _on_portal_exit(body):
	if body is PlayerController:
		is_in_zone = false


func begin_exit():
	$AnimationPlayer.play("activate")


func on_completed():
	time_to_go.emit()
