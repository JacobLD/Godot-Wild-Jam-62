extends Node2D
class_name Portrait

@export var frame_scale = 0.4
# How many px +/- will this float
@export var float_range = 24
# Time to float to each node
@export var float_speed = 2

var noise_gen : FastNoiseLite = null
var target_pos : float = 0
var current_pos : float = 0
var starting_pos : float = 0
var noise_pos = 0
var rand_offset = randi() % 500

var item : Item = null

func _ready():
	noise_gen = FastNoiseLite.new()
	starting_pos = position.y

func _process(delta):	
	position.y = starting_pos + noise_gen.get_noise_2d(rand_offset, Time.get_ticks_msec() * delta / float_speed) * float_range

func set_item(_item : Item):
	_item.visible = true
	_item.position = Vector2.ZERO
	_item.scale = Vector2.ONE
	match _item.face_position:
		Item.FacePosition.JAW:
			if $jaw_pos.get_child_count() > 0:
				$jaw_pos.get_child(0).queue_free()
			$jaw_pos.add_child(_item)
		Item.FacePosition.CHEEK:
			if $cheek_pos.get_child_count() > 0:
				$cheek_pos.get_child(0).queue_free()
			$cheek_pos.add_child(_item)
		Item.FacePosition.NOSE:
			if $nose_pos.get_child_count() > 0:
				$nose_pos.get_child(0).queue_free()
			$nose_pos.add_child(_item)


func set_frame(_item : Item):
	if $item_frame.get_child_count() > 0:
		$item_frame.get_child(0).queue_free()
	$item_frame.add_child(_item)
	_item.scale = Vector2(frame_scale,frame_scale)
	_item.visible = true
	_item.position = Vector2.ZERO
	_item.position.x -= _item.get_child(0).position.x * frame_scale
	_item.position.y -= _item.get_child(0).position.y * frame_scale
	self.item = _item
