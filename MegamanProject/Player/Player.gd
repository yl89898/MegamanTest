extends Movement
# export
export (int) var move_speed = 100
export (int) var jump_force = 200
export (float) var fire_time = 0.3
export (float) var dash_time = 0.5
# onready
onready var _root = $Root
onready var _anim = $AnimationPlayer
onready var _shot_pos = $Root/ShotPos
# property
const E_STATE = {
	GROUNDED = 0,
	AIR = 1,
	FIRE = 2,
	DASH = 3,
}
var state = E_STATE.GROUNDED
var cur_anim = null
var bullet_path = "res://Player/Player_Bullet.tscn"

var action_time = 0
# ===================================================== #
func _ready():
	pass # Replace with function body.
func _process(delta):
	process_state(delta)
	_anim.set_grounded(is_on_floor())
# ===================================================== #
# 以面朝方向为基础设置速度值
func set_velocity_forward(v:float):
	set_velocity_x(v * _root.scale.x)
# 开枪发子弹
func fire_bullet():
	var bullet_res = load(bullet_path)
	if bullet_res != null:
		var bullet_ins = bullet_res.instance()
		self.get_parent().add_child(bullet_ins)
		bullet_ins.global_position = _shot_pos.global_position
		bullet_ins.set_facing(_root.scale.x)
# ===================================================== #
#状态方法
func process_state(delta):
	if state == E_STATE.GROUNDED:
		check_move_input()
		check_rotate_input()
		check_jump_input()
		if check_dash_input():
			state = E_STATE.DASH
		elif check_fire_input():
			state = E_STATE.FIRE
		elif not is_on_floor():
			state = E_STATE.AIR
	elif state == E_STATE.AIR:
		check_move_input()
		check_rotate_input()
		if check_fire_input():
			state = E_STATE.FIRE
		elif is_on_floor():
			state = E_STATE.GROUNDED
	elif state == E_STATE.FIRE:
		check_jump_input()
		check_move_input()
		check_rotate_input()
		if check_fire_over(delta):
			_anim.stop_action()
			if is_on_floor():
				state = E_STATE.GROUNDED
			else:
				state = E_STATE.AIR
	elif state == E_STATE.DASH:
		check_rotate_input()
		set_velocity_forward(120)
		if action_time <= 0: #碰到墙 或者 碰到没有从狭窄的道路中走出来
			_anim.stop_action()
			set_velocity_forward(0)
			if is_on_floor():
				state = E_STATE.GROUNDED
			else:
				state = E_STATE.AIR
		else:
			action_time -= delta

# ===================================================== #
#移动
func check_move_input():
	var v = 0
	if Input.is_action_pressed("ui_left"):
		v += -1
	if Input.is_action_pressed("ui_right"):
		v += 1
	set_velocity_x(v * move_speed)
	_anim.set_move_speed(abs(v))
	return v
#转向
func check_rotate_input():
	if Input.is_action_pressed("ui_left"):
		_root.scale.x = -1
	if Input.is_action_pressed("ui_right"):
		_root.scale.x = 1
#跳跃
func check_jump_input():
	if Input.is_action_just_pressed("ui_up"):
		set_velocity_y(jump_force * -1)
#滑铲
func check_dash_input():
	if Input.is_action_just_pressed("ui_down"):
		_anim.play_action("dash")
		action_time = dash_time
		return true
	else:
		return false
#射击
func check_fire_input():
	if Input.is_action_just_pressed("ui_accept"):
		_anim.play_action("fire")
		fire_bullet()
		action_time = fire_time
		return true
	else:
		return false
func check_fire_over(delta):
	if action_time <= 0:#子弹打完了 是否发射子弹
		return not check_fire_input()
	else:
		action_time -= delta
		return false
#受击
#死亡
#爬梯子
