extends KinematicBody2D

class_name objectClass

export var is_interact := true
export var have_ballon := true


var interact = false
var ballon

func _ready():
	global_position += Vector2(8, 8)
	if have_ballon:
		ballon = get_node("ballon")
