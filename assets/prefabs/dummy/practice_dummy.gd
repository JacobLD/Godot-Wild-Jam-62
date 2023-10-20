extends Node2D

func _on_hitbox_take_damage(amount):
	$AnimationPlayer.play("hit")
	print("Dummy took ", amount, " damage")
