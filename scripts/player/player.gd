extends KinematicBody2D

var speed := Vector2.ZERO
var acel := 300
var speedMax := 64

var mana := 100
var manaMax := 100

var vida := 100
var vidaMax := 100

var power = preload("res://scenes/player/powers/power.tscn")
var cooldownOut = true

onready var cursor = $cursor
onready var hitbox = $hitboxComponent
onready var cooldown = $cooldown

func _ready():
	$HealthComponent.health = vida
	$HealthComponent.maxHealth = vidaMax

func _process(_dt):
	cursor.position = get_local_mouse_position()
	

func _physics_process(dt):
	var axis = Vector2(
		Input.get_axis("ui_left", "ui_right"), 
		Input.get_axis("ui_up","ui_down")
	).normalized()
	
	if axis == Vector2.ZERO:
		if speed.length() > acel * dt:
			speed -= speed.normalized() * (acel * 1.5 * dt)
		else:
			speed = Vector2.ZERO 
	else:
		speed += axis * acel * dt
		speed = speed.limit_length(speedMax)
	
	speed = move_and_slide(speed)
	
	if cursor.global_position.x < position.x:
		$sprite.flip_h = true
	elif cursor.global_position.x > position.x:
		$sprite.flip_h = false
	
	if abs(speed.x) <= 2 and abs(speed.y) <= 2: $sprite.animation = "idle"
	else: $sprite.animation = "running"

func _input(_event):
	if Input.is_mouse_button_pressed(1):
		cursor.animation = "click"
		if cooldownOut:
			cooldownOut = false
			var newPower = power.instance()
			
			add_child(newPower)
			cooldown.wait_time = newPower.cooldown
			cooldown.start()
	else:
		cursor.animation = "default"
	
func _on_cooldown_timeout():
	cooldownOut = true

func _on_HealthComponent_health_changed(newHealth):
	$CanvasLayer/progressBarr.value = newHealth
	$CanvasLayer/progressBarr.update_up()
