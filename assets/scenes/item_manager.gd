extends Node

@export var starter_nose : NodePath
@export var starter_jaw : NodePath
@export var starter_cheek : NodePath

@export var common_cheek : Array[NodePath]
@export var uncommon_cheek : Array[NodePath]
@export var rare_cheek : Array[NodePath]

@export var common_nose : Array[NodePath]
@export var uncommon_nose : Array[NodePath]
@export var rare_nose : Array[NodePath]

@export var common_jaw : Array[NodePath]
@export var uncommon_jaw : Array[NodePath]
@export var rare_jaw : Array[NodePath]


enum Rarity {
	Common,
	Uncommon,
	Rare
}


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
	
	while children.size() > 0:
		var rand_index = randi() % children.size()
		var bad_pick = false
		for i in range(items.size()):
			if items[i].name == children[rand_index].name:
				bad_pick = true
				break
		
		if bad_pick:
			children.remove_at(rand_index)
		else:
			return children[rand_index].clone()
			
	return null

func get_item_exclude(face_pos : Item.FacePosition, exclude_item : Item, rarity : Rarity) -> Item:
	var item_to_return = null
	while item_to_return == null:
		var temp_item = get_clone_of(rarity, face_pos)
		if temp_item.item_name != exclude_item.item_name:
			item_to_return = temp_item
	
	return item_to_return

func get_random_but_exclude(items : Array, type : Item.FacePosition) -> Item:
	match type:
		Item.FacePosition.JAW:
			return _get_random_item_eclude($jaw, items)
		Item.FacePosition.NOSE:
			return _get_random_item_eclude($nose, items)
		Item.FacePosition.CHEEK:
			return _get_random_item_eclude($cheek, items)
	
	return null

func _get_clone_from(predefined_paths : Array[NodePath]):
	var rand_path : NodePath = predefined_paths.pick_random()
	return get_node(rand_path).clone()
	

func get_clone_of(rarity : Rarity, type : Item.FacePosition):
	match rarity:
		Rarity.Common:
			match type:
				Item.FacePosition.JAW:
					return _get_clone_from(common_jaw)
				Item.FacePosition.CHEEK:
					return _get_clone_from(common_cheek)
				Item.FacePosition.NOSE:
					return _get_clone_from(common_nose)
		Rarity.Uncommon:
			match type:
				Item.FacePosition.JAW:
					return _get_clone_from(uncommon_jaw)
				Item.FacePosition.CHEEK:
					return _get_clone_from(uncommon_cheek)
				Item.FacePosition.NOSE:
					return _get_clone_from(uncommon_nose)
		Rarity.Rare:
			match type:
				Item.FacePosition.JAW:
					return _get_clone_from(rare_jaw)
				Item.FacePosition.CHEEK:
					return _get_clone_from(rare_cheek)
				Item.FacePosition.NOSE:
					return _get_clone_from(rare_nose)


func get_starter_nose_clone():
	return get_node(starter_nose).clone()

func get_starter_jaw_clone():
	return get_node(starter_jaw).clone()

func get_starter_cheek_clone():
	return get_node(starter_cheek).clone()
