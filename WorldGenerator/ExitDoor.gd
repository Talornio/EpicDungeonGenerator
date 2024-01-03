extends Area2D

signal leaving_level

func _on_body_entered(body):
	if body.is_in_group("player_group"):
		emit_signal("leaving_level")
