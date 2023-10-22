extends Node2D

@export var time_to_add : float = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("float")


func _on_area_2d_body_entered(body):
	if body is PlayerController:
		Parallax.add_time(time_to_add)
		queue_free()
