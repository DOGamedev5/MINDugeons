extends Node2D

onready var world = [
	$characters/barrs,
	$ground,
	$hole,
	$water
]

onready var characters = $characters

enum {BARR, AIR, HOLE, WATER}
enum {FROG}
enum {WALL, CHEST}

const tileColor = {
	Color8(0, 107, 138) : BARR,
	Color8(255, 255, 255) : AIR,
	Color8(0, 255, 255) : HOLE,
	Color8(0, 0, 255) : WATER,
}

const enemyColor = {
	Color8(255, 0, 0) : FROG 
}

const objColor = {
	Color8(255, 255, 255) : WALL,
	Color8(182, 70, 28) : CHEST
}

const objectIns = {
	WALL : preload("res://scenes/objects/box.tscn"),
	CHEST : preload("res://scenes/objects/chest.tscn")
}

const enemyIns = {
	FROG : preload("res://scenes/enemys/frog.tscn")
}

var map

class walker:
	var startVector : Vector2 = Vector2.ZERO
	var currentCell : Vector2
	var currenRoom : int = 0
	
	var rooms : Array = [{}]
	var totalRooms = rooms.size() - 1
	
	const DIRECTIONS : Array = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
	var direction : Vector2 = Vector2.UP
	
	var stepsSinceTurn : int = 0 
	var cellsCreated : int = 0
	var lastStep : Vector2
	
	func _init(steps : int, start : Vector2 = Vector2.ZERO):
		walk(steps)
		startVector = start
	
	func changeDirection():
		var lastCell : Vector2
		var dirs = DIRECTIONS.duplicate()
		dirs.erase(direction)
		dirs.erase(-direction)
		
		lastCell = lastCell
		
		direction = dirs[randi() % 2]
		
		for i in range(totalRooms):
			if rooms[i].has(lastCell + dirs[0]) and rooms[i].has(lastCell + dirs[1]):
				return false
			
			if rooms[i].has(lastCell + dirs[0]):
				direction = dirs[1]
			if rooms[i].has(lastCell + dirs[1]):
				direction = dirs[0]
		
		return true
		
	func step():
		var nextMove : Vector2
		
		if rooms[rooms.size() - 1].empty() and rooms.size() == 1:
			rooms[totalRooms][startVector] = {id = 0, nextDirection = Vector2.UP}
			nextMove = startVector
			lastStep = nextMove
			
			rooms.append({})
			totalRooms += 1
			
			direction = Vector2.UP
		
		else:
			nextMove = lastStep
		
		if stepsSinceTurn >= (randi() % 3) + 2:
			changeDirection()
			stepsSinceTurn = 0
			
		
		nextMove += direction
		lastStep = nextMove
		
		
		for i in range(totalRooms):
			if rooms[i].has(nextMove):
				return false
		
		rooms[totalRooms][nextMove] = {id = randi() % 2, nextDirection = direction}
		cellsCreated += 1
		
		if cellsCreated >= (randi() % 3) + 1:
			cellsCreated = 0
			rooms.append({})
			totalRooms += 1
		
		return true
	
	func walk(steps):
		for _step in range(steps):
			if step():
				stepsSinceTurn += 1
			elif not changeDirection():
				print("preso")
				break
	
	func getCell() -> Dictionary:
		var info = {
			id = rooms[currenRoom][currentCell].id,
			direction = rooms[currenRoom][currentCell].nextDirection
		}
		
		currentCell += rooms[currenRoom][currentCell].nextDirection
		if not currentCell in rooms[currenRoom].keys():
			currenRoom += 1
		
		return info

func _ready():
	randomize()
	print(tileColor.has(Color8(0, 255, 255)))
	map = walker.new(20)
	set_map()
	

func set_map():
	var cellInfo = map.getCell()
	
	var cell := Image.new()
	cell.load("res://sprites/maps/map"+String(cellInfo.id)+".png")
	
	var canvas := Vector2(cell.get_width(), cell.get_height())
	var offset := Vector2(canvas.x/2, canvas.y/2)
	cell.lock()
	
	for imageX in range(canvas.x):
		var x = imageX - offset.x
		
		var Wgrid : Vector2
		var Wporc := {
			0.05 : Vector2(2, 0),
			0.17 : Vector2(3, 0),
			0.27 : Vector2(1, 0), 
			0.3 : Vector2(4, 0), 
			1.1 : Vector2(0, 0)
		}
		
		Wgrid = Global.randomPorcent(Wporc)
		
		$wall.set_cell(x, -8, 0, false, false, false, Wgrid)
			
		for imageY in range(canvas.y):
			var pixel := cell.get_pixel(imageX, imageY)
			var y = imageY - offset.y
			
			if tileColor.has(Color8(pixel.r8, pixel.g8, pixel.b8)):
				var grid : Vector2 = Vector2.ZERO
				var value = tileColor[Color8(pixel.r8, pixel.g8, pixel.b8)]
				
				if value == AIR:
					var porc := {
						0.03 : Vector2(2, 0),
						0.06 : Vector2(1, 1),
						0.09 : Vector2(1, 0),
						0.1 : Vector2(0, 0),
						0.3 : Vector2(0, 1),
						1.1 : Vector2(2, 1)
					}
					
					grid = Global.randomPorcent(porc)
				
				setCell(value, x, y, grid)
				continue

			elif objColor.has(Color8(pixel.r8, pixel.g8, pixel.b8)):
				var value = objColor[Color8(pixel.r8, pixel.g8, pixel.b8)]
				var obj = objectIns[value].instance()
				obj.position = Vector2(x*16, y*16)

				characters.add_child(obj)


			elif enemyColor.has(Color8(pixel.r8, pixel.g8, pixel.b8)):
				var value = enemyColor[Color8(pixel.r8, pixel.g8, pixel.b8)]
				var enemy = enemyIns[value].instance()
				enemy.position = Vector2(x*16, y*16)

				characters.add_child(enemy)

			var porc := {
				0.03 : Vector2(2, 0),
				0.06 : Vector2(1, 1),
				0.09 : Vector2(1, 0),
				0.1 : Vector2(0, 0),
				0.3 : Vector2(0, 1),
				1.1 : Vector2(2, 1)
			}

			var grid = Global.randomPorcent(porc)
			setCell(AIR, x, y, grid)
			
	updateBitmask(-offset, offset)

func setCell(index, x, y, grid = Vector2.ZERO):
	world[index].set_cell(x, y, 0, false, false, false, grid)
	if index == BARR:
		world[AIR].set_cell(x, y, 0)

func updateBitmask(startV:Vector2, endV:Vector2):
	for i in range(4):
		world[i].update_bitmask_region(startV, endV)

func has_color(list, color):
	var keys = list.keys()
	for key in range(keys.size()):
		if compare_colors(keys[key], color):
			print(2)
			return true
	
	return false

func get_colorKey(list, color):
	var keys = list.keys()
	var values = list.values()
	
	for key in range(keys.size()):
		if compare_colors(key, color):
			print(1)
			return values[key]

static func compare_colors(a, b):
	return a.r8 == b.r8 and a.g8 == b.g8 and a.b8 == b.b8
#	return abs(a.r - b.r) <= epsilon and abs(a.g - b.g) <= epsilon and abs(a.b - b.b) <= epsilon
