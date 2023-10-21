extends ParallaxBackground

func revert_offset(_layer: ParallaxLayer) -> void:
	# Cancel out layer's offset. The layer's position already has 
	# its motion_scale applied.
	var ofs := scroll_offset - _layer.position
	if not scroll_ignore_camera_zoom:
		# When attention is given to the camera's zoom, we need to account for it.
		# We can use viewport's canvas transform scale to which the camera has
		# already applied its zoom.
		var canvas_scale = get_viewport().canvas_transform.get_scale()
		# This is taken from godot source: parallax_background.cpp
		# I don't know why it works.
		ofs /= canvas_scale.dot(Vector2(0.5, 0.5))
	_layer.motion_offset = ofs

func _ready() -> void:
	for _layer in get_children():
		if _layer is ParallaxLayer:
			revert_offset(_layer)
