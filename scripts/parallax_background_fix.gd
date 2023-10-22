extends ParallaxBackground

var level_time : float = 60
@export var front_cloud_dv : float = 100
@export var back_cloud_dv : float = 60
var timer : Timer = Timer.new()
@export var sky_start : NodePath
@export var sky_end : NodePath
var cloud_dark_threshold : float = 0.8

var timer_offset : float = 0
var time_added : float = 0

signal time_is_up

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
	add_child(timer)
	timer.timeout.connect(_timeout)
	timer.one_shot = true
	start_over(level_time)
	for _layer in get_children():
		if _layer is ParallaxLayer:
			revert_offset(_layer)

func _process(delta):
	$clouds_back/cloudsholder.position.x += back_cloud_dv * delta
	$clouds_front/cloudsholder.position.x += front_cloud_dv * delta
	if !timer.is_stopped():
		var path : Path2D = $sun_path
		var curve : Curve2D = path.curve
		var lerp_denom = lerp_denom()
		var distance_on_curve = lerp(curve.get_baked_length(), 0.0,  lerp_denom)
		
		$sun/SkySunOrb.position = curve.sample_baked(distance_on_curve)
		$sky_infinite_tile/skyholder.position.y = lerp(get_node(sky_start).position.y, get_node(sky_end).position.y, lerp_denom)
		
		if lerp_denom >= cloud_dark_threshold:
			$clouds_back/cloudsholder.modulate = lerp(Color(1,1,1,1), Color(0.2,0.2,0.2,1), (lerp_denom - 0.8)*5)
			$clouds_front/cloudsholder.modulate = lerp(Color(1,1,1,1), Color(0.2,0.2,0.2,1), (lerp_denom - 0.8)*5)

func start_over(new_level_time):
	timer_offset = 0.0
	level_time = new_level_time
	timer.start(level_time)
	print(level_time)


func _timeout():
	time_is_up.emit()


func add_time(amount):
	var time_passed = timer.wait_time - timer.time_left
	timer_offset =  time_passed / timer.wait_time
	timer.start(timer.time_left + amount)


func lerp_denom():
	return ((timer.wait_time - timer.time_left) * (1-timer_offset) / (timer.wait_time))  + timer_offset
