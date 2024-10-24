extends Area2D
var StartPos
var dir = Vector2.LEFT
var speed = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	
	StartPos = position.x 
	print(position)

func move(delta):
	position += dir*speed*delta



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	
