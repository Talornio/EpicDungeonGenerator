extends CharacterBody2D

@onready var animation: AnimationTree = $AnimationTree
var direction: Vector2 = Vector2.ZERO

const SPEED = 100.0

func _ready():
	animation.active = true
	
func _process(delta):
	update_animation_parameters()

func _physics_process(delta):
	direction= Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	
func update_animation_parameters():
	if  velocity == Vector2.ZERO:
		animation["parameters/conditions/idle"] = true
		animation["parameters/conditions/is_moving"] = false
	else:
		animation["parameters/conditions/idle"] = false
		animation["parameters/conditions/is_moving"] = true
	
	if direction != Vector2.ZERO:
		animation["parameters/idle/blend_position"] = direction
		animation["parameters/walk/blend_position"] = direction
		
		
		
		
