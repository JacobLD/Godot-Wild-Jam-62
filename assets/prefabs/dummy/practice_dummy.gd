extends Node2D

func _on_hitbox_take_damage(amount, source):
	$AnimationPlayer.play("hit")
