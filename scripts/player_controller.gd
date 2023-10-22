extends CharacterBody2D
class_name PlayerController

@export var MAX_WALK_SPEED = 600
@export var WALK_ACC = 50
@export var JUMP_VELOCITY = 1600

@export var FALL_GRAVITY_MODIFIER = 3.0
@export var MAX_FALL_SPEED_IN_MPS = 50.0

@export var HANG_TIME_THRESHOLD_SPEED = 25
@export var HANG_TIME_GRAVITY_MODIFIER = 0.5

@export var GRACE_JUMP_TIME = 0.25

@export var sprint_modifier = 2.0

@export var DASH_SPEED = 2400

var _max_fall_speed = MAX_FALL_SPEED_IN_MPS * 100
var _walk_acc = WALK_ACC * 100

var _has_jumped : bool = false
var _just_jumped : bool = false

var _grace_timer : Timer
var _grace_time : bool = false

var controls_locked = false
var _blocking = false
var _walking = false
var _running = false
var dashing = false

var state : PlayerController.State = State.IDLING
var last_state : PlayerController.State = State.IDLING

var animationTree : AnimationTree

var cheek_item : Item = null
var nose_item : Item = null
var jaw_item : Item = null

var health : float = 100
var max_health : float = 100
var str = 0
var agi = 0
var wis = 0
var str_mult = 1
var wis_mult = 1
var agi_mult = 1
var speed_percent_per_agi = 0.02
var jump_percent_per_agi = 0.02
signal died
signal health_total_changed(new_value, current_hp)
signal current_health_changed(new_value)
signal active_on_cooldown()
signal active_off_cooldown()
var can_use_active : bool = true
var damage = 0

var i_frame_time : float = 0.2
var dodge_chance = 0

var _current_direction = 1

enum State {
	WALKING,
	ATTACKING,
	BLOCKING,
	IDLING,
	JUMP,
	JUMP_ATTACKING,
	JUMP_BLOCK,
	RISING,
	FALLING,
	RUNNING,
	DASHING
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var default_gravity = 2000
var current_gravity = default_gravity
var high_gravity = default_gravity * FALL_GRAVITY_MODIFIER
var low_gravity = default_gravity * HANG_TIME_GRAVITY_MODIFIER

var _last_floor_type : SFXPlayer.FloorType = SFXPlayer.FloorType.ROCK

var _input_controller : InputController

@export var is_player_and_not_clone : bool = false

var done_dying = true

func _ready():
	if is_player_and_not_clone:
		init_values()
		GameManager.registerPlayer(self)
	animationTree = $AnimationTree
	_input_controller = $InputController

func init_values():
	_grace_timer = $JumpGraceTimer
	_grace_timer.wait_time = GRACE_JUMP_TIME
	_grace_timer.timeout.connect(_on_grace_timer_finished)
	
	#adjust for 100pix in a meter
	_max_fall_speed = MAX_FALL_SPEED_IN_MPS * 100
	_walk_acc = WALK_ACC * 100
	
	current_gravity = default_gravity
	high_gravity = default_gravity * FALL_GRAVITY_MODIFIER
	low_gravity = default_gravity * HANG_TIME_GRAVITY_MODIFIER

func _physics_process(delta):
	# Do jank Camera Smoothing
	if is_player_and_not_clone:
		$Camera2D.position_smoothing_speed = max(abs(velocity.length() * delta / 3),5)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += current_gravity * delta
		#Clamp fall speed
		if velocity.y > _max_fall_speed:
			velocity.y = _max_fall_speed
	
	if dashing:
		velocity.y = 0

	_handle_input(delta)
	move_and_slide()
	_decide_player_state()
	_apply_state()

func _process(delta):
	var direction = _input_controller.input_direction()
	if abs(direction) > 0 and !controls_locked:
		if direction != _current_direction:
			_current_direction = direction
			apply_scale(Vector2(-1, 1))


func _handle_input(delta):
	#Flip player depending on input direction
	var direction = _input_controller.input_direction()
	
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
			if dashing:
				velocity.x = direction * DASH_SPEED
			elif !_input_controller.walk_is_pressed():
				_running = true
				_walking = false
				velocity.x += direction * _walk_acc * delta * sprint_modifier
				if abs(velocity.x) > MAX_WALK_SPEED * sprint_modifier:
					velocity.x = move_toward(velocity.x, 0, _walk_acc * sprint_modifier * 1.6 * delta)
			else:
				_walking = true
				_running = false
				velocity.x += direction * _walk_acc * delta
				if abs(velocity.x) > MAX_WALK_SPEED:
					velocity.x = move_toward(velocity.x, MAX_WALK_SPEED, _walk_acc * sprint_modifier * 1.5 * delta)
		else:
			if dashing:
				velocity.x = direction * DASH_SPEED
			else:
				velocity.x += direction * _walk_acc * delta * sprint_modifier
				if abs(velocity.x) > MAX_WALK_SPEED* sprint_modifier:
					velocity.x = move_toward(velocity.x, MAX_WALK_SPEED, _walk_acc * sprint_modifier * 1.5 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, _walk_acc * delta)
		_walking = false
		_running = false
	
