extends KinematicBody2D


const UP = Vector2(0,-1)
const FLAP = 200
const MAXFALLSPEED = 200
const GRAVITY = 10

var glideSpeed = 50
var JUMPNUM = 3

var Wall = preload("res://Walls/WallNode.tscn")


var glideStamina = 30
var motion = Vector2()
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	if Input.is_action_just_pressed("FLAP"):
		if JUMPNUM > 0:
			motion.y = -FLAP
			JUMPNUM -= 1
			$JumpSound.play()
		if glideStamina < 30:
			glideStamina += 5
			if glideStamina > 30:
				glideStamina = 30
		
	
	if Input.is_action_pressed("GLIDE"):
		if glideStamina > 0:
			motion.y = glideSpeed
			JUMPNUM += 1
			if JUMPNUM > 3:
				JUMPNUM = 3
			glideStamina -=1
		
	motion = move_and_slide(motion, UP)
	get_parent().get_parent().get_node("CanvasLayer/RichTextLabel").text = str(score)
	get_parent().get_parent().get_node("CanvasLayer/Stamina").value = glideStamina
	get_parent().get_parent().get_node("CanvasLayer/Jumps").value = JUMPNUM


func _on_Detect_area_entered(area):
	if area.name == "PointArea":
		score +=1


func _on_Detect_body_entered(body):
	if body.name == "Walls":
		get_tree().reload_current_scene()


func Wall_reset(wallPos):
	var Wall_instance = Wall.instance()
	Wall_instance.position = Vector2(wallPos, rand_range(-60,60))
	get_parent().call_deferred("add_child", Wall_instance)

func _on_Generator_body_entered(body):
	if body.name == "Walls":
		var newWallPosition = body.position.x - body.position.x + 400
		Wall_reset(newWallPosition)


func _on_Destroier_body_entered(body):
	if body.name == "Walls":
		body.queue_free()
