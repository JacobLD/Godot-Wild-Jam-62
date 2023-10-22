class_name PlayerProps

var max_walk_speed
var walk_acc
var jump_velocity
var fall_gravity_mod
var max_fall_speed
var hang_time_threshold
var hang_time_mod
var grace_jump_time
var sprint_mod
var dash_speed

var cheek_item : Item
var nose_item : Item
var jaw_item : Item



func _init(player : PlayerController):
	max_walk_speed = player.MAX_WALK_SPEED
	walk_acc = player.WALK_ACC
	jump_velocity = player.JUMP_VELOCITY
	fall_gravity_mod = player.FALL_GRAVITY_MODIFIER
	max_fall_speed = player.MAX_FALL_SPEED_IN_MPS
	hang_time_threshold = player.HANG_TIME_THRESHOLD_SPEED
	hang_time_mod = player.HANG_TIME_GRAVITY_MODIFIER
	grace_jump_time = player.GRACE_JUMP_TIME
	sprint_mod = player.sprint_modifier
	dash_speed = player.DASH_SPEED
	
	cheek_item = player.get_item_at(Item.FacePosition.CHEEK).clone()
	cheek_item.visible = false
	
	nose_item = player.get_item_at(Item.FacePosition.NOSE).clone()
	nose_item.visible = false
	
	jaw_item = player.get_item_at(Item.FacePosition.JAW).clone()
	jaw_item.visible = false


func set_clone(clone : AIController):
	clone.MAX_WALK_SPEED = max_walk_speed
	clone.WALK_ACC = walk_acc
	clone.JUMP_VELOCITY = jump_velocity
	clone.FALL_GRAVITY_MODIFIER = fall_gravity_mod
	clone.MAX_FALL_SPEED_IN_MPS = max_fall_speed
	clone.HANG_TIME_THRESHOLD_SPEED = hang_time_threshold
	clone.HANG_TIME_GRAVITY_MODIFIER = hang_time_mod
	clone.GRACE_JUMP_TIME = grace_jump_time
	clone.sprint_modifier = sprint_mod
	clone.DASH_SPEED = dash_speed
	clone.init_values()
	
	clone.set_face_item(cheek_item)
	clone.set_face_item(nose_item)
	clone.set_face_item(jaw_item)
	
