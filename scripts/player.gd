extends Node2D

var health=3
var speed=20
var wantedPosition=position.y
var initPos=0
@onready var particles = preload("res://particle.tscn")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("down") and !moving:
		var particleInstance=particles.instantiate()
		wantedPosition=clamp(position.y+32,-320,320)
		initPos=position.y
		particleInstance.get_process_material().gravity.y=-abs(particleInstance.get_process_material().gravity.y)
		particleInstance.scale.y=-1
		particleInstance.emitting=true
		add_child(particleInstance)
		if(wantedPosition>=position.y+32):
			Move(-1)
	if Input.is_action_just_pressed("Up") and !moving:
		var particleInstance=particles.instantiate()
		wantedPosition=clamp(position.y-32,-320,320)
		initPos=position.y
		particleInstance.get_process_material().gravity.y=abs(particleInstance.get_process_material().gravity.y)
		particleInstance.emitting=true
		add_child(particleInstance)
		if(wantedPosition<=position.y-32):
			Move(1)

var moving=false
func Move(where): #Guaranteed consistent movement that calls the animation functions(DEPENDS ON SPEED, Small speed=fast, Big speed=slow
	moving=true
	AnimateX(get_process_delta_time())
	AnimateY(get_process_delta_time())
	await get_tree().create_timer(0.01).timeout
	while(abs(wantedPosition-position.y)>1):
		await get_tree().create_timer(0.01).timeout
		position.y+=(abs(initPos-wantedPosition)/speed)*where*-1
	position.y=wantedPosition
	moving=false
	scale=initScale

@export var initScale:Vector2
#The x scaling changes when u move
func AnimateX(delta):
	while(scale.x>0.4 and moving):
		scale.x-=4*delta
		await get_tree().create_timer(0.001).timeout
	while(scale.x<0.8 and moving):
		scale.x+=4*delta
		await get_tree().create_timer(0.001).timeout

#The y scaling changes when u move
func AnimateY(delta):
	while(scale.y<1.2 and moving):
		scale.y+=4*delta
		await get_tree().create_timer(0.001).timeout
	while(scale.y>0.8 and moving):
		scale.y-=4*delta
		await get_tree().create_timer(0.001).timeout

#i need to work with you here, i need types of blocks.
func _on_collision_area_entered(area: Area2D) -> void:
	pass
