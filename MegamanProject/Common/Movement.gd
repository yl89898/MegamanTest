extends KinematicBody2D
class_name Movement

export(float) var gravity_scale = 1

var UP = Vector2.UP
var _velocity = Vector2.ZERO
var _gravity = Vector2(0, 9.8)
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	process_gravity(delta)
	move()
# Move by velocity
func move():
	_velocity = move_and_slide(_velocity, UP)

func process_gravity(delta):
	if gravity_scale != 0:
		_velocity = _velocity + _gravity * gravity_scale * delta

func set_velocity_x(velocity:float):
	_velocity.x = velocity
func set_velocity_y(velocity:float):
	_velocity.y = velocity
