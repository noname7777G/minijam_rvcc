extends Area2D
class_name Bullet

var velocity: Vector2
var speed: int
var projectile_owner: Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var new_pos = velocity * speed * delta
	position += new_pos
	$sprite.look_at(position + new_pos) #Do this better.
	
func _on_bullet_body_entered(body: CharacterBody2D):
	if body != projectile_owner:
		queue_free()
		body._on_bullet_body_entered()

