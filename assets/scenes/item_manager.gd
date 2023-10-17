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

func _get_random_item_eclude(child : Node, items : Array) -> Item:
	var children : Array = child.get_children()
	var remove_index = []
	
	while children.size() > 0:
		var rand_index = randi() % children.size()
		var bad_pick = false
		for i in range(items.size()):
			if items[i].name == children[rand_index].name:
				bad_pick == true
				break
		
		if bad_pick:
			children.remove_at(rand_index)
		else:
			return children[rand_index].clone()
			
	return null

func get_random_but_exclude(items : Array, type : Item.FacePosition) -> Item:
	match type:
		Item.FacePosition.JAW:
			return _get_random_item_eclude($jaw, items)
		Item.FacePosition.NOSE:
			return _get_random_item_eclude($nose, items)
		Item.FacePosition.CHEEK:
			return _get_random_item_eclude($cheek, items)
	
	return null
