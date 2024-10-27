extends Area2D
var StartPos
var dir = Vector2.LEFT
var speed = 150

var type = "aux"

@onready var polygon_2d: Polygon2D = $Polygon2D

func _ready():
	var rand = randi_range(0,2)
	match rand:
		0: type="Deadly"; polygon_2d.color.r=1; polygon_2d.color.g=1; polygon_2d.color.b=1
		1: type="Score"
		2: match randi_range(0,2):
			0: match randi_range(0,1):
				0:type="Speed"; polygon_2d.color.r=0; polygon_2d.color.g=0; polygon_2d.color.b=1
				1:type="Enlargen"; polygon_2d.color.g=1; polygon_2d.color.r=0; polygon_2d.color.b=0
			1: type="Deadly"; polygon_2d.color.r=1; polygon_2d.color.g=1; polygon_2d.color.b=1
			2: type="Score"
	StartPos = position.x 

func _process(delta):
	position += dir*speed*delta


func _on_timer_timeout() -> void:
	print("death")
	queue_free()
