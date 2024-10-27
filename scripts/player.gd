extends Node2D

var hp=3
var speed=20
var wantedPosition=position.y
var initPos=0
@onready var particles = preload("res://scenes/MovementParticle.tscn")
var SpeedUp=1
var InitColor=Color8(0,176,252,255)
@onready var polygon=get_child(0)

func _ready() -> void:
	polygon.color=InitColor

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("down") and !moving:
		var particleInstance=particles.instantiate()
		wantedPosition=clamp(position.y+32*Enlargen,-320,320)
		initPos=position.y
		particleInstance.get_process_material().gravity.y=-abs(particleInstance.get_process_material().gravity.y)
		particleInstance.scale.y=-1
		particleInstance.emitting=true
		polygon.add_child(particleInstance)
		if(wantedPosition>=position.y+32*Enlargen):
			Move(-1)
	if Input.is_action_just_pressed("Up") and !moving:
		var particleInstance=particles.instantiate()
		wantedPosition=clamp(position.y-32*Enlargen,-320,320)
		initPos=position.y
		particleInstance.get_process_material().gravity.y=abs(particleInstance.get_process_material().gravity.y)
		particleInstance.emitting=true
		polygon.add_child(particleInstance)
		if(wantedPosition<=position.y-32*Enlargen):
			Move(1)


@onready var score_counter: RichTextLabel = $"../TextureRect/Score Counter"
@onready var damage_sound: AudioStreamPlayer2D = $DamageSound
@onready var score_sound: AudioStreamPlayer2D = $ScoreSound
@onready var buff_timer: Timer = $BuffTimer
@onready var speed_sound: AudioStreamPlayer2D = $SpeedSound
@onready var enlarge_timer: Timer = $EnlargeTimer

var Anim1=preload("res://scenes/+1Score.tscn")

var Enlargen=1
#i need to work with you here, i need types of blocks.
func _on_collision_area_entered(area: Area2D) -> void:
	if(area.type=="Deadly"):
		hp-=1
		damageTaken=false
		AnimateDamage()
		damage_sound.play()
		if(hp<=0):
			YouLose()
	elif(area.type=="Score"):
		Global.score+=1
		score_counter.text=str(Global.score)
		scoreGotten=false
		AnimateScore()
		score_sound.play()
		var anim1Instance=Anim1.instantiate()
		anim1Instance.global_position=Vector2(-460,-320)
		score_counter.get_parent().get_parent().add_child(anim1Instance)
	elif(area.type=="Speed"):
		buff_timer.stop()
		buff_timer.start()
		speed_sound.play()
		SpeedUp=2
		polygon.modulate=Color8(0,255,0,255)
	elif(area.type=="Enlargen"):
		enlarge_timer.stop()
		enlarge_timer.start()
		Enlargen=2
		EnlargenUpAnimate(get_process_delta_time())
	area.get_parent().queue_free()

var moving=false
func Move(where): #Guaranteed consistent movement that calls the animation functions(DEPENDS ON SPEED, Small speed=fast, Big speed=slow)
	moving=true
	AnimateX(get_process_delta_time())
	AnimateY(get_process_delta_time())
	await get_tree().create_timer(0.01).timeout
	while(abs(wantedPosition-position.y)>4*SpeedUp):
		await get_tree().create_timer(0.01).timeout
		position.y+=(abs(initPos-wantedPosition)/(speed/SpeedUp))*where*-1.2
	position.y=wantedPosition
	moving=false
	scale=initScale*Vector2(1,Enlargen)

@export var initScale:Vector2
#The x scaling changes when u move

func EnlargenUpAnimate(delta):
	while(scale.y<1.6):
		scale.y+=8*delta*SpeedUp
		await get_tree().create_timer(0.001).timeout

func EnlargenDownAnimate(delta):
	while(scale.y>0.8):
		scale.y-=8*delta*SpeedUp
		await get_tree().create_timer(0.001).timeout

func AnimateX(delta):
	while(scale.x>0.4 and moving):
		scale.x-=5*delta*SpeedUp
		await get_tree().create_timer(0.001).timeout
	while(scale.x<0.8 and moving):
		scale.x+=5*delta*SpeedUp
		await get_tree().create_timer(0.001).timeout

#The y scaling changes when u move
func AnimateY(delta):
	while(scale.y<1.2*Enlargen and moving):
		scale.y+=5*delta*SpeedUp
		await get_tree().create_timer(0.001).timeout
	while(scale.y>0.8*Enlargen and moving):
		scale.y-=5*delta*SpeedUp
		await get_tree().create_timer(0.001).timeout

var damageTaken=false
func AnimateDamage():
	damageTaken=true
	while(damageTaken and modulate.g>0):
		modulate.g-=20.0/255.0
		await get_tree().create_timer(0.01).timeout
	while(damageTaken and modulate.g<1):
		modulate.g+=20.0/255.0
		await get_tree().create_timer(0.01).timeout

var scoreGotten=false
func AnimateScore():
	scoreGotten=true
	while(scoreGotten and modulate.b>0): 
		modulate.b-=20.0/255.0
		modulate.r-=20.0/255.0
		await get_tree().create_timer(0.01).timeout
	while(scoreGotten and modulate.b<1):
		modulate.b+=20.0/255.0
		modulate.r+=20.0/255.0
		await get_tree().create_timer(0.01).timeout

func _on_buff_timer_timeout() -> void:
	SpeedUp=1
	polygon.modulate=Color8(255,255,255,255)

func _on_enlarge_timer_timeout() -> void:
	EnlargenDownAnimate(get_process_delta_time())
	Enlargen=1

func YouLose():
	pass
