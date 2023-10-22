extends Node

var _player : PlayerController = null
var _world : Node2D = null

var _player_unlock_timer : Timer = Timer.new()

signal player_item_set(item)
signal player_registered(player)

var hub_scene : PackedScene = preload("res://assets/scenes/hub.tscn")
var tutorial_scene : PackedScene = preload("res://assets/scenes/tutorial_island.tscn")

var next_stage = 1

func _ready():
	await get_tree().root.ready
	add_child(_player_unlock_timer)
	_on_start()
	_player_unlock_timer.one_shot = true
	_player_unlock_timer.timeout.connect(_unlock_player)
	set_player_item(ItemManager.get_starter_cheek_clone())
	set_player_item(ItemManager.get_starter_jaw_clone())
	set_player_item(ItemManager.get_starter_nose_clone())
	load_tutorial()
	#get_tree().create_timer(1).timeout.connect(enter_hub)


func register_world(world : Node2D):
	_world = world

func _on_start() -> void:
	MusicBox.play_upgrade_hub(false)
	if _player:
		_player_unlock_timer.start(3)


func registerPlayer(player : PlayerController):
	print("Player registered")
	_player = player
	player_registered.emit(player)

func getPlayer() -> PlayerController:
	if _player == null:
		printerr("Trying to fetch a null player body")
	return _player


func set_player_item(item : Item):
	_player.set_face_item(item)
	player_item_set.emit(item)


func exit_hub():
	# Hide screen
	match next_stage:
		1:
			pass
		2:
			pass
		3:
			pass
		4:
			pass
	next_stage += 1
	#unhide screen

var changing_stages = false

func enter_hub():
	load_stage(hub_scene)

func _unlock_player():
	_player.controls_locked = false

var old_stage : Stage
var new_stage : Stage

func load_tutorial():
	new_stage = tutorial_scene.instantiate()
	_world.add_child(new_stage)
	new_stage.position = Vector2.ZERO
	new_stage.on_added()
	_player.reparent(new_stage.spawn_point_node)
	_player.position = Vector2.ZERO
	Parallax.start_over(new_stage.stage_time)

func load_stage(stage : PackedScene):
	changing_stages = true
	_load_stage(stage)

func _load_stage(stage : PackedScene):
	old_stage = _world.get_child(0)
	new_stage = stage.instantiate()
	_world.add_child(new_stage)
	new_stage.position = Vector2.ZERO
	new_stage.on_added()
	_player.reparent(new_stage.spawn_point_node)
	_player.position = Vector2.ZERO
	old_stage.queue_free()
	Parallax.start_over(new_stage.stage_time)
	changing_stages = false
