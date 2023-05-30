extends Node2D

enum TYPE {
	TEXT,
	LOCK,
	ENEMY,
	BUY,
	LOCK_BUY
}

export var text := ""
export(TYPE) var type
export var ballonOffset := Vector2.ZERO

export({"inactive":0, "active":1, "open":2}) var show

func _update_type(t = type): 
	$rect.texture.region.position.x = 10 * t
	$point.texture.region.position.x = 10 * t

func _update_box(t = text):
	$Label.text = text
	var size = t.length() * 5
	
	$Label.rect_position.x = -(size / 2)
	$rect.rect_size.x = size + 9
	$rect.rect_position.x = -((size + 9) / 2)

func _update_show(s = show):
	if s == 0:
		$point.visible = false
		$Label.visible = false
		$rect.visible = false
	elif s == 1:
		$point.visible = true
		$Label.visible = false
		$rect.visible = false
		modulate = Color(1, 1, 1, 0.60)
	else:
		$point.visible = true
		$Label.visible = true
		$rect.visible = true
		modulate = Color(1, 1, 1, 0.85)

func _ready():
	global_position += ballonOffset
	_update_type()
	_update_box()
	_update_show()

