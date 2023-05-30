extends Node

var currentPower = 0
var cooldown = 0.1

func newInstance(node, parent, position:Vector2):
	var nodeInstance = node.instance()
	parent.add_child(nodeInstance)
	nodeInstance.global_position = position
	return nodeInstance

static func compare_float(a, b, epsilon = 0.00001):
	return abs(a - b) <= epsilon 

func getAngleVector2(position1:Vector2, position2:Vector2):
	var angle = position1.angle_to_point(position2) + deg2rad(180)
	return Vector2(cos(angle), sin(angle))

func randomPorcent(list:Dictionary):
	var porcent = randf()
	for p in list:
		if porcent < p: return list[p]
