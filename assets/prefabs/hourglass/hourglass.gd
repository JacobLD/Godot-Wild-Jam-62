extends Node2D

@export var time_to_add : float = 10
var active : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("float")


func _on_area_2d_body_entered(body):
	if body is PlayerController and active:
		active = false
		visible = false
		Parallax.add_time(time_to_add)
		$AudioStreamPlayer2D.finished.connect(queue_free)
		$AudioStreamPlayer2D.play()
	
