extends KinematicBody

#movement states
# - 0 = free movement
# - 1 = climbing


var mouseSensitivity = .3;

var cameraAngle;
var cameraRotateVelocity;
var cameraRotateSmoothing;
var mouseMove;
var speed;
var strafeDirection;
var moveDirection;
var velocity;
var gravity;
var isOnFloor;
var climbSpeed;
var movementState;

# Called when the node enters the scene tree for the first time.
func _ready():
	cameraAngle = Vector3(1.57,0,0);
	cameraRotateVelocity = Vector2(0,0);
	cameraRotateSmoothing = 3;
	mouseMove = Vector2(0,0);
	speed = 200;
	strafeDirection = Vector3(0,0,0);
	moveDirection = Vector3(0,0,0);
	velocity = Vector3(0,0,0);
	gravity = -9.81;
	isOnFloor = false;
	climbSpeed = 2;
	movementState = 0;

func _physics_process(delta):
	aim();
	move(delta);


func _input(event):
	if event is InputEventMouseMotion:
		mouseMove = Vector2(-event.relative.x,-event.relative.y);

	strafeDirection = Vector3(0,0,0)
	if Input.is_action_pressed("move_left"):
		strafeDirection.x -= 1
	if Input.is_action_pressed("move_right"):
		strafeDirection.x += 1
	if Input.is_action_pressed("move_forward"):
		strafeDirection.z -= 1
	if Input.is_action_pressed("move_backward"):
		strafeDirection.z += 1
	
	if Input.is_action_pressed("move_jump"):
		match movementState:
			0: 
				if isOnFloor:
					velocity.y = 10;
			1:
				print("jump from the ladder");
				velocity = Vector3(sin(cameraAngle.y)*strafeDirection.z
					+ cos(cameraAngle.y)*strafeDirection.x,2,
					cos(cameraAngle.y)*strafeDirection.z
					+ -sin(cameraAngle.y)*strafeDirection.x)*5;
				movementState = 0;
				gravity = -20;

func aim():
	#smooth camera rotation
	cameraRotateVelocity.y = (cameraRotateVelocity.y * (cameraRotateSmoothing-1) 
		+ deg2rad(mouseMove.x) * mouseSensitivity) / cameraRotateSmoothing;
	cameraRotateVelocity.x = (cameraRotateVelocity.x * (cameraRotateSmoothing-1) 
		+ deg2rad(mouseMove.y) * mouseSensitivity) / cameraRotateSmoothing;
	mouseMove = Vector2(0,0); #reset mouseMove after every time it updates the cameraVelocity
	cameraAngle.y += cameraRotateVelocity.y;
	cameraAngle.x += cameraRotateVelocity.x;
	if cameraAngle.x < 0:
		cameraAngle.x = 0;
	if cameraAngle.x > 3.14:
		cameraAngle.x = 3.14;
	#only change the head rotation if the camera rotation velocity is not zero
	if cameraRotateVelocity.x != 0 && cameraRotateVelocity.y != 0:
		$PlayerHead.rotation = cameraAngle;

func startClimbing(area):
	if area != self:
		return;
	movementState = 1;

func endClimbing(area):
	if area != self:
		return;
	if movementState == 1:
		movementState = 2;


func move(delta):
	strafeDirection = strafeDirection.normalized();
	

	
	
	match movementState:
		0: 
			#rotate movement direction by camera y angle
			moveDirection = Vector3(sin(cameraAngle.y)*strafeDirection.z
				+ cos(cameraAngle.y)*strafeDirection.x,0,
				cos(cameraAngle.y)*strafeDirection.z
				+ -sin(cameraAngle.y)*strafeDirection.x)*5;
			if velocity.y > 0:
				gravity = -20;
			else:
				gravity = -30;
			velocity.y += gravity * delta;
			if isOnFloor:
				velocity.x = moveDirection.x;
				velocity.z = moveDirection.z;
		1:#climbing
			gravity = 0;
			moveDirection = Vector3(0,cos(-cameraAngle.x)*strafeDirection.z*climbSpeed,0);
			velocity.x = moveDirection.x;
			velocity.y = moveDirection.y;
			velocity.z = moveDirection.z;
			if velocity.y < 0 && isOnFloor:
				movementState = 0;
		2: #end climbing
			moveDirection = Vector3(sin(cameraAngle.y)*strafeDirection.z
				+ cos(cameraAngle.y)*strafeDirection.x,0,
				cos(cameraAngle.y)*strafeDirection.z
				+ -sin(cameraAngle.y)*strafeDirection.x)*5;
			if velocity.y > 0:
				gravity = -20;
			else:
				gravity = -30;
			velocity.y += gravity * delta;
			velocity.x = moveDirection.x;
			velocity.z = moveDirection.z;
			if isOnFloor:
				movementState = 0;
			
	#update the velocity of the player. Always update the velocity based on 
	#gravity. Only update the x/z velocities if the player is on the floor.
	

	
	velocity = move_and_slide(velocity,Vector3(0,1,0))
	
	#at the end of everything, check to see if the player is on the floor
	isOnFloor = is_on_floor()
