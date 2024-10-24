extends GPUParticles2D

func _on_finished() -> void:
	emitting=false
	queue_free()
