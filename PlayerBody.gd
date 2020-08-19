extends KinematicBody


onready var Interaction = preload("res://Interaction.gd");
onready var MesaInput = preload("res://MesaInput.gd");

signal start_press_button;
signal end_press_button;
signal interact_event(data);

#movement states
# - 0 = free movement
# - 1 = climbing


var mouseSensitivity = .25;

#camera input
var cameraAngle;
var cameraRotateVelocity;
var cameraRotateSmoothing;
var mouseMove;

#movement input
var speed;
var strafeDirection;
var moveDirection;
var jumping;

#movement physics
var velocity;
var gravity;
var isOnFloor;
var climbSpeed;
var movementState;

var pressingInteractButton;
var canInteract;
var interacting;
var interactions;
var closestInteraction;
var newClosestInteraction;


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
	jumping = false;
	
	#interaction variables
	pressingInteractButton = false;
	canInteract = 0;
	interacting = false;
	interactions = [];
	interactions.resize(20);#this should be more than enough things ever. We'll see
	closestInteraction = null;
	newClosestInteraction = null;
	
	
func _physics_process(delta):
	Interact();
	Aim();
	Move(delta);

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
	
	pressingInteractButton = Input.is_action_pressed("move_interact");

	if Input.is_action_pressed("move_jump"):
		jumping = true;
		match movementState:
			0: 
				if isOnFloor:
					velocity.y = 6;
			1:
				print("jump from the ladder");
				velocity = Vector3(sin(cameraAngle.y)*strafeDirection.z
					+ cos(cameraAngle.y)*strafeDirection.x,2,
					cos(cameraAngle.y)*strafeDirection.z
					+ -sin(cameraAngle.y)*strafeDirection.x)*5;
				movementState = 0;
				gravity = -17;
	else:
		jumping = false;

func Aim():
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

func GetClosestInteraction():
	var dist = 9999999;
	var pos = self.get_global_transform().origin;
	newClosestInteraction = null;
	for ob in interactions:
		if(ob == null):
			continue;
		var ipos = ob.get_global_transform().origin;
		var obdist = pos.distance_to(ipos);
		if(dist > obdist):
			newClosestInteraction = ob;
			dist = obdist;
	if(closestInteraction == newClosestInteraction):
		return;
	if(newClosestInteraction != closestInteraction && closestInteraction != null):
		self.disconnect("interact_event",closestInteraction.get_parent(),"OnInput");
		closestInteraction = null;
	if(newClosestInteraction != null && closestInteraction != newClosestInteraction):
		closestInteraction = newClosestInteraction;
		self.connect("interact_event",closestInteraction.get_parent(),"OnInput");

func Interact():
	if (!pressingInteractButton || canInteract == 0) && interacting: #or list of interactable objects is 
		interacting = false;
		emit_signal("interact_event",self);
		return;
		
	GetClosestInteraction();
		
	if pressingInteractButton && canInteract > 0 && !interacting: #and list of interactable objects is 1 or more
		interacting = true;
		emit_signal("interact_event",self);
		return; #nothing left to do after this, bitch

func StartClimbing(area):
	if area != self:
		return;
	movementState = 1;

func EndClimbing(area):
	if area != self:
		return;
	if movementState == 1:
		movementState = 2;

func StartInteracting(area):
	canInteract += 1;
	interactions.push_back(area);

func EndInteracting(area):
	canInteract -= 1;
	interactions.erase(area);

func Move(delta):
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
				if !jumping && isOnFloor:
					velocity.y = velocity.y/10;
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
	#velocity = move_and_slide(velocity,Vector3(0,1,0))
	velocity = move_and_slide(velocity,Vector3(0,1,0),true, 4,1.6,false);
	#at the end of everything, check to see if the player is on the floor
	isOnFloor = is_on_floor();
