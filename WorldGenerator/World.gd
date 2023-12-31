extends Node2D

@onready var tileMap = $TileMap
@onready var exit: Area2D = $ExitDoor
@onready var enemies:=$Enemies
@onready var entities:=$Entities

const PLAYER = preload("res://Player/player_scene.tscn")
const SLIME = preload("res://Enemies/Slime/Slime_scene.tscn")

var player: CharacterBody2D
var borders = Rect2(1, 1, 38, 21)
var occupated_positions:= []

func _ready():
	player = PLAYER.instantiate()
	add_child(player)
	player.invincible=true
	player.SPEED=100
	exit.connect("leaving_level", Callable(self, "reload_level"))
	randomize()
	generate_level()

func reload_level():
	occupated_positions.clear()
	randomize()
	for entity in entities.get_children():
		entity.queue_free()
	call_deferred("generate_level")

func generate_level():
	var walker = Walker.new(Vector2(19, 11), borders)
	var map = walker.walk(200)
	
	player.position = map.front() * 32
	
	exit.position = walker.get_end_room().position
	occupated_positions.append(exit.position)
	exit.position*=32
	
	var all_cells : Array = tileMap.get_used_cells(0)
	tileMap.clear()
	#piazzare tesori QUI
	place_object_in_rooms(SLIME, walker.place_monsters())
	walker.queue_free()
	
	var using_cells : Array = []
	var not_using_cells : Array = []
	
	for cell in all_cells:
		if !map.has(Vector2(cell.x, cell.y)):
			using_cells.append(cell)
		else:
			not_using_cells.append(cell)
	tileMap.set_cells_terrain_connect(0, using_cells, 0, 0, false)
	tileMap.set_cells_terrain_connect(0, not_using_cells, 0, 1, false)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()

func spawn_monsters(walker):
	for room in walker.rooms:
		if randf() < 0.25:
			var SLIME = load("res://Enemies/Slime/Slime_scene.tscn") as PackedScene
			var slime = SLIME.instantiate()
			slime.position= room.position * 32 + Vector2(randi_range(0, room.size.x), randi_range(0, room.size.y))
			enemies.add_child(slime)
			#slime.position = (room.position + Vector2(randi_range(0, room.size.x), randi_range(0, room.size.y))) * 32

func place_object_in_rooms(obj_scene: PackedScene, rooms: Array):
	for room in rooms:
		var can_add: bool = true
		var obj:= obj_scene.instantiate() as Node2D
		obj.position=room.position + Vector2(randi_range(-room.size.x/2+1, room.size.x/2-1), randi_range(-room.size.y/2+1, room.size.y/2-1))
		for pos in occupated_positions:
			if pos==obj.position || !is_object_in_map(obj):
				can_add=false
		if can_add:
			occupated_positions.push_back(obj.position)
			obj.position*=32
			entities.add_child(obj)

func is_object_in_map(obj):
	return obj.position.x>borders.position.x && obj.position.y>borders.position.y && obj.position.x<borders.end.x && obj.position.y<borders.end.y
