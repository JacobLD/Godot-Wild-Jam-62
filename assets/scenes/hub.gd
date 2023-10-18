extends Node2D
class_name HubZone

var item_taken : bool = false
var items_visible : bool = false

var item_1 : Item = null
var item_2 : Item = null

func _ready():
	var test_timer : Timer = Timer.new()
	add_child(test_timer)
	test_timer.one_shot = true
	test_timer.timeout.connect(assign_items)
	test_timer.start(1)


func _process(delta):
	if !items_visible or item_taken:
		return
	
	if Input.is_action_just_pressed("take_left"):
		pass
	elif Input.is_action_just_pressed("take_right"):
		pass

func assign_items():
	
	var positions = [Item.FacePosition.CHEEK, Item.FacePosition.JAW, Item.FacePosition.NOSE]
	var rand_index : int = randi() % positions.size()
	var constant : Item.FacePosition = positions[rand_index]
	positions.remove_at(rand_index)
	
	var player_item_1 = GameManager.getPlayer().get_item_at(positions[0])
	item_1 = _get_new_item_knowing(player_item_1, positions[0])
	
	var player_item_2 = GameManager.getPlayer().get_item_at(positions[1])
	item_2 = _get_new_item_knowing(player_item_2, positions[1])
	
	var player_item_3_constant = GameManager.getPlayer().get_item_at(constant)
	
	_assign_portrait_items(item_1.clone(), player_item_2.clone(), player_item_3_constant.clone(), $ParallaxBackground/Tree/Portraits/Frame)
	_assign_portrait_items(item_2.clone(), player_item_1.clone(), player_item_3_constant.clone(), $ParallaxBackground/Tree/Portraits/Frame2)


func _get_new_item_knowing(player_item : Item, face_pos : Item.FacePosition) -> Item:
	var exclusions : Array = []
	if player_item:
		exclusions.push_front(player_item)
	
	return ItemManager.get_random_but_exclude(exclusions, face_pos)

func _assign_portrait_items(item_changing : Item, same1 : Item, same2 : Item, portrait : Portrait):
	portrait.set_frame(item_changing.clone())
	portrait.set_item(item_changing)
	portrait.set_item(same1)
	portrait.set_item(same2)


func _on_portrait_trigger_body_entered(body):
	if body is PlayerController and !item_taken:
		$AnimationPlayer.play("fade_in_portraits")
		items_visible = true


func _on_portrait_trigger_body_exited(body):
	if body is PlayerController and !item_taken:
		$AnimationPlayer.play("fade_out_portraits")
		items_visible = false
