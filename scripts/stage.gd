extends Node
class_name Stage

@export var camera_limit_left : int
@export var camera_limit_right : int
@export var camera_limit_top : int
@export var camera_limit_bottom : int
@export var spawn_point : NodePath
var spawn_point_node : Node2D
@export var next_stage_collider : NodePath
@export var stage_time : float = 60
var collider_trigger

func on_added():
	get_viewport().get_camera_2d().limit_left = camera_limit_left
	get_viewport().get_camera_2d().limit_bottom = camera_limit_bottom
	get_viewport().get_camera_2d().limit_right = camera_limit_right
	get_viewport().get_camera_2d().limit_top = camera_limit_top
	spawn_point_node = get_node(spawn_point)
	collider_trigger = get_node(next_stage_collider)
