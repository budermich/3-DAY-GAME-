extends Node2D

var hp=3
var speed=300 #make it small
var wantedPosition=position.y
var initPos=0
@onready var particles = preload("res://scenes/MovementParticle.tscn")
var SpeedUp=1
var InitColor=Color8(0,176,252,255)
@onready var polygon=get_child(0)
var GameOver=false

var Hearts = []
func _ready() -> void:
	polygon.color=InitColor
	Hearts.append($"../Heart1")
	Hearts.append($"../Heart2")
	Hearts.append($"../Heart3")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("down") and !moving:
		var particleInstance=particles.instantiate()
		wantedPosition=clamp(position.y+32,-320,320)
		initPos=position.y
		particleInstance.get_process_material().gravity.y=-abs(particleInstance.get_process_material().gravity.y)
		particleInstance.scale.y=-1
		particleInstance.emitting=true
		polygon.add_child(particleInstance)
		Move(-1)
	if Input.is_action_just_pressed("Up") and !moving:
		var particleInstance=particles.instantiate()
		wantedPosition=clamp(position.y-32,-320,320)
		initPos=position.y
		particleInstance.get_process_material().gravity.y=abs(particleInstance.get_process_material().gravity.y)
		particleInstance.emitting=true
		polygon.add_child(particleInstance)
		Move(1)


@onready var score_counter: RichTextLabel = $"../TextureRect/Score Counter"
@onready var damage_sound: AudioStreamPlayer2D = $DamageSound
@onready var score_sound: AudioStreamPlayer2D = $ScoreSound
@onready var buff_timer: Timer = $BuffTimer
@onready var speed_sound: AudioStreamPlayer2D = $SpeedSound
@onready var enlarge_timer: Timer = $EnlargeTimer
@onready var enlargen_sound: AudioStreamPlayer2D = $EnlargenSound
@onready var life_sound: AudioStreamPlayer2D = $"Life+Sound"

var Anim1=preload("res://scenes/+1Score.tscn")

var Enlargen=1
#i need to work with you here, i need types of blocks.
func _on_collision_area_entered(area: Area2D) -> void:
	if(area.type=="Deadly" and !GameOver):
		hp-=1
		damageTaken=false
		AnimateDamage()
		damage_sound.play()
		if(hp<=0):
			YouLose()
	elif(area.type=="Score" and !GameOver):
		Global.score+=1
		score_counter.text=str(Global.score)
		scoreGotten=false
		if(Enlargen==1 and SpeedUp==1):
			AnimateScore()
		score_sound.play()
		var anim1Instance=Anim1.instantiate()
		anim1Instance.global_position=Vector2(-460,-320)
		score_counter.get_parent().get_parent().add_child(anim1Instance)
	elif(area.type=="Speed" and !GameOver):
		buffed=true
		buff_timer.stop()
		buff_timer.start()
		speed_sound.play()
		SpeedUp=2
		polygon.modulate=Color8(0,255,0,255)
	elif(area.type=="Enlargen" and !GameOver):
		enlarge_timer.stop()
		enlarge_timer.start()
		Enlargen=1.5
		enlargen_sound.play()
		EnlargenUpAnimate(get_process_delta_time())
	elif(area.type=="Life+" and !GameOver):
		life_sound.play()
		index+=1
		hp+=1
		hp=clamp(hp,0,3);
		Hearts[index].show()
	area.get_parent().queue_free()

var moving=false
func Move(where):
	var delta=get_process_delta_time()
	moving=true
	AnimateX(get_process_delta_time())
	AnimateY(get_process_delta_time())
	await get_tree().create_timer(0.01).timeout
	while((position.y>wantedPosition and where==1) or (position.y<wantedPosition and where==-1)):
		await get_tree().create_timer(0.01).timeout
		position.y+=speed*SpeedUp*where*-1.2*delta
	position.y=wantedPosition
	moving=false
	scale=initScale*Vector2(1,Enlargen)

@export var initScale:Vector2
#The x scaling changes when u move

func EnlargenUpAnimate(delta):
	while(scale.y<1.2):
		scale.y+=8*delta*SpeedUp
		await get_tree().create_timer(0.001).timeout

func EnlargenDownAnimate(delta):
	while(scale.y>0.8):
		scale.y-=8*delta*SpeedUp
		await get_tree().create_timer(0.001).timeout
	Enlargen=1

func AnimateX(delta):
	while(scale.x>0.4 and moving):
		scale.x-=6*delta*SpeedUp/Enlargen
		await get_tree().create_timer(0.001).timeout
	while(scale.x<0.8 and moving):
		scale.x+=6*delta*SpeedUp/Enlargen
		await get_tree().create_timer(0.001).timeout
#The y scaling changes when u move
func AnimateY(delta):
	while(scale.y<1.2*Enlargen and moving):
		scale.y+=6*delta*SpeedUp/Enlargen
		await get_tree().create_timer(0.001).timeout
	while(scale.y>0.8*Enlargen and moving):
		scale.y-=6*delta*SpeedUp/Enlargen
		await get_tree().create_timer(0.001).timeout

var damageTaken=false
var index=Hearts.size()-1
func AnimateDamage():
	Hearts[index].hide()
	index-=1
	damageTaken=true
	if(Enlargen==1 and SpeedUp==1):
		while(damageTaken and modulate.g>0):
			modulate.g-=20.0/255.0
			await get_tree().create_timer(0.01).timeout
		while(damageTaken and modulate.g<1):
			modulate.g+=20.0/255.0
			await get_tree().create_timer(0.01).timeout
	polygon.color=InitColor

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
	polygon.color=InitColor

var buffed=false
func _on_buff_timer_timeout() -> void:
	buffed=false
	await get_tree().create_timer(1).timeout
	if(buffed==false):
		SpeedUp=1
		polygon.modulate=Color8(255,255,255,255)

func _on_enlarge_timer_timeout() -> void:
	EnlargenDownAnimate(get_process_delta_time())

signal loss
func YouLose():
	GameOver=true
	emit_signal("loss")
