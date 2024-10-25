extends Area2D
var StartPos
var dir = Vector2.LEFT
var speed = 400
var type:String = "aux"
# Called when the node enters the scene tree for the first time.
func _ready():
	var rand = randi_range(0,1)
	match rand:
		0: type="Deadly"; get_child(0).color.h=randf_range(0,100); get_child(0).color.r=0; get_child(0).color.g=0; get_child(0).color.b=0;
		1: type="Score"; get_child(0)
	StartPos = position.x 
	print(rand)

func _process(delta):
	position += dir*speed*delta
