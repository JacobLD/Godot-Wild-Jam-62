extends Node
class_name AudioPlayer

var _playing_track : AudioStreamPlayer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/GameManager").registerAudioPlayer(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _stop_current_track() -> void:
	if _playing_track != null:
		_playing_track.stop()

func play_tutorial_track() -> void:
	_stop_current_track()
	$TutorialIsland.play()
