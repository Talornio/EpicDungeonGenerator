extends CharacterBody2D

@onready var slime_anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $CooldownAttackTimer
@onready var healthbar: TextureProgressBar = $HealthBar

const SPEED = 50
var player_chase = false
var player = null
var is_player_inattack_range = false
var can_attack = true
var attack_cooldown_value = 1
var maxHealth = 30
var currentHealth = maxHealth
var phisical_attack = 15

func _ready():
	scale = Vector2(1, 1)
	attack_timer.set_wait_time(attack_cooldown_value)

func _process(delta):
	update_health_bar()
	attack_player()

func _physics_process(delta):
	if player_chase && player: 
		if player.is_alive:
			velocity=Vector2(SPEED,0).rotated(position.angle_to_point(player.position))
			slime_anim.play("walk")
			if (player.position.x - position.x) < 0:
				slime_anim.flip_h = true
			else:
				slime_anim.flip_h = false
	else:
		slime_anim.play("idle")
		velocity.x=move_toward(velocity.x, 0, SPEED)
		velocity.y=move_toward(velocity.y, 0, SPEED)
	move_and_slide()

func update_health_bar():
	healthbar.value = currentHealth * 100 / maxHealth

func attack_player():
	if is_player_inattack_range && can_attack && player.is_alive:
			attack_timer.start()
			player.take_phisical_damage(phisical_attack)
			can_attack = false

func _on_detection_area_body_entered(body):
	if body.is_in_group("player_group"):
		player = body
		player_chase = true
		print(position)


func _on_detection_area_body_exited(body):
	if body.is_in_group("player_group"):
		player = null
		player_chase = false


func _on_slime_hit_box_body_entered(body):
	if body.is_in_group("player_group"):
		is_player_inattack_range = true
		player_chase = false


func _on_slime_hit_box_body_exited(body):
	if body.is_in_group("player_group"):
		is_player_inattack_range = false
		player_chase = true


func _on_cooldown_attack_timer_timeout():
	can_attack = true
