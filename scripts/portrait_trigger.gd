extends Area2D

@export var animation_player : NodePath
var _animatino_player : AnimationPlayer = null
# Called when the node enters the scene tree for the first time.
func _ready():
	_animatino_player = get_node(animation_player)


	
