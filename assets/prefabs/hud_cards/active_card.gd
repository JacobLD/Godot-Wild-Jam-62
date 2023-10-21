extends NinePatchRect
class_name ActiveDialog

func set_item(item : Item):
	$MarginContainer/VBoxContainer/ItemNameLabel.text = item.item_name
	$MarginContainer/VBoxContainer/HBoxContainer2/FacePositionValue.text = item.get_face_position_text()
	$MarginContainer/VBoxContainer/Description.text = item.description

