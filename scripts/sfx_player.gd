extends Node2D
class_name SFXPlayer

enum FloorType {
	GRASS,
	ROCK,
	WETLEAVES
}

@export var Feet_Position : NodePath
var _feet_pos : Node2D = null

@export var Hand_Position : NodePath
var _hand_pos : Node2D = null

func _ready():
	_feet_pos = get_node(Feet_Position)
	_hand_pos = get_node(Hand_Position)

func on_jump():
	_play_random_child_at(_feet_pos.global_position, $Jump)


func on_swing():
	_play_random_child_at(_hand_pos.global_position, $Swing)


func on_block():
	_play_random_child_at(_hand_pos.global_position, $Block)


func on_footstep(type):
	match type:
		FloorType.GRASS:
			_play_random_child_at(_feet_pos.global_position, $Grass)
		FloorType.ROCK:
			_play_random_child_at(_feet_pos.global_position, $Rocks)
		FloorType.WETLEAVES:
			_play_random_child_at(_feet_pos.global_position, $Leaves)

func _play_random_child_at(pos : Vector2, child : Node) -> void:
	var child_arr : Array = child.get_children()
	var sound_node : AudioStreamPlayer2D = child_arr.pick_random()
	sound_node.global_position = pos
	sound_node.play()
