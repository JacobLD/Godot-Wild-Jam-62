extends Node

var _playing_track : AudioStreamPlayer = null
@export var blend_time = 3.0

var _blending : bool = false
var _low_db : float = -25.0
var _high_db : float = 0.0
var _incoming_track : AudioStreamPlayer = null
var _outgoing_track : AudioStreamPlayer = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_blend_tracks(delta)

func _stop_current_track() -> void:
	if _playing_track != null:
		_playing_track.stop()
		

func _play_track(child_audio_player : AudioStreamPlayer, blend : bool = false):
	if !blend:
		_stop_current_track()
		child_audio_player.volume_db = _high_db
		child_audio_player.play()
		_playing_track = child_audio_player
	else:
		_outgoing_track = _playing_track
		if _outgoing_track != null:
			_outgoing_track.volume_db = _high_db
		
		_incoming_track = child_audio_player
		_incoming_track.volume_db = _low_db
		_blending = true

func play_tutorial_track(blend : bool) -> void:
	_play_track($TutorialIsland, blend)

func play_room_1(blend : bool) -> void:
	_play_track($Room_1, blend)

func play_room_2(blend : bool) -> void:
	_play_track($Room_2, blend)

func play_room_3(blend : bool) -> void:
	_play_track($Room_3, blend)

func play_room_4(blend : bool) -> void:
	_play_track($Room_4, blend)

func play_upgrade_hub(blend : bool) -> void:
	_play_track($Upgrade_Hub, blend)

func _blend_tracks(delta):
	if !_blending:
		return
	
	if _outgoing_track != null:
		_outgoing_track.volume_db = move_toward(_outgoing_track.volume_db, _low_db, blend_time*delta/(_high_db-_low_db))
	_incoming_track.volume_db = move_toward(_incoming_track.volume_db, _high_db, blend_time*delta/(_high_db-_low_db))
	
	if _incoming_track.volume_db == _high_db:
		if _outgoing_track != null:
			_outgoing_track.stop()
		_outgoing_track = null
		_blending = false
