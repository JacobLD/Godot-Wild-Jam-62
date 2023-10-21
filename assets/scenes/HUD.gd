extends CanvasLayer

var _passive : Item
var _active : Item
var _stats : Item

var frame_scale = 0.4
var _px_per_hp = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.player_item_set.connect(on_player_item_set)
	GameManager.player_registered.connect(_on_player_registered)


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


func _on_player_registered(player : PlayerController):
	player.health_total_changed.connect(_on_player_max_hp_change)
	player.current_health_changed.connect(_on_player_hp_change)
	player.active_off_cooldown.connect(_active_off_cooldown)
	player.active_on_cooldown.connect(_active_on_cooldown)


func _on_player_max_hp_change(new_max):
	$Health_Bar_Background.size.x = new_max * _px_per_hp

func _on_player_hp_change(current_hp):
	$Health_Bar_Current.size.x = current_hp * _px_per_hp
	$Label.text = str(current_hp)

func _active_on_cooldown():
	$active.modulate = Color(1,1,1,0.4)


func _active_off_cooldown():
	$active.modulate = Color(1,1,1,1)


func show_compare(equiped, compare):
	$mouse_dialog.on_show_compare_item_details(equiped, compare)

func hide_compare():
	$mouse_dialog.on_hide()
