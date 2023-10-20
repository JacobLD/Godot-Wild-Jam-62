extends Area2D

@export var i_frame_time_secs : float = 1.0
signal Take_Damage(amount)

func _ready():
	$IFrameTimer.wait_time = i_frame_time_secs
	$IFrameTimer.one_shot = true


func take_damage(incoming_damage : float):
	if !$IFrameTimer.is_stopped():
		return
	Take_Damage.emit(incoming_damage)
	print("Took ", incoming_damage, " damage")
	$IFrameTimer.start()
