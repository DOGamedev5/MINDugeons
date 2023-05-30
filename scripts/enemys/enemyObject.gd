extends KinematicBody2D

class_name enemyObject


onready var timer := get_node("Timer")
onready var player = get_parent().get_node("%player")


export var live := 1
export var damage := 1
export var shield := 1

var seePlayer := false

func get_vector_dir():
	var player_angle = position.angle_to_point(player.global_position) + deg2rad(180)
	return Vector2(cos(player_angle), sin(player_angle))

func _ready():
	global_position += Vector2(8, 8)
