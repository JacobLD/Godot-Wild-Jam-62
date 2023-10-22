extends Node2D
class_name SFXPlayer

enum FloorType {
	GRASS,
	ROCK,
	WETLEAVES
}

func on_jump(pos = self.position):
	_play_random_child_at(pos, $Jump)


func on_swing(pos = self.position):
	_play_random_child_at(pos, $Swing)


func on_block(pos = self.position):
	_play_random_child_at(pos, $Block)

func on_damage(pos = self.position):
	_play_random_child_at(pos, $Damage)

func on_dodge(pos = self.position):
	_play_random_child_at(pos, $Dodge)

func on_hit(pos = self.position):
	_play_random_child_at(pos, $Hit)

func on_parry(pos = self.position):
	_play_random_child_at(pos, $Parry)

func on_footstep(type, pos = self.position):
	match type:
		FloorType.GRASS:
			_play_random_child_at(pos, $Grass)
		FloorType.ROCK:
			_play_random_child_at(pos, $Rocks)
		FloorType.WETLEAVES:
			_play_random_child_at(pos, $Leaves)

func _play_random_child_at(pos : Vector2, child : Node) -> void:
	var child_arr : Array = child.get_children()
	var sound_node : AudioStreamPlayer2D = child_arr.pick_random()
	sound_node.position = pos
	sound_node.play()


func on_dash(pos = self.position):
	_play_random_child_at(pos, $Dash)
