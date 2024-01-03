extends CharacterBody2D

@export var invincible: bool= false
@export var SPEED: float = 100.0

@onready var animationTree: AnimationTree = $AnimationTree
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var healthbar: TextureProgressBar = $HealthBar

var direction: Vector2 = Vector2.ZERO
var maxHealth = 100
var currentHealth = maxHealth
var phisical_armor = 1
var is_alive = true
var enemy_inattack_range = false

func _ready():
	scale = Vector2(1, 1)
	animationTree.active = true
	
func _process(delta):
	if is_alive:
		update_animation_parameters()
		update_health_bar()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if !is_alive:
			is_alive = true
			currentHealth = maxHealth
			animationTree.active = true

func _physics_process(delta):
	if is_alive:
		direction= Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
		if direction:
			velocity = direction * SPEED
		else:
			velocity = Vector2.ZERO
	move_and_slide()

func update_animation_parameters():
	if  velocity == Vector2.ZERO:
		animationTree["parameters/conditions/idle"] = true
		animationTree["parameters/conditions/is_moving"] = false
	else:
		animationTree["parameters/conditions/idle"] = false
		animationTree["parameters/conditions/is_moving"] = true
	
	if direction != Vector2.ZERO:
		animationTree["parameters/idle/blend_position"] = direction
		animationTree["parameters/walk/blend_position"] = direction
		
	if currentHealth <= 0:
		currentHealth = 0
		is_alive = false
		velocity = Vector2.ZERO
		animationTree.active = false
		animation.play("death")

func update_health_bar():
	healthbar.value = currentHealth * 100 / maxHealth

func take_phisical_damage(atk):
	if !invincible:
		currentHealth -= atk / phisical_armor

func _on_player_hit_box_body_entered(body):
	if body.is_in_group("enemy_group"):
		enemy_inattack_range = true


func _on_player_hit_box_body_exited(body):
	if body.is_in_group("enemy_group"):
		enemy_inattack_range = false
