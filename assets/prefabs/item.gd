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
	var clone : Item = self.duplicate()
	clone.type = self.type
	clone.description = self.description
	clone.face_position = self.face_position
	
	return clone
