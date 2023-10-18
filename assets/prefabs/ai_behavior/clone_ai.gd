extends BeehaveTree
class_name CloneAITree

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().root.ready
