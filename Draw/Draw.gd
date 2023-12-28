extends Node2D

@export var line_precision: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Mouse.connect("left_click", Callable(self, "create_line"))
	Mouse.connect("left_motion", Callable(self, "draw_lines"))
	Mouse.connect("left_unclick", Callable(self, "single_point_resolver"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var current_lines_child=-1
@onready var lines=$CanvasLayer/Lines

func create_line(touch_position):
	var line: Line2D = Line2D.new()
	line.add_point(touch_position)
	lines.add_child(line)
	line.sharp_limit=false
	#line.width_curve=preload("res://curva.tres")
	current_lines_child+=1

var drag_number=0

func draw_lines(position_current: Vector2, position_drag_last: Vector2, position_start: Vector2) -> void:
	if drag_number>=line_precision:
		print(drag_number)
		var line: Line2D =lines.get_child(current_lines_child)
		line.add_point(position_current)
		drag_number=0
	else:
		drag_number+=1

func single_point_resolver():
	print("mmm")
	#var line: Line2D = Line2D.new()
	var line: Line2D = lines.get_child(current_lines_child)
	if line.get_point_count()==1:
		var point=line.get_point_position(0)
		line.add_point(point+Vector2(1,0))
		line.add_point(point+Vector2(0,1))
		line.add_point(point+Vector2(-1,0))
		line.add_point(point+Vector2(0,-1))
		line.remove_point(0)
		line.closed=true
		line.width=10
		line.joint_mode=Line2D.LINE_JOINT_ROUND
