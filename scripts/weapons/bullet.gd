extends Area2D

class_name Bullet

var speed: float
var velocity: Vector2
var damage: int

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var new_pos = velocity * speed * delta
	position += new_pos
	$sprite.look_at(position + new_pos) #Do this better.
	
func _on_bullet_body_entered(body: Node2D):
	if body != owner:
		queue_free()
		body.queue_free()

