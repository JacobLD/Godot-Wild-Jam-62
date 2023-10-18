extends Sprite2D
class_name Item

enum FacePosition {
	CHEEK,
	NOSE,
	JAW
}

enum Type {
	ACTIVE,
	PASSIVE
}

@export var face_position : FacePosition
@export var description = "What does this item do?"
@export var type : Type


func clone() -> Item:
	var _clone : Item = self.duplicate()
	_clone.type = self.type
	_clone.description = self.description
	_clone.face_position = self.face_position
	
	return _clone
