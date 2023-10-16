extends Camera2D


@export var default_position : NodePath
var _default_position : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	_default_position = get_node(default_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


