extends objectClass

var open := false

func _physics_process(_delta):
	if interact and Input.is_action_just_pressed("ui_interact"):
		$sprite.play("default")
		open = true
		$ballon._update_show(0)


func _on_interact_body_entered(body):
	if body.name == "player" and open == false:
		interact = true
		$ballon._update_show(2)


func _on_interact_body_exited(body):
	if body.name == "player" and open == false:
		interact = false
		$ballon._update_show(1)
