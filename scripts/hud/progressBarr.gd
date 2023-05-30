tool
extends Control

onready var down = $down
onready var up = $up

enum TYPE {
	RED = 0,
	GREEN = 1,
	BLUE = 2,
	PURPLE = 3
}

var minSize := Vector2(11, 18)

export(TYPE) var type

export var maxValue := 120
export var minValue := 20
export var value := 20

export var width = 80
export var height = 18

func _ready():
	up.texture.region.position.y = 0 + (minSize.y * type)
	down.texture.region.position.y = 0 + (minSize.y * type)
	
	down.rect_size = Vector2(width, height)
	
	$scroll.rect_size = Vector2(width, height)
	
	$scroll.min_value = minValue
	$scroll.max_value = maxValue
	
	update_up()
	

func update_up(v = value):
	
	if v - minValue > 0:
		up.visible = true
		var newWidth = minSize.x + (width - minSize.x) * (v - minValue) / (maxValue - minValue)
		if newWidth >= width: newWidth = width
		up.rect_size = Vector2(newWidth, height)
	else:
		up.visible = false


func _on_scroll_value_changed(v):
	update_up(v)
