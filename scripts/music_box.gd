extends Node

var _playing_track : AudioStreamPlayer = null
@export var blend_time = 3.0

var _blending : bool = false
var _low_db : float = -32.0
var _high_db : float = -6.0
var _incoming_track : AudioStreamPlayer = null
var _outgoing_track : AudioStreamPlayer = null
var blend_timer : Timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_blend_tracks(delta)

func _stop_current_track() -> void:
	if _playing_track != null:
		_playing_track.stop()

func _ready():
	blend_timer = Timer.new()
	add_child(blend_timer)
	blend_timer.one_shot = true
	blend_timer.timeout.connect(timer_done)

func _play_track(child_audio_player : AudioStreamPlayer, blend : bool = false):
	if !blend:
		_stop_current_track()
		child_audio_player.volume_db = _high_db
		child_audio_player.play()
		_playing_track = child_audio_player
	else:
		_outgoing_track = _playing_track
		_incoming_track = child_audio_player
		_playing_track = _incoming_track
		if _outgoing_track != null:
			_outgoing_track.volume_db = _high_db
		_incoming_track.volume_db = _low_db
		child_audio_player.play()
		_blending = true
		blend_timer.start(blend_time)

func play_tutorial_track(blend : bool) -> void:
	_play_track($tutorial, blend)

func play_room_1(blend : bool) -> void:
	_play_track($boss_1, blend)

func play_room_2(blend : bool) -> void:
	_play_track($boss_2, blend)

func play_room_3(blend : bool) -> void:
	_play_track($boss_3, blend)

func play_room_4(blend : bool) -> void:
	_play_track($boss_4, blend)

func play_upgrade_hub(blend : bool) -> void:
	_play_track($upgrade_hub, blend)

func _blend_tracks(delta):
	if !_blending:
		return
	
	if blend_timer.is_stopped():
		return
	
	
	
	if _outgoing_track != null:
		_outgoing_track.volume_db = lerp(_low_db, _high_db, blend_timer.time_left / blend_timer.wait_time)
	_incoming_track.volume_db = lerp(_high_db, _low_db, blend_timer.time_left / blend_timer.wait_time)
	

func timer_done():
	if _outgoing_track != null:
		_outgoing_track.stop()
	_outgoing_track = null
	_blending = false
