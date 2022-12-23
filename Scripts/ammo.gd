extends RigidBody3D

func _process(_delta):
	if position.y < -100:
		queue_free()

func _on_body_entered(body):
	if body is Mouth:
		queue_free()
		body.CheckForDestruction()
