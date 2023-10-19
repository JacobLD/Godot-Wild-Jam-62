extends CharacterBody2D
class_name PlayerController

@export var MAX_STRAFE_SPEED = 600
@export var STRAFE_ACC = 50
@export var JUMP_VELOCITY = 1600

@export var FALL_GRAVITY_MODIFIER = 3.0
@export var MAX_FALL_SPEED_IN_MPS = 50.0

@export var HANG_TIME_THRESHOLD_SPEED = 25
@export var HANG_TIME_GRAVITY_MODIFIER = 0.5

@export var GRACE_JUMP_TIME = 0.25

var _max_fall_speed = MAX_FALL_SPEED_IN_MPS * 100
var _strafe_acc = STRAFE_ACC * 100

var _has_jumped : bool = false
var _just_jumped : bool = false

var _grace_timer : Timer
var _grace_time : bool = false

var controls_locked = false
var _blocking = false
@export var attacking = false
var _walking = false

var state : PlayerController.State = State.IDLING
var last_state : PlayerController.State = State.IDLING

var animationTree : AnimationTree

var cheek_item : Item = null
var nose_item : Item = null
var jaw_item : Item = null

enum State {
	WALKING,
	ATTACKING,
	BLOCKING,
	IDLING,
	JUMP,
	JUMP_ATTACKING,
	JUMP_BLOCK,
	RISING,
	FALLING
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var default_gravity = 2000
var current_gravity = default_gravity
var high_gravity = default_gravity * FALL_GRAVITY_MODIFIER
var low_gravity = default_gravity * HANG_TIME_GRAVITY_MODIFIER

var _last_floor_type : SFXPlayer.FloorType = SFXPlayer.FloorType.ROCK

var _input_controller : InputController

func _ready():
	_grace_timer = $JumpGraceTimer
	_grace_timer.wait_time = GRACE_JUMP_TIME
	_grace_timer.timeout.connect(_on_grace_timer_finished)
	
	#adjust for 100pix in a meter
	_max_fall_speed = MAX_FALL_SPEED_IN_MPS * 100
	_strafe_acc = STRAFE_ACC * 100
	
	current_gravity = default_gravity
	high_gravity = default_gravity * FALL_GRAVITY_MODIFIER
	low_gravity = default_gravity * HANG_TIME_GRAVITY_MODIFIER
	
	GameManager.registerPlayer(self)
	animationTree = $AnimationTree
	
	_input_controller = $InputController

func _physics_process(delta):
	# Do jank Camera Smoothing
	$Camera2D.position_smoothing_speed = max(abs(velocity.length() * delta / 3),5)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += current_gravity * delta
		#Clamp fall speed
		if velocity.y > _max_fall_speed:
			velocity.y = _max_fall_speed

	_handle_input(delta)
	move_and_slide()
	_decide_player_state()
	_apply_state()


func _handle_input(delta):
	#Flip sprite depending on input direction
	var direction = _input_controller.input_direction()
	if abs(direction) > 0:
		if !$Sprite2D.flip_h and direction < 0:
			$Sprite2D.flip_h = true
			$face.scale.x = -1
		elif $Sprite2D.flip_h and direction > 0:
			$Sprite2D.flip_h = false
			$face.scale.x = 1
	
	# Handle Jump.
	if _input_controller.jump_just_pressed() and (is_on_floor() or !_grace_timer.is_stopped()) and !_has_jumped and state != State.ATTACKING and state != State.BLOCKING:
		_has_jumped = true
		_just_jumped = true
		_walking = false
		current_gravity = default_gravity
		velocity.y = -JUMP_VELOCITY
		$sfx_player.on_jump()
		
	# We Hit the floor after falling
	elif _has_jumped and is_on_floor() and velocity.y == 0:
		_has_jumped = false
		current_gravity = default_gravity

	# Handle The Fall
	if (!_input_controller.jump_pressed() or !_has_jumped) and !is_on_floor():
		current_gravity = high_gravity
	
	# Handle Hang time gravity
	if !is_on_floor() and abs(velocity.y) < HANG_TIME_THRESHOLD_SPEED and _has_jumped:
		current_gravity = low_gravity
	elif current_gravity != high_gravity:
		current_gravity = default_gravity
	
