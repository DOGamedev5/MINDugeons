extends enemyObject

var state := "idle"

var velocity = Vector2.ZERO
var applyForce = Vector2.ZERO
var isJump = false

var attack = AttackObject.new(5)

const delay := {
	"idle" : 1.5,
	"toAttack" : 1.0,
	"attack" : 0.5
}

const jumpForce := 100

onready var tween := $Tween

func _physics_process(dt):
	changeState(dt)
	
	if $sprite.animation != state:
		$sprite.animation = state

func changeState(dt):
	if not seePlayer: return
	
	if state == "idle": idleState()
	if state == "toAttack": toAttackState()
	if state == "attack": attackState(dt)

func idleState():
	if timer.is_stopped():
		timeReset("toAttack")

func toAttackState():
	var vector_angle = get_vector_dir()
	
	applyForce = vector_angle * jumpForce
	
	if applyForce.x < position.x:
		$sprite.flip_h = true
		$hurtbox/shape.position.x = -1.5
	else:
		$sprite.flip_h = false
		$hurtbox/shape.position.x = 1.5
	
	if timer.is_stopped():
		$hurtbox.monitoring = true
		timeReset("attack")
		isJump = true

func attackState(dt):
	velocity = applyForce
	
	if applyForce == Vector2.ZERO:
		velocity = lerp(applyForce, Vector2.ZERO, 0.5*dt)
	
	velocity = move_and_slide(velocity)
	
	if timer.is_stopped() or is_on_wall():
		velocity = Vector2.ZERO
		isJump = false
		$hurtbox.monitoring = false
		timeReset("idle")

func timeReset(newState):
	timer.set_wait_time(delay[newState])
	timer.start()
	state = newState

func _on_view_body_entered(body):
	if body.name == "player" and not seePlayer:
		seePlayer = true
		timeReset("idle")

func _on_hurtbox_area_entered(area):
	if area is hitboxComponent:
		area.damage(attack)
