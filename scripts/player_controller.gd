extends CharacterBody2D
class_name PlayerController

@export var MAX_STRAFE_SPEED = 600
@export var STRAFE_ACC = 1
@export var JUMP_VELOCITY = 0

@export var MAX_FALL_VELOCITY = 50
@export var FALL_GRAVITY_MODIFIER = 3.0
@export var MAX_FALL_SPEED_IN_MPS = 50.0

@export var HANG_TIME_THRESHOLD_SPEED = 500
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
@export var walking_complete = true

var state : PlayerController.State = State.IDLING
var last_state : PlayerController.State = State.IDLING

var animationTree : AnimationTree

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

func _ready():
	_grace_timer = Timer.new()
	_grace_timer.one_shot = true
	_grace_timer.timeout.connect(_on_grace_timer_finished)
	add_child(_grace_timer)
	_grace_timer.wait_time = GRACE_JUMP_TIME
	_max_fall_speed = MAX_FALL_SPEED_IN_MPS * 100
	_strafe_acc = STRAFE_ACC * 100
	default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	current_gravity = default_gravity
	high_gravity = default_gravity * FALL_GRAVITY_MODIFIER
	low_gravity = default_gravity * HANG_TIME_GRAVITY_MODIFIER
	
	GameManager.registerPlayer(self)
	animationTree = $AnimationTree

func _physics_process(delta):
	# Do jank Camera Smoothing
	$Camera2D.position_smoothing_speed = abs(velocity.length() * delta)
	print(velocity.length() * delta / 3)
	
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
	var direction = Input.get_axis("strafe_left", "strafe_right")
	if abs(direction) > 0:
		if !$AnimatedSprite2D.flip_h and direction < 0:
			$AnimatedSprite2D.flip_h = true
		elif $AnimatedSprite2D.flip_h and direction > 0:
			$AnimatedSprite2D.flip_h = false
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !_grace_timer.is_stopped()) and !_has_jumped and state != State.ATTACKING and state != State.BLOCKING:
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
	if (!Input.is_action_pressed("jump") or !_has_jumped) and !is_on_floor():
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
		if state == State.ATTACKING or state == State.JUMP_ATTACKING:
			$sfx_player.on_swing()
		if state == State.BLOCKING and last_state != State.JUMP_BLOCK or state == State.JUMP_BLOCK and last_state != State.BLOCKING: # To prevent double blocking sounds
			$sfx_player.on_block()
		print("Trans to ", State.keys()[state])
	last_state = state


func _on_grace_timer_finished():
	_grace_time = false

func _decide_player_state():	
	if attacking:
		return
	
	if Input.is_action_just_pressed("attack"):
		attacking = true
		
		if is_on_floor():
			state = State.ATTACKING
		else:
			state = State.JUMP_ATTACKING
		return
	
	if Input.is_action_pressed("block"):
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
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var ground_object = collision.get_collider()
			if ground_object is Ground:
				_last_floor_type = ground_object.type
				$sfx_player.on_footstep(ground_object.type)
				return
			
	if is_on_floor():
		$sfx_player.on_footstep(_last_floor_type)
	


# The collider being null is causing the above sounds to fail - we need to find a better way of finding the floor object!!


