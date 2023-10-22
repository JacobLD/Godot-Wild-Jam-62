extends Node2D

@export var input_controller_path : NodePath
@export var combat_animation_path : NodePath
var input_controller : AIInputController

func _ready():
	input_controller = get_node(input_controller_path)


func tick(AI : AIController):
	if !AI.player_in_zone:
		patrol_points(AI)
	else:
		attack_player(AI)


var in_range : bool = false
var _attack_range : float = 200
var attack_range_squared : float = _attack_range * _attack_range
var combat_option_delay_min : float = 0.8
var combat_option_delay_max : float = 1.2
var can_combat : bool = true

var block_time : float = 1

var block_percentage = .2
enum combat_options {
	attack,
	block
}

func attack_player(AI : AIController):
	input_controller.wants_to_walk = false
	var player_pos : Vector2 = GameManager.getPlayer().global_position
	var distance_to_player_squared = AI.global_position.distance_squared_to(player_pos)
	
	in_range =  distance_to_player_squared < attack_range_squared
	if !in_range:
		input_controller.input_dir = get_move_direction(AI, player_pos)
	else:
		input_controller.input_dir = 0
		if !can_combat:
			return
		input_controller.wants_to_attack = false
		input_controller.blocking = false
		if randf() < block_percentage:
			input_controller.blocking = true
			get_tree().create_timer(block_time).timeout.connect(block_timer)
			get_tree().create_timer(randf_range(combat_option_delay_min, combat_option_delay_max)).timeout.connect(combat_option_cooldown_timeout)
		else:
			queue_attack()
		can_combat = false

func block_timer():
	input_controller.blocking = false

func swing_timer():
	input_controller.wants_to_attack = false

func combat_option_cooldown_timeout():
	can_combat = true

func queue_attack():
	var anim : AnimationPlayer = get_node(combat_animation_path)
	anim.play("about_to_attack")
	get_tree().create_timer(0.4).timeout.connect(do_attack)

func do_attack():
	input_controller.wants_to_attack = true
	get_tree().create_timer(0.1).timeout.connect(swing_timer)
	get_tree().create_timer(randf_range(combat_option_delay_min, combat_option_delay_max)).timeout.connect(combat_option_cooldown_timeout)


var target_point = null
var patrol_waiting : bool = false
var orig_direction : int = 0
var patrol_wait_time_min : float = 1
var patrol_wait_time_max : float = 3
func patrol_points(AI : AIController):
	input_controller.wants_to_walk = true
	if patrol_waiting:
		input_controller.input_dir = 0
		return
	
	if target_point == null:
		var rand_point_path = AI.patrol_points.pick_random()
		target_point = AI.get_node(rand_point_path)
		orig_direction = get_move_direction(AI, target_point.position) 
	
	input_controller.input_dir = get_move_direction(AI, target_point.position)
	
	if input_controller.input_dir == -1 and orig_direction == 1 or input_controller.input_dir == 1 and orig_direction == -1:
		target_point = null
		patrol_waiting = true
		get_tree().create_timer(randf_range(patrol_wait_time_min, patrol_wait_time_max)).timeout.connect(_on_patrol_timer_timeout)
	

func _on_patrol_timer_timeout():
	patrol_waiting = false

# returns the resulting move direction
func get_move_direction(AI : AIController, target_pos : Vector2) -> int:
	if AI.position.x > target_pos.x:
		return -1 
	else:
		return 1 
