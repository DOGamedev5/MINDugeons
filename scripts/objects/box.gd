extends objectClass

var type : int

func _ready():
	randomize()
	type = randi() % 2
	$Sprite.texture.region.position.x = 16 * type
