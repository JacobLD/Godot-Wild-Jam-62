extends Sprite2D
class_name Item

enum FacePosition {
	CHEEK,
	NOSE,
	JAW
}

enum Type {
	ACTIVE,
	PASSIVE,
	STATS
}

@export var face_position : FacePosition
@export var description = "What does this item do?"
@export var type : Type
@export var item_name : String = "Unnamed"


@export var strength_mod : int = 1
@export var agility_mod : int = 1
@export var wisdom_mod : int = 1

@export var use_cooldown : float = 2

func clone() -> Item:
	var _clone : Item = self.duplicate()
	_clone.type = self.type
	_clone.description = self.description
	_clone.face_position = self.face_position
	
	return _clone


func get_type_text() -> String:
	match face_position:
		Item.FacePosition.JAW:
			return "Passive"
		Item.FacePosition.CHEEK:
			return "Active"
		Item.FacePosition.NOSE:
			return "Stat Boost" 
	return "null"

func get_face_position_text() -> String:
	match face_position:
		Item.FacePosition.JAW:
			return "Jaw"
		Item.FacePosition.CHEEK:
			return "Cheek"
		Item.FacePosition.NOSE:
			return "Nose"
	return "null"


func _start_cooldown_timer(wait_time : float, player : PlayerController) -> SceneTreeTimer:
	var converted_wait_time = wait_time - wait_time * (player.wis * 0.02)
	print(converted_wait_time)
	var timer = get_tree().create_timer(converted_wait_time)
	timer.timeout.connect(_on_timeout)
	return timer

func _on_timeout():
	pass
