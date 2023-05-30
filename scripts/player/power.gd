extends KinematicBody2D

var attack = AttackObject.new(0) 
var cooldown

class power:
	var position : Vector2
	var size : Vector2
	var damage : float
	var speed : int
	var cooldown : float
	var sprite : int
	var color : Color
	
	func _init(pos : Vector2, s : Vector2, d : float, vel : int, cd : float, id : int, clr : Color):
		position = pos
		size = s
		damage = d
		speed = vel
		cooldown = cd
		sprite = id
		color = clr

var powers = [
	power.new(Vector2(5, 0), Vector2(4, 6), 5, 300, 0.2, 0, Color(0.08, 0.72, 0.96))
]

var id := 0

var speed:int
var direction:Vector2

func _physics_process(_delta):
	direction = move_and_slide(direction)
	if is_on_wall():
		queue_free()

func _on_power0_tree_entered():
	global_position = get_parent().get_node("%player").global_position + Vector2(0, -8)
	
	id = Global.currentPower
	cooldown = powers[id].cooldown
	
	attack.damage = powers[id].damage
	speed = powers[id].speed
	rotation = global_position.angle_to_point(get_global_mouse_position()) + deg2rad(180)
	direction = Vector2(cos(rotation), sin(rotation)) * speed
	
	$hurtbox/shape.shape.extents = powers[id].size
	$hurtbox/shape.position = powers[id].position
	$shape.shape.extents = powers[id].size
	$shape.position = powers[id].position
	
	$sprite.animation = String(powers[id].sprite)
	modulate = powers[id].color


func _on_hitbox_area_entered(area):
	if area is hitboxComponent:
		area.damage(attack)
		queue_free()
