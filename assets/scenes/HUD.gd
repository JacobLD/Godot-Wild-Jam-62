extends CanvasLayer

var _passive : Item
var _active : Item
var _stats : Item

var frame_scale = 0.4

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.player_item_set.connect(on_player_item_set)


func on_player_item_set(item : Item):
	match item.face_position:
		Item.FacePosition.JAW:
			_passive = item.clone()
			_set_item_at($passive, _passive)
		Item.FacePosition.CHEEK:
			_active = item.clone()
			_set_item_at($active, _active)
		item.FacePosition.NOSE:
			_stats = item.clone()
			_set_item_at($stats, _stats)


func _set_item_at(child : Node2D, local_item : Item):
	if child.get_child_count() > 0:
		child.get_child(0).queue_free()
	child.add_child(local_item)
	local_item.visible = true
	local_item.scale = Vector2.ONE * frame_scale
	local_item.position.x -= local_item.get_child(0).position.x * frame_scale
	local_item.position.y -= local_item.get_child(0).position.y * frame_scale
	

func _on_mouse_exit():
	print("exit")
	$mouse_dialog.on_hide()


func _on_stats_hover_trigger_mouse_entered():
	print("stats")
	$mouse_dialog.on_show_single_item_details(_stats)


func _on_active_hover_trigger_mouse_entered():
	print("active")
	$mouse_dialog.on_show_single_item_details(_active)


func _on_passive_hover_trigger_mouse_entered():
	print("passove")
	$mouse_dialog.on_show_single_item_details(_passive)
