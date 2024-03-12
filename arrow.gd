extends CharacterBody2D

@export var maxSpeed = 500
var currentVelocity = Vector2.ZERO
var dragFactor = 0.04

var currentDistance = null
var lastDistance = null

var isInsideArea = false
var currentArea = null
var detectedAreas = []
var detectedAreasVectors = []

var averagePoint = Vector2.ZERO

# Vector2.RIGHT.rotated(rotation) == Forward direction for the arrow

func _ready():
	currentVelocity = maxSpeed * Vector2.RIGHT.rotated(rotation)

func _physics_process(delta):
	detectedAreasVectors = detectedAreas.map(func(areaObject): return areaObject.global_position)
	
	if len(detectedAreas) > 1:
		averagePoint.x = detectedAreasVectors.reduce(func(acc, num): return acc + num).x / len(detectedAreas)
		averagePoint.y = detectedAreasVectors.reduce(func(acc, num): return acc + num).y / len(detectedAreas)
		$Midpoint.global_position = averagePoint
	elif len(detectedAreas) == 1:
		$Midpoint.global_position = detectedAreas[0].global_position
	else:
		pass
	
	var direction = Vector2.RIGHT.rotated(rotation).normalized()
	
	if isInsideArea && len(detectedAreas) == 1:
		direction = global_position.direction_to(currentArea.global_position)
		currentDistance = self.global_position.distance_to(currentArea.global_position)
	elif isInsideArea && len(detectedAreas) > 1:
		direction = global_position.direction_to(averagePoint)
		currentDistance = self.global_position.distance_to(averagePoint)
		isInsideArea = true
		
	if lastDistance != null && currentDistance > lastDistance:
		isInsideArea = false
		
	var desiredVelocity = direction * maxSpeed
	var change = (desiredVelocity - currentVelocity) * dragFactor
	
	currentVelocity += change
	
	position += currentVelocity * delta
	look_at(global_position + currentVelocity)
	
	lastDistance = currentDistance
	
	#print(len(detectedAreas))
	print(isInsideArea)
	
func _on_area_2d_area_entered(area):
	isInsideArea = true
	currentArea = area
	detectedAreas.append(area)
	currentDistance = null
	
func _on_area_2d_area_exited(area):
	isInsideArea = false
	currentArea = null
	detectedAreas.erase(area)
