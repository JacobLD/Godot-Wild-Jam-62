extends NinePatchRect


func set_items(new : Item, old : Item):
	var type : Item.Type
	
	match type:
		Item.Type.ACTIVE:
			$MarginContainer/VBoxContainer/HBoxContainer/ActiveDialogNew.set_item(new)
			$MarginContainer/VBoxContainer/HBoxContainer/ActiveDialogOld.set_item(old)
		Item.Type.PASSIVE:
			$MarginContainer/VBoxContainer/HBoxContainer/PassiveDialogNew.set_item(new)
			$MarginContainer/VBoxContainer/HBoxContainer/PassiveDialogOld.set_item(old)
		Item.Type.STATS:
			$MarginContainer/VBoxContainer/HBoxContainer/StatsDialogNew.set_item(new)
			$MarginContainer/VBoxContainer/HBoxContainer/StatsDialogOld.set_item(old)
	
	$MarginContainer/VBoxContainer/HBoxContainer/ActiveDialogNew.visible = type == Item.Type.ACTIVE
	$MarginContainer/VBoxContainer/HBoxContainer/ActiveDialogOld.visible = type == Item.Type.ACTIVE
	$MarginContainer/VBoxContainer/HBoxContainer/PassiveDialogNew.visible = type == Item.Type.PASSIVE
	$MarginContainer/VBoxContainer/HBoxContainer/PassiveDialogOld.visible = type == Item.Type.PASSIVE
	$MarginContainer/VBoxContainer/HBoxContainer/StatsDialogNew.visible = type == Item.Type.STATS
	$MarginContainer/VBoxContainer/HBoxContainer/StatsDialogOld.visible  = type == Item.Type.STATS
