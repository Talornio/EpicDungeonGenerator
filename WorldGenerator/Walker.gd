extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var step_since_turn = 0
var rooms = []
var available_rooms:= []

@export_range(0.0, 1.0) var monster_room_chance: float = 0.3
var monster_rooms:= []

@export_range(0.0, 1.0) var treasure_room_chance: float = 0.75
@export var treasure_rooms_max: int = 2
var treasure_rooms:= []

func _init(starting_position, new_borders):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders
	
func walk(steps):
	place_room(position)
	for step in steps:
		#randf() <= 0.25 or
		if step_since_turn >= 6:
			change_direction()
		if step():
			step_history.append(position)
		else:
			change_direction()
	available_rooms = rooms
	return step_history

func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		step_since_turn += 1
		position = target_position
		return true
	else:
		return false

func change_direction():
	place_room(position)
	step_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func place_room(position):
	var size = Vector2(randi() % 4 + 2, randi() % 4 + 2)
	var top_left_corner = (position - size / 2).ceil()
	rooms.append(create_room(position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)

func create_room(position, size):
	return{position = position, size = size}

func get_end_room():
	var end_room = rooms.pop_front()
	var starting_position = step_history.front()
	for room in rooms:
		if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
			end_room = room
			#available_rooms.erase(room)
	return end_room

func place_monsters():
	available_rooms.pop_front()
	for room in available_rooms:
		if randf() < monster_room_chance:
			monster_rooms.append(room)
			available_rooms.erase(room)
	return monster_rooms

func place_treasures():
	if treasure_rooms.size() < treasure_rooms_max:
		for room in available_rooms:
			if randf() < treasure_room_chance:
				treasure_rooms.append(room)
				available_rooms.erase(room)
	return treasure_rooms





