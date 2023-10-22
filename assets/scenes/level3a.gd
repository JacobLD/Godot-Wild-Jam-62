extends Stage


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	if GameManager.previous_player_props.size() == 0:
		return
	
	var first_player_prop : PlayerProps = GameManager.previous_player_props[0]
	first_player_prop.set_clone($agents/agent_1/Clone)
	
	var second_player_prop : PlayerProps = GameManager.previous_player_props[1]
	second_player_prop.set_clone($agents/agent_2/Clone)

	var third_player_prop : PlayerProps = GameManager.previous_player_props[2]
	third_player_prop.set_clone($agents/agent_3/Clone)


func _on_death_area_body_entered(body):
	if body is PlayerController:
		body.add_health(-9999)
