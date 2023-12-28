extends Node

enum {RIGHT, LEFT, DOWN, UP}

signal left_click(position: Vector2)
signal left_unclick(position: Vector2)
signal left_motion(position: Vector2, relative: Vector2, velocity: Vector2)

signal middle_click(position: Vector2)
signal middle_unclick(position: Vector2)
signal middle_motion(position: Vector2, relative: Vector2, velocity: Vector2)

signal right_click(position: Vector2)
signal right_unclick(position: Vector2)
signal right_motion(position: Vector2, relative: Vector2, velocity: Vector2)

signal up_click(position: Vector2)
signal up_unclick(position: Vector2)
signal up_motion(position: Vector2, relative: Vector2, velocity: Vector2)

signal down_click(position: Vector2)
signal down_unclick(position: Vector2)
signal down_motion(position: Vector2, relative: Vector2, velocity: Vector2)

var pressed: Array[bool]=[true, false, false, false, false, false]

var x=0

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT:
			pressed[MOUSE_BUTTON_LEFT]=event.is_pressed()
			if pressed[MOUSE_BUTTON_LEFT]:
				emit_signal("left_click", event.position)
			else:
				emit_signal("left_unclick", event.position)
		if event.button_index==MOUSE_BUTTON_MIDDLE:
			pressed[MOUSE_BUTTON_MIDDLE]=event.is_pressed()
			if pressed[MOUSE_BUTTON_MIDDLE]:
				emit_signal("middle_click", event.position)
			else:
				emit_signal("middle_unclick", event.position)
		if event.button_index==MOUSE_BUTTON_RIGHT:
			pressed[MOUSE_BUTTON_RIGHT]=event.is_pressed()
			if pressed[MOUSE_BUTTON_RIGHT]:
				emit_signal("right_click", event.position)
			else:
				emit_signal("right_unclick", event.position)
		if event.button_index==MOUSE_BUTTON_WHEEL_UP:
			pressed[MOUSE_BUTTON_WHEEL_UP]=event.is_pressed()
			if pressed[MOUSE_BUTTON_WHEEL_UP]:
				emit_signal("up_click", event.position)
			else:
				emit_signal("up_unclick", event.position)
		if event.button_index==MOUSE_BUTTON_WHEEL_DOWN:
			pressed[MOUSE_BUTTON_WHEEL_DOWN]=event.is_pressed()
			if pressed[MOUSE_BUTTON_WHEEL_DOWN]:
				emit_signal("down_click", event.position)
			else:
				emit_signal("down_unclick", event.position)
	if event is InputEventMouseMotion:
		if pressed[MOUSE_BUTTON_LEFT]:
			emit_signal("left_motion", event.position, event.relative, event.velocity)
		if pressed[MOUSE_BUTTON_MIDDLE]:
			emit_signal("middle_motion", event.position, event.relative, event.velocity)
		if pressed[MOUSE_BUTTON_RIGHT]:
			emit_signal("right_motion", event.position, event.relative, event.velocity)
		if pressed[MOUSE_BUTTON_WHEEL_UP]:
			emit_signal("up_motion", event.position, event.relative, event.velocity)
		if pressed[MOUSE_BUTTON_WHEEL_DOWN]:
			emit_signal("down_motion", event.position, event.relative, event.velocity)
	#if event is InputEventMouseButton:
		#print("b")
		#if event.is_pressed():
			#print("c")
			#if !pressed:
				#position_start = event.position;
				#position_drag_last = event.position;
				#time_start = Time.get_ticks_msec();
			#pressed=true;
			#emit_signal("touch", event.position);
		#if event.is_released():
			#emit_signal("untouch")
			#position_drag_last=null;
			#_calculate_swipe(event.position, Time.get_ticks_msec());
	#elif event is InputEventMouseMotion:
		#if position_drag_last:
			#emit_signal("drag", event.position, position_drag_last, position_start);
			#position_drag_last=event.position;
		
		
#func _calculate_swipe(position_end, time_end):
	#if position_start == null: 
		##pressed=false;
		#return;
	#var movement = position_end - position_start;
	#var duration = time_end - time_start;
	#if abs(movement.x) > minimum_drag || abs(movement.y) > minimum_drag:
		#if duration<3000:
			#if abs(movement.x) > abs(movement.y):
				#if movement.x > 0:
					#emit_signal("swipe", RIGHT, position_start, position_end, duration);
				#else:
					#emit_signal("swipe", LEFT, position_start, position_end, duration);
			#else:
				#if movement.y > 0:
					#emit_signal("swipe", DOWN, position_start, position_end, duration);
				#else:
					#emit_signal("swipe", UP, position_start, position_end, duration);
	#pressed=false;
