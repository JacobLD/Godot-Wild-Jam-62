extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	on_hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position = get_global_mouse_position()


func on_show_single_item_details(item : Item):
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	match item.type:
		Item.Type.ACTIVE:
			$Active.set_item(item)
			$Active.visible = true
		Item.Type.PASSIVE:
			$Passive.set_item(item)
			$Passive.visible = true
		Item.Type.STATS:
			$Stats.set_item(item)
			$Stats.visible = true


func on_show_compare_item_details(equiped : Item, compare : Item):
	$Compare.set_items(equiped, compare)
	$Compare.visible = true


func on_hide():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Active.visible = false
	$Stats.visible = false
	$Passive.visible = false
	$Compare.visible = false