	# Start Grace timer when falling off ground
	if _grace_timer.is_stopped() and !is_on_floor() and !_has_jumped:
		_grace_time = true
		_grace_timer.start()
	
	# Get the input direction and handle the movement/deceleration.
	if direction and !_blocking and !controls_locked:
		if is_on_floor():
			_walking = true
		velocity.x += direction * _strafe_acc * delta
		if abs(velocity.x) > MAX_STRAFE_SPEED:
			velocity.x = direction / abs(direction) * MAX_STRAFE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, _strafe_acc * delta)
		_walking = false

func _apply_state():
	animationTree["parameters/conditions/is_idle"] = state == State.IDLING
	animationTree["parameters/conditions/is_walking"] = state == State.WALKING
	animationTree["parameters/conditions/has_jumped"] = state == State.JUMP
	animationTree["parameters/conditions/is_rising"] = state == State.RISING
	animationTree["parameters/conditions/is_falling"] = state == State.FALLING
	animationTree["parameters/conditions/attacking"] = state == State.ATTACKING
	animationTree["parameters/conditions/blocking"] = state == State.BLOCKING
	animationTree["parameters/conditions/jump_attacking"] = state == State.JUMP_ATTACKING
	animationTree["parameters/conditions/jump_blocking"] = state == State.JUMP_BLOCK
	
	if last_state != state:
		if state == State.BLOCKING and last_state != State.JUMP_BLOCK or state == State.JUMP_BLOCK and last_state != State.BLOCKING: # To prevent double blocking sounds
			$sfx_player.on_block()
		print("Trans to ", State.keys()[state])
	last_state = state


func _on_grace_timer_finished():
	_grace_time = false

func _decide_player_state():
	
	if _input_controller.attack_just_pressed():
		if is_on_floor():
			state = State.ATTACKING
		else:
			state = State.JUMP_ATTACKING
		return
	
	if _input_controller.block_pressed():
		_blocking = true
		if is_on_floor():
			state = State.BLOCKING
		else:
			state = State.JUMP_BLOCK
		return
	else:
		_blocking = false
	
	if is_on_floor() and velocity.x == 0 and velocity.y == 0:
		state = State.IDLING
	
	if is_on_floor() and _walking:
		state = State.WALKING
	
	if _just_jumped:
		_just_jumped = false
		state = State.JUMP
	elif  !is_on_floor() and velocity.y < 0:
		state = State.RISING
	elif !is_on_floor() and velocity.y > 0:
		state = State.FALLING


func on_footstep():
	if is_on_floor():
		var raycast : RayCast2D = $FloorRayCast
		if raycast.get_collider() is Ground:
			_last_floor_type = raycast.get_collider().type
			$sfx_player.on_footstep(raycast.get_collider().type)
			return
			
	if is_on_floor():
		$sfx_player.on_footstep(_last_floor_type)


func set_face_item(item : Item) -> void:
	match item.face_position:
		item.FacePosition.CHEEK:
			cheek_item = item
			_set_face_item($face/cheek_pos, item)
		item.FacePosition.NOSE:
			nose_item = item
			_set_face_item($face/nose_pos, item)
		item.FacePosition.JAW:
			jaw_item = item
			_set_face_item($face/jaw_pos, item)

func _set_face_item(face_node : Node2D, item : Item) -> void:
	item.scale = Vector2(0.25, 0.25)
	if face_node.get_child_count() > 0:
		face_node.get_child(0).queue_free()
	
	face_node.add_child(item)
	item.position = Vector2.ZERO

func get_item_at(pos : Item.FacePosition) -> Item:
	match pos:
		Item.FacePosition.JAW:
			if $face/jaw_pos.get_child_count() > 0:
				return $face/jaw_pos.get_child(0)
		Item.FacePosition.CHEEK:
			if $face/cheek_pos.get_child_count() > 0:
				return $face/cheek_pos.get_child(0)
		Item.FacePosition.NOSE:
			if $face/nose_pos.get_child_count() > 0:
				return $face/nose_pos.get_child(0)
	return null
