extends Stage


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	if GameManager.previous_player_props.size() == 0:
		return
	
	var first_player_prop : PlayerProps = GameManager.previous_player_props[0]
	first_player_prop.set_clone($AI/agent_1/Clone)
	
	get_tree().create_timer(3).timeout.connect(activate_pool)

func activate_pool():
	$death_area/CollisionShape2D.disabled = false

func _on_portal_2_time_to_go():
	GameManager.enter_hub()



func _on_death_area_body_entered(body):
	if body is PlayerController:
		GameManager.getPlayer().add_health(-9999)
