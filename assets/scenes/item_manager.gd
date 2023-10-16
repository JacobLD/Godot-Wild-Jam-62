extends Node
class_name ItemManager

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.registerItemManager(self)


func get_random_cheek() -> Item:
	return _get_random_item($cheek)


func get_random_nose() -> Item:
	return _get_random_item($nose)


func get_random_jaw() -> Item:
	return _get_random_item($jaw)


func _get_random_item(child) -> Item:
	var children : Array = child.get_children()
	var rand_item : Item = children.pick_random()
	return rand_item.clone()