	if _input_controller.active_just_pressed() and can_use_active:
		_on_active_pressed()

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
	animationTree["parameters/conditions/run"] = state == State.RUNNING
	animationTree["parameters/conditions/dash"] = state == State.DASHING
	
	if last_state != state:
		if state == State.BLOCKING and last_state != State.JUMP_BLOCK or state == State.JUMP_BLOCK and last_state != State.BLOCKING: # To prevent double blocking sounds
			$sfx_player.on_block()
		
		if state == State.DASHING and last_state != State.DASHING:
			$sfx_player.on_dash()
			
		#print("Trans to ", State.keys()[state])
	last_state = state


func _on_grace_timer_finished():
	_grace_time = false

func _decide_player_state():
	
	if dashing:
		state = State.DASHING
		return
	
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
	
	if is_on_floor():
		if _walking:
			state = State.WALKING
		if _running:
			state = State.RUNNING
	
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
			set_agi(item.agility_mod)
			set_str(item.strength_mod)
			set_wis(item.wisdom_mod)
			_set_face_item($face/nose_pos, item)
		item.FacePosition.JAW:
			jaw_item = item
			var children = $face/jaw_pos.get_children()
			if children.size() > 0:
				children[0].on_remove(self)
			_set_face_item($face/jaw_pos, item)
			item.on_add(self)

func _set_face_item(face_node : Node2D, item : Item) -> void:
	item.scale = Vector2(0.25, 0.25)
	if face_node.get_child_count() > 0:
		face_node.get_child(0).queue_free()
	
	if item.get_parent() == null:
		face_node.add_child(item)
	else:
		item.reparent(face_node)
	
	item.position = Vector2.ZERO
	item.visible = true

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


func _on_active_pressed():
	can_use_active = false
	active_on_cooldown.emit()
	cheek_item.on_active(self).timeout.connect(_on_active_timer)


func on_attack():
	$attack_box.attack(damage)


# Max hp = 100 + str * 8
# dmg = 10 + str * 3
func set_str(new_value : int):
	new_value = new_value * str_mult
	var old_health = max_health
	max_health = 100 + new_value * 8
	health += max_health - old_health
	health_total_changed.emit(max_health, health)
	
	damage = 10 + new_value * 3


func add_health(amount : float):
	print("Health change: ", amount)
	health += amount
	print("New health" , health)
	if health > max_health:
		health = max_health
	if health < 0:
		health = 0
	
	if health == 0:
		on_death()
		#do something here
	
	current_health_changed.emit(health)


func set_agi(new_value : int):
	new_value = new_value * agi_mult
	agi = new_value

# Reduces active cooldown
func set_wis(new_value : int):
	new_value = new_value * wis_mult
	wis = new_value

func _on_active_timer():
	can_use_active = true
	active_off_cooldown.emit()


func on_take_damage(amount, source):
	
	if randf() < dodge_chance:
		$sfx_player.on_dodge()
		return
	
	if _blocking and state != State.ATTACKING:
		$sfx_player.on_parry()
	else:
		$sfx_player.on_damage()
		add_health(-amount)
	
	var dv_hit = 1600 + source.str_mult * 100
	
	if source.global_position.x > global_position.x:
		velocity.x -= dv_hit
	else:
		velocity.x += dv_hit


func on_death():
	var death_animation_time = 1.0
	$AnimationTree.active = false
	controls_locked = true
	if !is_player_and_not_clone:
		#play animation
		get_tree().create_timer(death_animation_time).timeout.connect(_on_death_complete_clone)
	else:
		#play animation
		get_tree().create_timer(death_animation_time).timeout.connect(_on_death_complete_player)
	

func respawn(respawn_point : Node2D):
	$AnimationTree.active = true
	controls_locked = false
	add_health(max_health)
	global_position = respawn_point.global_position

func _on_death_complete_player():
	died.emit()

func _on_death_complete_clone():
	died.emit()
	queue_free()
