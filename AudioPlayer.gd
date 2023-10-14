extends Node
class_name AudioPlayer



# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/GameManager").registerAudioPlayer(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
