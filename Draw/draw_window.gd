extends Window

@onready var draw: = $Draw
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

var closed=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if closed:
			closed=false
			show()
		else:
			closed=true
			hide()
			draw.can_draw=false

func _on_close_requested() -> void:
	closed=true
	hide()
	draw.can_draw=false


func _on_mouse_entered() -> void:
	draw.can_draw=true


func _on_mouse_exited() -> void:
	draw.can_draw=false
