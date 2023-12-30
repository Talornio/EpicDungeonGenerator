extends RigidBody2D

@onready var collisionShape: CollisionShape2D = $CollisionShape2D
var size

func make_room(_pos, _size):
	size = _size
	position = _pos
	var shape = RectangleShape2D.new()
	shape.size = size 
	collisionShape.set_shape(shape)
