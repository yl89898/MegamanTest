extends AnimationPlayer

var _grounded:bool = true
var _move_speed:float = 0

var _action = null

# ===================================================
func play_action(action_name):
	_action = action_name
	if action_name == "fire":
		if current_animation == "move" and _move_speed != 0:
			var pos = current_animation_position
			play("fire_move")
			advance(pos)
		elif _grounded == false:
			play("fire_jump")
		else:
			play("fire")
	else:
		play(action_name)
func stop_action():
	_action = null
func set_grounded(grounded):
	_grounded = grounded
func set_move_speed(speed):
	_move_speed = speed
# ===================================================
func _ready():
	play("idle")
func _process(delta):
	if current_animation == "idle":
		idle_tran()
	elif current_animation == "move":
		move_tran()
	elif current_animation == "jump":
		jump_tran()
	elif current_animation == "dash":
		dash_tran()
	elif current_animation == "fire":
		if _action == null:
			idle_and_move()
		elif _grounded == false:
			play("fire_jump")
		elif _move_speed != 0:
			play("fire_move")
	elif current_animation == "fire_move":
		if _move_speed == 0:
			play("fire")
		if _action == null:
			var pos = current_animation_position
			play("move")
			advance(pos)
	elif current_animation == "fire_jump":
		if _action == null:
			play("jump")
		elif _grounded == true:
			idle_and_move()
# =====================================================
func idle_and_move():
	if _move_speed > 0 and current_animation != "move":
		play("move")
	if _move_speed <= 0 and current_animation != "idle":
		play("idle")
# =====================================================
func idle_tran():
	if _move_speed > 0:
		play("move")
	elif _grounded == false:
		play("jump")
func move_tran():
	if _move_speed <= 0:
		play("idle")
	elif _grounded == false:
		play("jump")
func jump_tran():
	if _grounded == true:
		idle_and_move()
func dash_tran():
	if _action == null:
		idle_and_move()
