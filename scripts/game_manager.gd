extends Node

var _player : PlayerController = null

var _player_unlock_timer : Timer = Timer.new()

signal player_item_set(item)

func _ready():
	await get_tree().root.ready
	add_child(_player_unlock_timer)
	_on_start()
	_player_unlock_timer.one_shot = true
	_player_unlock_timer.timeout.connect(_unlock_player)
	set_player_item(ItemManager.get_starter_cheek_clone())
	set_player_item(ItemManager.get_starter_jaw_clone())
	set_player_item(ItemManager.get_starter_nose_clone())


func _on_start() -> void:
	MusicBox.play_upgrade_hub(false)
	if _player:
		_player_unlock_timer.start(3)


func registerPlayer(player : PlayerController):
	print("Player registered")
	_player = player

func getPlayer() -> PlayerController:
	if _player == null:
		printerr("Trying to fetch a null player body")
	return _player


func set_player_item(item : Item):
	_player.set_face_item(item)
	player_item_set.emit(item)



func _unlock_player():
	_player.controls_locked = false


func Exit_Tutorial():
	print("TODO - leaving tutorial")
	MusicBox.play_room_1(true)
