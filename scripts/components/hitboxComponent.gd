extends Area2D

class_name hitboxComponent

export var healthPath : NodePath

var healthComp

func _ready():
	if not healthPath.is_empty():
		healthComp = get_node(healthPath)

func damage(attack: AttackObject):
	if healthComp is HealthComponent:
		healthComp.damage(attack)
