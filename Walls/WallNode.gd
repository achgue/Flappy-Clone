extends Node2D


var Wall = preload("res://Walls/WallNode.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func Wall_reset(wallPos):
	var Wall_instance = Wall.instance()
	Wall_instance.position = Vector2(wallPos, rand_range(-60,60))
	get_parent().call_deferred("add_child", Wall_instance)


func _on_Generator_body_entered(body):
	if body.name == "Walls":
		print(body.position.x)
		var newWallPosition = body.position.x - body.position.x + 400
		Wall_reset(newWallPosition)

func _on_Destroier_body_entered(body):
	if body.name == "Walls":
		body.queue_free()

