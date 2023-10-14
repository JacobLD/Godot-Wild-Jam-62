extends Node

var _player : CharacterBody2D = null
var _audio_player : AudioPlayer = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func registerPlayer(player : CharacterBody2D):
	print("Player registered")
	_player = player


func getPlayer() -> CharacterBody2D:
	if _player == null:
		printerr("Trying to fetch a null player body")
	
	return _player

func registerAudioPlayer(player : AudioPlayer):
	_audio_player = player;

func getAudioPlayer() -> AudioPlayer:
	if _audio_player == null:
		printerr("Trying to fetch a null audio player!")
	
	return _audio_player
