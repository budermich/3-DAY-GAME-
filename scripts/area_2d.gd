extends Area2D
var StartPos
var dir = Vector2.LEFT
var speed = 400
var type = null
# Called when the node enters the scene tree for the first time.
func _ready():
	type = randi_range(0,1)
	
	StartPos = position.x 
	print(position)

func move(delta):
	position += dir*speed*delta


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	pass
