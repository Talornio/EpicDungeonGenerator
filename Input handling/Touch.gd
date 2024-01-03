extends Node

enum {RIGHT, LEFT, DOWN, UP}
signal swipe(direction: int, position_start: Vector2, position_end: Vector2, duration: int)
signal touch(position: Vector2)
signal drag(position_current: Vector2, position_drag_last: Vector2, position_start: Vector2)
signal untouch()

var position_start = null
var position_drag_last = null
var time_start = null
var minimum_drag = 100
var pressed = false

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		print("b")
		if event.is_pressed():
			if !pressed:
				position_start = event.position;
				position_drag_last = event.position;
				time_start = Time.get_ticks_msec();
			pressed=true;
			emit_signal("touch", event.position);
		if event.is_released():
			emit_signal("untouch")
			position_drag_last=null;
			_calculate_swipe(event.position, Time.get_ticks_msec());
	elif event is InputEventScreenDrag:
		if position_drag_last:
			emit_signal("drag", event.position, position_drag_last, position_start);
			position_drag_last=event.position;
		
		
func _calculate_swipe(position_end, time_end):
	if position_start == null: 
		pressed=false;
		return;
	var movement = position_end - position_start;
	var duration = time_end - time_start;
	if abs(movement.x) > minimum_drag || abs(movement.y) > minimum_drag:
		if duration<3000:
			if abs(movement.x) > abs(movement.y):
				if movement.x > 0:
					emit_signal("swipe", RIGHT, position_start, position_end, duration);
				else:
					emit_signal("swipe", LEFT, position_start, position_end, duration);
			else:
				if movement.y > 0:
					emit_signal("swipe", DOWN, position_start, position_end, duration);
				else:
					emit_signal("swipe", UP, position_start, position_end, duration);
	pressed=false;
