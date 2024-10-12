extends CharacterBody2D
@export var bullet : PackedScene

var MAX_SPEED = 400
var ACCEL = 10
var sprint_factor = 2

var max_stamina = 100
var stamina = max_stamina
var sprint_cost = 30
var sprint_recovery = 20

var user_input: Vector2
var sprint: bool
var recovery: bool

func get_user_input():
	user_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	user_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	user_input = user_input.normalized()



	sprint = Input.is_key_pressed(KEY_SHIFT) && stamina > 0 && !recovery

func shoot(direction: Vector2):
	var b = bullet.instantiate()
	owner.add_child(b)
	
	direction = direction - position
	
	b.position = $Marker2D.global_position
	b.velocity = direction.normalized()
	b.round_owner = "player"

func _process(delta: float) -> void:
	get_user_input()
	
	var direction = get_global_mouse_position()
	look_at(direction)
	
	if Input.is_action_just_pressed("shoot"):
		shoot(direction)
	
	if sprint:
		velocity = velocity.lerp(MAX_SPEED * user_input * sprint_factor, delta * ACCEL * sprint_factor)
		stamina -= sprint_cost * delta
		recovery = stamina < 0
	else:
		velocity = velocity.lerp(MAX_SPEED * user_input, delta * ACCEL)
		if stamina < max_stamina:
			stamina += sprint_recovery * delta
		
		if recovery:
			recovery = !(stamina >= max_stamina && !Input.is_key_pressed(KEY_SHIFT))
	
	move_and_slide()

func _on_bullet_body_entered(_body: Node2D) -> void:
	print("I'm hit!")
