extends Area2D
var StartPos
var dir = Vector2.LEFT
var speed = 150
var type:String = "aux"
# Called when the node enters the scene tree for the first time.
@onready var polygon_2d: Polygon2D = $Polygon2D

func _ready():
	var rand = randi_range(0,3)
	match rand:
		0: type="Deadly"; polygon_2d.color.r=1; polygon_2d.color.g=1; polygon_2d.color.b=1
		1: type="Score"
		2: type="Speed"; polygon_2d.color.r=0; polygon_2d.color.g=0; polygon_2d.color.b=1
		3: type="Enlargen"; polygon_2d.color.g=1; polygon_2d.color.r=0; polygon_2d.color.b=0
	StartPos = position.x 

func _process(delta):
	position += dir*speed*delta
