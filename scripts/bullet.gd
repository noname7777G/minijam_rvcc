extends Area2D

class_name Bullet

var SPEED = 700
var velocity: Vector2
var round_owner: String

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_pos = velocity * SPEED * delta
	position += new_pos
	$sprite.look_at(position + new_pos)
	
func _on_bullet_body_entered(body: Node2D):
	if body.name != round_owner:
		queue_free()
