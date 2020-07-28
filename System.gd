extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal start_interacting;
signal end_interacting;
signal interact_event(sender);
signal relay_interaction;

var inputs;
var devices;

#vars needed for categorizing and setting up children relements in the system
var child;
var childType;
var childTypes = ["Input","Device"];
var childTypeIndex;
var objectType;
var objectName;
var systemType;
var systemNameIndex;
var inputType;
var inputNameIndex;
var deviceType;
var deviceTypeIndex;

# Called when the node enters the scene tree for the first time.
func _ready():

	inputs = [];
	inputs.resize(8); #this should be more than enough things ever. We'll see
	
	devices = [];
	devices.resize(8);
	
	
	#get the keyword for the type of system that this system is
	var systemType = self.get_name();
	var systemNameIndex = systemType.find_last("System");
	if(systemNameIndex == -1):
		print("Not a valid system");
		return;
	systemType = systemType.substr(0,systemNameIndex);
	print("this system is a " + systemType + " system");
	
	#look for any children with the type "Input"
	#look to see if they have an area.
	var playerBody = self.get_parent().get_node("Environment").get("playerBody");
	playerBody.connect("interact_event",self,"RelayPlayerInteraction");
	
	#look through the children to see if they should be given specifc 
	#connections or other things based on the type of thing they are
	for child in self.get_children():
		var childName = child.get_name();
		for childType in childTypes:
			childTypeIndex = childName.find_last(childType);
			if(childTypeIndex == -1):
				continue;
			objectType = childName.substr(childTypeIndex,childType.length());
			print("found child of type: " + objectType);
			break;
		#depending on the type
		if(objectType == null):
			print(" - child " + child.get_name() + " is not a valid object type");
			continue;
		if(objectType == "Input"):
			var area = child.get_node("Area");
			area.connect("start_interacting",playerBody,"StartInteracting");
			area.connect("end_interacting",playerBody,"EndInteracting");
			inputs.append(child);
			continue;
		if(objectType == "Device"):
			var device = child;
			#device.connect("interact_event",self,"Interaction");
			self.connect("interact_event",device,"Interaction");
			devices.append(device);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func onLightControl(action):
	print("do shit with the lights:" + action as String);
	
	
func RelayPlayerInteraction(player):
	print("relay player interaction");
	emit_signal("interact_event",player);
