extends GPUParticles2D

func _ready() -> void:
	emitting=true

func _on_finished() -> void:
	emitting=false
	queue_free()
