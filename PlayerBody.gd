extends KinematicBody

var mouseSensitivity = .3

var cameraAngle = Vector3()
var speed = 200
var strafeDirection = Vector3()
var moveDirection = Vector3()
var velocity = Vector3()
var gravity = -9.81
var isOnFloor = false


# Called when the node enters the scene tree for the first time.
func _ready():
	cameraAngle = Vector3(1.57,0,0)
	moveDirection = Vector3(0,0,0)

func _physics_process(delta):
# Called every frame. 'delta' is the elapsed time since the previous frame.

	strafeDirection = strafeDirection.normalized()
	
	#rotate movement direction by camera y angle
	moveDirection = Vector3(sin(cameraAngle.y)*strafeDirection.z
		+ cos(cameraAngle.y)*strafeDirection.x,0,
		cos(cameraAngle.y)*strafeDirection.z
		+ -sin(cameraAngle.y)*strafeDirection.x)*5
	
	
	if velocity.y > 0:
		gravity = -20
	else:
		gravity = -30
	
	#update the velocity of the player. Always update the velocity based on 
	#gravity. Only update the x/z velocities if the player is on the floor.
	velocity.y += gravity * delta
	if isOnFloor:
		velocity.x = moveDirection.x
		velocity.z = moveDirection.z
	
	velocity = move_and_slide(velocity,Vector3(0,1,0))
	
	#at the end of everything, check to see if the player is on the floor
	isOnFloor = is_on_floor()
	


func _input(event):
	if event is InputEventMouseMotion:
		cameraAngle.y += deg2rad(-event.relative.x) * mouseSensitivity
		cameraAngle.x += deg2rad(-event.relative.y) * mouseSensitivity
		if cameraAngle.x < 0:
			cameraAngle.x = 0
		if cameraAngle.x > 3.14:
			cameraAngle.x = 3.14
		$head.rotation = cameraAngle
		
	strafeDirection = Vector3(0,0,0)
	
	if Input.is_action_pressed("move_left"):
		strafeDirection.x -= 1
	if Input.is_action_pressed("move_right"):
		strafeDirection.x += 1
	if Input.is_action_pressed("move_forward"):
		strafeDirection.z -= 1
	if Input.is_action_pressed("move_backward"):
		strafeDirection.z += 1
	if isOnFloor:
		if Input.is_action_pressed("move_jump"):
			velocity.y = 10
