extends Node

var _player : PlayerController = null
var _world : Node2D = null

var _player_unlock_timer : Timer = Timer.new()

signal player_item_set(item)
signal player_registered(player)

var hub_scene : PackedScene = preload("res://assets/scenes/hub.tscn")
var tutorial_scene : PackedScene = preload("res://assets/scenes/tutorial_island.tscn")
var level_1_scene : PackedScene = preload("res://assets/scenes/level1a.tscn")
var level_2_scene : PackedScene = preload("res://assets/scenes/level2a.tscn")
var level_3_scene : PackedScene = preload("res://assets/scenes/level3a.tscn")
var level_4_scene : PackedScene = preload("res://assets/scenes/level4a.tscn")

var next_stage = 1

var previous_player_props : Array[PlayerProps] = []

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
	#get_tree().create_timer(1).timeout.connect(test_level)

func test_level():
	previous_player_props.append(PlayerProps.new(_player))
	previous_player_props.append(PlayerProps.new(_player))
	previous_player_props.append(PlayerProps.new(_player))
	previous_player_props.append(PlayerProps.new(_player))
	load_stage(level_4_scene)
	

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
			load_stage(level_1_scene)
		2:
			load_stage(level_2_scene)
		3:
			load_stage(level_3_scene)
		4:
			load_stage(level_4_scene)
	next_stage += 1
	#unhide screen

var changing_stages = false

func enter_hub():
	previous_player_props.append(PlayerProps.new(_player))
	load_stage(hub_scene)

func enter_level_1():
	load_stage(level_1_scene)

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


func on_player_died():
	
	_player.done_dying = true
	new_stage.respawn_player()

func win():
	print("TODO WIN")
