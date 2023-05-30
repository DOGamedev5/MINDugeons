extends Node2D

class_name HealthComponent

export var maxHealth := 100
export var health := 0
export var shield := 0

signal health_changed(newValue)

func damage(attack : AttackObject):
	health -= attack.damage
	emit_signal("health_changed", health)
	
	if health <= 0:
		get_parent().queue_free()
