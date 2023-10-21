extends NinePatchRect
class_name StatsDialog

func set_item(item : Item):
	$MarginContainer/VBoxContainer/ItemNameLabel.text = item.item_name
	$MarginContainer/VBoxContainer/HBoxContainer2/FacePositionValue.text = item.get_face_position_text()
	$MarginContainer/VBoxContainer/HBoxContainer3/StrValue.text = str(item.strength_mod)
	$MarginContainer/VBoxContainer/HBoxContainer4/AgiValue.text = str(item.agility_mod)
	$MarginContainer/VBoxContainer/HBoxContainer5/WisValue.text = str(item.wisdom_mod)
