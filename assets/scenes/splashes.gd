extends CanvasLayer


func start():
	$AnimationPlayer.play("opening_splash")


func on_win():
	$AnimationPlayer.play("on_victory")
