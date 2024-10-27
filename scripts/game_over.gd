extends Node2D

@export var delay:float=2
var wantedpos:float
@export var desiredModulate:float=1
# Called when the node enters the scene tree for the first time.
func gameover() -> void:
	wantedpos=global_position.y-16
	await get_tree().create_timer(delay).timeout
	Float(get_process_delta_time())
	Show(get_process_delta_time())

func Float(delta):
	while(position.y<wantedpos):
		await get_tree().create_timer(delta).timeout
		position.y-=10*delta

func Show(delta):
	while(modulate.a<desiredModulate):
		await get_tree().create_timer(delta).timeout
		modulate.a+=0.8*delta
