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

var _grace_timer : Timer
var _grace_time : bool = false

var controls_locked = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_gravity = default_gravity
var high_gravity = default_gravity * FALL_GRAVITY_MODIFIER
var low_gravity = default_gravity * HANG_TIME_GRAVITY_MODIFIER

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

func _physics_process(delta):
	if controls_locked:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y += current_gravity * delta
		
		#Clamp fall speed
		if velocity.y > _max_fall_speed:
			velocity.y = _max_fall_speed

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !_grace_timer.is_stopped()) and !_has_jumped:
		_has_jumped = true
		current_gravity = default_gravity
		velocity.y = JUMP_VELOCITY
		
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
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("strafe_left", "strafe_right")
	if direction:
		velocity.x += direction * _strafe_acc * delta
		if abs(velocity.x) > MAX_STRAFE_SPEED:
			velocity.x = direction / abs(direction) * MAX_STRAFE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, _strafe_acc * delta)

	move_and_slide()

func _on_grace_timer_finished():
	_grace_time = false

func _process(delta):
	
	if abs(velocity.x) > 0:
		if !$AnimatedSprite2D.flip_h and velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		elif $AnimatedSprite2D.flip_h and velocity.x > 0:
			$AnimatedSprite2D.flip_h = false
	
	if is_on_floor() and velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.play("Idle")
	elif is_on_floor() and abs(velocity.x) > 0:
		$AnimatedSprite2D.play("walk")
