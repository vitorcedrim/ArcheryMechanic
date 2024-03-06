extends CharacterBody2D

@export var maxSpeed = 800
var currentVelocity = Vector2.ZERO
var dragFactor = 0.04

var currentDistance = null
var lastDistance = null

var isInsideArea = false
var currentArea = null

# Vector2.RIGHT.rotated(rotation) == Forward direction for the arrow

func _ready():
	currentVelocity = maxSpeed * Vector2.RIGHT.rotated(rotation)

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation).normalized()
	
	if isInsideArea:
		direction = global_position.direction_to(currentArea.global_position)
		currentDistance = self.global_position.distance_to(currentArea.global_position)
		
	if lastDistance != null && currentDistance > lastDistance:
		print("afastando")
		isInsideArea = false
		
	var desiredVelocity = direction * maxSpeed
	var change = (desiredVelocity - currentVelocity) * dragFactor
	
	currentVelocity += change
	
	position += currentVelocity * delta
	look_at(global_position + currentVelocity)
	
	lastDistance = currentDistance
	
func _on_area_2d_area_entered(area):
	isInsideArea = true
	currentArea = area
	
func _on_area_2d_area_exited(area):
	isInsideArea = false
	currentArea = null
