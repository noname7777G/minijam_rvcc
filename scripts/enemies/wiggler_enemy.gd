extends Node2D

@onready var _body = $CharacterBody2D
@onready var _head = $CharacterBody2D/head
@onready var _thorax = $CharacterBody2D/thorax
@onready var _abdomen = $CharacterBody2D/abdomen
@onready var _tail = $CharacterBody2D/tail

@onready var _animation_player = $CharacterBody2D/AnimationPlayer

@export var health: float = 20.0
@export var speed: float = 20.0

var state = "idle"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# For testing purposes, comment out when not in use
	var U = Input.is_action_just_pressed("ui_up")
	var L = Input.is_action_just_pressed("ui_left")
	var R = Input.is_action_just_pressed("ui_right")
	var DO = Input.is_action_just_pressed("ui_accept")
	
	if U and !_animation_player.is_playing():
		_animation_player.play("move_forward")
		
	if L and !_animation_player.is_playing():
		_animation_player.play("turn_left")
		
	if R and !_animation_player.is_playing():
		_animation_player.play("turn_right")
		
	if DO and !_animation_player.is_playing():
		_animation_player.play("lunge")
	
func on_hit(damage: float):
	health -= damage

func tween_position(movement_difference: Vector2, duration: float):
	var tween : Tween = get_tree().create_tween()
	
	movement_difference = movement_difference.rotated(_body.rotation)
	tween.tween_property(_body, "global_position", _body.global_position + movement_difference, duration)

func tween_rotation(movement_difference: float, duration: float):
	var tween : Tween = get_tree().create_tween()
	
	movement_difference = deg_to_rad(movement_difference)
	tween.tween_property(_body, "rotation", _body.rotation + movement_difference, duration)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
