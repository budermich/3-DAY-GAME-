extends Node2D
var rand:int
func _ready() -> void:
	rand=randi_range(-1,1)
	var particle=preload("res://scenes/+1_explosion_particle.tscn").instantiate()
	particle.global_position=global_position-Vector2(10,0)
	get_parent().add_child(particle)

func _process(delta: float) -> void:
	GoUp(delta)
	Animate(rand)

@onready var initpos=global_position.y
func GoUp(delta):
	position.y-=delta*200
	if(position.y<initpos-40):
		queue_free()


func Animate(rand):
	while(rotation_degrees*rand>-15*rand):
		rotation_degrees-=1*rand
		await get_tree().create_timer(0.01).timeout
	while(rotation_degrees*rand<15*rand):
		rotation_degrees+=1*rand
		await get_tree().create_timer(0.01).timeout
