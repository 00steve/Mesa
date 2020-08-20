extends Spatial
class_name MesaSpatial


var interactionArea = null;
var lastError = -1;
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if(child.get_name() != "Area"):
			continue;
		interactionArea = child;
		lastError = interactionArea.connect("body_entered",interactionArea,"SignalStartInteracting");
		if(lastError != OK):
			print("Error: " + lastError);
		lastError = interactionArea.connect("body_exited",interactionArea,"SignalEndInteracting");
		if(lastError != OK):
			print("Error: " + lastError);
		break; #assuming there is only one object called Area

	

func InteractionArea():
	return interactionArea;


func HasInteractionArea():
	return interactionArea != null;
	
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
