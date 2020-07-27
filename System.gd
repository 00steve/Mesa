extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal start_interacting;
signal end_interacting;


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
			area.connect("start_interacting",playerBody,"startInteracting");
			area.connect("end_interacting",playerBody,"endInteracting");
			inputs.append(child);
			continue;
		if(objectType == "Device"):
			devices.append(child);
	#add anything with the prefix "Light" to the group that should be controlled by any inputs
#	for device in self.get_children():
#		if device.get_name().left(5) != "Device":
#			continue;
#		print("light found - " + device.get_name());
#		devices.append(device);

	#loop through each of the children of the light
	#look for any objects that start with "Input", to set them up to interact with the 
	#player, or any other NPCs that are capible of doing things and interacting with the world.
#	var count = 0;
#	var area;
#	for input in self.get_children():
#		if input.get_name() != "Input":
#			continue;
#		area = input.get_node("Area");
#		if area == null:
#			continue;
#		print(area.get_class() + " is a light area");
#		area.connect("start_interacting",playerBody,"startInteracting");
#		area.connect("end_interacting",playerBody,"endInteracting");
#		#area.connect("light_control",self,"onLightControl");
#		
#		#add a connector to each light to issue commands when there needs to be something
#		#that happens from the input to the lights
#		for device in devices:
#			if(device == null):
#				continue;
#			device.connect("light_control",area,"onLightControl");


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func onLightControl(action):
	print("do shit with the lights:" + action as String);
