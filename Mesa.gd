extends Spatial


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	
	SetupScenes();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	if(Input.is_action_just_pressed("ui_restart")):
		get_tree().reload_current_scene()
	if(Input.is_action_just_pressed("ui_toggle_fullscreen")):
		OS.window_fullscreen = !OS.window_fullscreen;

#hardcoded function to setup each of the desired scenes (eventually replace with
#a function to load scenes behind the scene [pun intended #dadJokes])
func SetupScenes():
	SetupSceneFromBlender("infirmary");

#a scene passed into this function should be a direct child of this node
func SetupSceneFromBlender(sceneName):
	var sceneNode = self.find_node(sceneName);
	if(!sceneNode):
		print("could not find scene " + sceneName);
		return;
	SetupSceneSystems(sceneNode);
	#do other things scene needs to be setup



func SetupSceneSystems(sceneNode):
	var childName;
	var block;
	var blockIndexEnd;
	var state;
	var nextState;
	
	var systemName;
	var componentType;
	var componentName;
	
	for child in sceneNode.get_children():
		state = 0;
		childName = child.get_name();
		#print("child name : " + childName);
		while(state > -1):

			#print(block + " - " + childName);
			match(state):
				#don't know if this is a valid component yet
				#it must start with "System" to be valid.
				0:			
					blockIndexEnd = childName.find("_");
					block = childName.substr(0,blockIndexEnd);
					childName = childName.substr(blockIndexEnd+1);
					if(blockIndexEnd == -1):
						break;
					if block != "System":
						break;
					nextState = 1;
				#check if valid node is a system or a component 
				#of a system.
				1: 
					blockIndexEnd = childName.find("_");
					block = childName.substr(0,blockIndexEnd);
					childName = childName.substr(blockIndexEnd+1);
					if blockIndexEnd == -1:
						nextState = 10;
					else:
						nextState = 20;
				#if node is a System, setup the system
				10:
					systemName = block;
					print(" - is System[" + systemName + "]");
					break;
				#if node is a component of a system, keep 
				#digging to determine which type of component 
				#it should be created as
				20:
					systemName = block;
					#has a system, but doesn't have a component type
					if blockIndexEnd == -1:
						print("\t - HAS SYSTEM NAME, BUT NO DEVICE TYPE");
						nextState = 25;
					else:
						nextState = 21;
						blockIndexEnd = childName.find("_");
						block = childName.substr(0,blockIndexEnd);
						childName = childName.substr(blockIndexEnd+1);
				21:
					
					print("\t - is a " + block + " of system[" + systemName + "] ->" + childName);
					componentType = block;
					componentName = childName;
					blockIndexEnd = childName.find("_");
					block = childName.substr(0,blockIndexEnd);
					childName = childName.substr(blockIndexEnd+1);
						
					
					print("\t - named " + childName);
					break;
				25:
					print("\t - invalid component type");
					break;
			state = nextState;
