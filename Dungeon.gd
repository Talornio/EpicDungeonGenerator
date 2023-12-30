extends Node2D

@onready var rooms: Node = $Rooms
@onready var map: TileMap = $TileMap


var room = preload("res://room.tscn")

var min_size: int = 7
var max_size: int = 17
var tile_size: int = 16

var num_rooms: int = 100
var hspread = 200
var vspread = 200
var cull = 0.5

var path: AStar2D
var room_positions = []

func _ready():
	randomize()
	make_rooms()

func make_rooms():
	for i in range (num_rooms):
		var pos = Vector2(randi_range(-hspread, hspread), randi_range(-vspread, vspread))
		var r = room.instantiate()
		var w = randi_range(min_size, max_size)
		var h = randi_range(min_size, max_size)
		rooms.add_child(r)
		r.make_room(pos, Vector2(w, h) * tile_size)
	await get_tree().create_timer(1.2).timeout
	for room in rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.freeze = true
			room.set_freeze_mode(0)
			room_positions.append(room.position)
	await get_tree().process_frame
	path = find_mst(room_positions)

func find_mst(nodes):
	var path = AStar2D.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	while nodes:
		var min_dist = INF
		var min_p = null
		var p = null
		for pr in path.get_point_ids():
			var p1 = path.get_point_position(pr)
			for p2 in nodes:
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		nodes.erase(min_p)
	return path

func _draw():
	for room in rooms.get_children():
		draw_rect(Rect2(room.position - room.size / 2, room.size), Color(32, 228, 0), false)
	if path:
		for p in path.get_point_ids():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				#draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color(1, 1, 0), 15, true)

func _process(delta):
	queue_redraw()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		for n in rooms.get_children():
			n.queue_free()
		path = null
		make_rooms()
	if event.is_action_pressed("ui_focus_next"):
		make_map()

func make_map():
	map.clear()
	var full_rect = Rect2()
	for room in rooms.get_children():
		var r = Rect2(room.position - room.get_node("CollisionShape2D").shape.get_size() / 2, room.get_node("CollisionShape2D").shape.get_size())
		full_rect = full_rect.merge(r)
		var topleft = map.local_to_map(full_rect.position)
		var bottomright = map.local_to_map(full_rect.end)
		for x in range(topleft.x, bottomright.x):
			for y in range(topleft.y, bottomright.y):
				map.set_cell(0, Vector2i(x, y), 3, Vector2i(8, 7))
	
	var corridors = []
	for room in rooms.get_children():
		var s = (room.size / tile_size).floor() / 2
		var pos = map.local_to_map(room.position)
		var ul = (room.position / tile_size).floor() - s
		for x in range(0, s.x * 2):
			for y in range(0, s.y * 2):
				map.set_cell(1, Vector2i(ul.x +x, ul.y + y), 3, Vector2i(9, 6))
	
		var p = path.get_closest_point(Vector2(room.position.x, room.position.y))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = map.local_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y))
				var end = map.local_to_map(Vector2(path.get_point_position(conn).x, path.get_point_position(conn).y))
				carve_path(start, end)
		corridors.append(p)

func carve_path(start, end):
	var difference_x = sign(end.x - start.x)
	var difference_y = sign(end.y - start.y)
	
	if difference_x == 0:
		difference_x = pow(-1.0, randi() % 2)
	if difference_y == 0:
		difference_y = pow(-1.0, randi() % 2)
		
	var x_over_y = start
	var y_over_x = end
	
	if randi() % 2 > 0:
		x_over_y = end
		y_over_x = start

	for x in range(start.x, end.x, difference_x):
		map.set_cell(0, Vector2i(x, y_over_x.y), 3, Vector2i(6, 8))
		map.set_cell(0, Vector2i(x, y_over_x.y + difference_y), 3, Vector2i(6, 8))
	for y in range(start.y, end.y, difference_y):
		map.set_cell(0, Vector2i(x_over_y.x, y), 3, Vector2i(6, 8))
		map.set_cell(0, Vector2i(x_over_y.x + difference_x, y), 3, Vector2i(6, 8))

