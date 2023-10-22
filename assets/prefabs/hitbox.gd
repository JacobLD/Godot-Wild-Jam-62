extends Area2D

@export var i_frame_time_secs : float = 1.0
signal Take_Damage(amount,source)

func _ready():
	$IFrameTimer.wait_time = i_frame_time_secs
	$IFrameTimer.one_shot = true


func take_damage(incoming_damage : float, source : Node2D = null):
	if !$IFrameTimer.is_stopped():
		return
	Take_Damage.emit(incoming_damage, source)
	$IFrameTimer.start()
