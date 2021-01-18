extends KinematicBody2D

export (int) var damage = 1
export var speed = 150

onready var _sprite:Sprite = $Sprite

var _UP = Vector2.UP
var _velocity = Vector2.RIGHT
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	move_and_slide(_velocity)

func set_facing(rotate:float):
	_velocity.x = speed * rotate
