extends Node2D

@export var frame_scale = 0.4


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _set_item(item : Item):
	match item.FacePosition:
		Item.FacePosition.JAW:
			item.reparent($jaw_pos, false)
		Item.FacePosition.CHEEK:
			item.reparent($cheek_pos, false)
		Item.FacePosition.NOSE:
			item.reparent($nose_pos, false)


func set_frame(item : Item):
	item.reparent($item_frame, false)
	item.scale = frame_scale
