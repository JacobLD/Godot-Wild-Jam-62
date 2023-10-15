extends Node

var _player : PlayerController = null
var _audio_player : AudioPlayer = null

var _player_unlock_timer : Timer = Timer.new()

func _ready():
	self.call_deferred("_on_start")
	add_child(_player_unlock_timer)
	_player_unlock_timer.one_shot = true
	_player_unlock_timer.timeout.connect(_unlock_player)


func _on_start() -> void:
	_audio_player.play_tutorial_track()
	_player_unlock_timer.start(3)


func registerPlayer(player : PlayerController):
	print("Player registered")
	_player = player


func getPlayer() -> PlayerController:
	if _player == null:
		printerr("Trying to fetch a null player body")
	
	return _player

func registerAudioPlayer(player : AudioPlayer):
	_audio_player = player;

func getAudioPlayer() -> AudioPlayer:
	if _audio_player == null:
		printerr("Trying to fetch a null audio player!")
	
	return _audio_player

func _unlock_player():
	_player.controls_locked = false


func Exit_Tutorial():
	print("TODO - leaving tutorial")
