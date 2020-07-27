extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal start_interacting;
signal end_interacting;


var lights;

# Called when the node enters the scene tree for the first time.
func _ready():

	lights = [];
	lights.resize(8); #this should be more than enough things ever. We'll see
	
	
	#look for any children with the type "Input"
	#look to see if they have an area.
	var playerBody = self.get_parent().get_parent().get_node("Environment").get("playerBody");
	
	

	#add anything with the prefix "Light" to the group that should be controlled by any inputs
	for light in self.get_children():
		if light.get_name().left(5) != "Light":
			continue;
		print("light found - " + light.get_name());
		lights.append(light);

	#loop through each of the children of the light
	#look for any objects that start with "Input", to set them up to interact with the 
	#player, or any other NPCs that are capible of doing things and interacting with the world.
	var count = 0;
	var area;
	for input in self.get_children():
		if input.get_name() != "Input":
			continue;
		area = input.get_node("Area");
		if area == null:
			continue;
		print(area.get_class() + " is a light area");
		area.connect("start_interacting",playerBody,"startInteracting");
		area.connect("end_interacting",playerBody,"endInteracting");
		#area.connect("light_control",self,"onLightControl");
		
		#add a connector to each light to issue commands when there needs to be something
		#that happens from the input to the lights
		for light in lights:
			if(light == null):
				continue;
			light.connect("light_control",area,"onLightControl");


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func onLightControl(action):
	print("do shit with the lights:" + action as String);
