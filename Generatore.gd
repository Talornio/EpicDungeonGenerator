extends Node2D

var min_size: int = 7
var max_size: int = 17
var tile_size: int = 16
var rooms: Array[Rect2] = []
var room_attemps: int = 50
var map_size: Vector2 = DisplayServer.window_get_size()/tile_size

var player = preload("res://character_body_2d.tscn")

func _ready():
	make_rooms()
	make_tilemap()
	var player = player.instantiate()
	player.position = (rooms[0].position + rooms[0].end) / 2
	add_child(player)

func _process(delta):
		pass

func make_rooms():
	for i in range(room_attemps):
		var w = randi_range(min_size, max_size)
		var h = randi_range(min_size, max_size)
		var x = randi_range(0, map_size.x-w)
		var y = randi_range(0, map_size.y-h)
		var r = Rect2(x * tile_size, y * tile_size, w * tile_size, h * tile_size)
		var can_create=true
		for room in rooms:
			if r.intersects(room, true):
				can_create=false
		if can_create:
			rooms.append(r)


@onready var tilemap: TileMap=$TileMap

func make_tilemap():
	for rect in rooms:
		for x in range(rect.position.x, rect.end.x, tile_size):
			for y in range(rect.position.y, rect.end.y, tile_size):
				var cell = tilemap.local_to_map(Vector2(x, y)) # converte la posizione in una cella della TileMap
				tilemap.set_cell(0, Vector2i(cell.x, cell.y), 0, Vector2(16, 11)) # assegna la tile alla cella

#var Room = preload("res://room.tscn")
#var tile_size = 16 # dimensione di una tile nella TileMap
#var num_rooms = 50 # numero di stanze da generare
#var min_size = 4 # dimensione minima della stanza (in tiles)
#var max_size = 4 # dimensione massima della stanza (in tiles)
##var chest = preload("res://Chest.tscn") # scena del chest
##var enemy = preload("res://Enemy.tscn") # scena del nemico
#var rooms = [] # lista delle stanze generate
#var corridors = [] # lista dei corridoi generati
#var map_size=Vector2(1000,500)
#
#func _ready():
	#
	#randomize()
	#make_rooms()
	###connect_rooms()
	#make_tilemap()
#
#func make_rooms():
	## genera le stanze come RigidBody2D e le posiziona casualmente nella mappa
	#for i in range(num_rooms):
		#var r = Room.instantiate()
		#var w = randi_range(min_size, max_size) * tile_size
		#var h = randi_range(min_size, max_size) * tile_size
		#var x = randi_range(0, map_size.x - w)
		#var y = randi_range(0, map_size.y - h)
		#add_child(r)
		#r.make_room(Vector2(x, y), Vector2(w, h))
		#
		#rooms.append(r)
#
#func connect_rooms():
	## connette le stanze con dei corridoi usando l'algoritmo di Prim
	#var connected = [rooms[0]] # lista delle stanze connesse
	#var available = rooms.slice(1, rooms.size() - 1) # lista delle stanze disponibili
	#while available.size() > 0:
		#var edge = find_closest_edge(connected, available) # trova il bordo più vicino tra le due liste
		#var r1 = edge[0] # stanza connessa
		#var r2 = edge[1] # stanza disponibile
		#var c = make_corridor(r1, r2) # crea un corridoio tra le due stanze
		#add_child(c)
		#corridors.append(c)
		#connected.append(r2) # aggiunge la stanza disponibile a quella connessa
		#available.erase(r2) # rimuove la stanza disponibile da quella disponibile
#
#func find_closest_edge(connected, available):
	## trova il bordo più vicino tra le due liste di stanze
	#var min_dist = INF # distanza minima
	#var edge = [] # bordo più vicino
	#for r1 in connected:
		#for r2 in available:
			#var dist = r1.position.distance_to(r2.position) # distanza tra le due stanze
			#if dist < min_dist:
				#min_dist = dist
				#edge = [r1, r2]
	#return edge
#
#func make_corridor(r1, r2):
	## crea un corridoio tra le due stanze
	#var c = Room.instantiate()
	#var p1 = r1.position + r1.size / 2 # centro della prima stanza
	#var p2 = r2.position + r2.size / 2 # centro della seconda stanza
	#var w = abs(p1.x - p2.x) + tile_size # larghezza del corridoio
	#var h = abs(p1.y - p2.y) + tile_size # altezza del corridoio
	#var x = min(p1.x, p2.x) - tile_size / 2 # posizione x del corridoio
	#var y = min(p1.y, p2.y) - tile_size / 2 # posizione y del corridoio
	#c.make_room(Vector2(x, y), Vector2(w, h))
	#return c
#
#
#func make_tilemap():
	## crea una TileMap usando le stanze e i corridoi generati
	#var tilemap = TileMap.new()
	#tilemap.tile_set = preload("res://generatore.tres")
	#add_child(tilemap)
	#for r in rooms + corridors:
		#var rect = r # ottiene il rettangolo della stanza o del corridoio
		#for x in range(rect.position.x, rect.end.x, tile_size):
			#for y in range(rect.position.y, rect.end.x, tile_size):
				#var cell = tilemap.map_to_local(Vector2(x, y)) # converte la posizione in una cella della TileMap
				#var id = randi() % 4 # sceglie un id casuale tra 0 e 3
				#tilemap.set_cell(0, Vector2i(cell.x, cell.y), 0, Vector2(16, 11)) # assegna la tile alla cella
		#"""
		#if r in rooms:
			## se la stanza è una stanza, aggiunge un chest e un nemico in posizioni casuali
			#var chest_pos = r.position + Vector2(rand_range(0, r.size.x - tile_size), rand_range(0, r.size.y - tile_size))
			#var enemy_pos = r.position + Vector2(rand_range(0, r.size.x - tile_size), rand_range(0, r.size.y - tile_size))
			#var chest_cell = tilemap.world_to_map(chest_pos)
			#var enemy_cell = tilemap.world_to_map(enemy_pos)
			#var chest_instance = chest.instance()
			#var enemy_instance = enemy.instance()
			#chest_instance.position = tilemap.map_to_world(chest_cell) + tile_size / 2
			#enemy_instance.position = tilemap.map_to_world(enemy_cell) + tile_size / 2
			#add_child(chest_instance)
			#add_child(enemy_instance)
		#"""
