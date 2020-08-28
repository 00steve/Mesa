extends Spatial

onready var MesaComponentClass = preload("res://util/MesaComponent.gd")
onready var MesaLightClass = preload("res://util/MesaLight.gd")
onready var MSwitchClass = preload("res://util/MSwitch.gd")



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
	var systems = {};
	var components = [];
	var componentParts = [];
	
	var childName;
	var block;
	var blockIndexEnd;
	var state;
	var nextState;
	
	var systemName;
	var componentType;
	var componentName;
	
	
	#parse all of the nodes in the escn, they are all at the same level, so we
	#have to depend 100% on the name of the node to determine how the node should
	#be added to the scene tree and what child nodes it should have.
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
					if(blockIndexEnd == -1 || block != "System"):
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
					#print(" - is System[" + systemName + "]");
					var sys = MesaSystemNode.new(systemName);
					sys.set_name(systemName + "System");
					sceneNode.add_child(sys);
					systems[systemName] = sys;
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
					componentType = block;
					componentName = childName;
					blockIndexEnd = childName.find("_");
					block = childName.substr(0,blockIndexEnd);
					childName = childName.substr(blockIndexEnd+1);
					if(blockIndexEnd > -1):
						nextState = 22;
					else:
						#print("\t - component " + block);
						var component = MesaComponent.new();
						component.SystemName = systemName;
						component.ComponentType = componentType;
						component.ComponentName = componentName;
						component.ComponentNode = child;
						components.push_back(component);
						break;
				22:
					#print("\t - component part system[" + systemName + "]" + block + " -> part " + childName);
					var component = MesaComponent.new();
					component.SystemName = systemName;
					component.ComponentType = childName;
					component.ComponentName = block;
					component.ComponentNode = child;
					componentParts.push_back(component);
					break;
				25:
					print("\t - invalid component type");
					break;
			state = nextState;
	
	#create component nodes
	for component in components:

		#make sure the component is a valid type
		#print("child(" + component.ComponentNode.get_class() + ")");
		match component.ComponentType:
			"MSwitch":
				#print(" - is MSwitch");
				component.node = MSwitch.new(component);
				for cp in componentParts:
					if(cp.SystemName == component.SystemName && cp.ComponentName == component.ComponentName):
						cp.ComponentName = component.node.get_name();
						#component.node.AddComponent(cp);
						#print(cp.SystemName + ":" + cp.ComponentName + ":" + cp.ComponentType);
			"MesaLight":
				#print(" - is MesaLight");
				component.node = MesaLight.new(component);
				for cp in componentParts:
					if(cp.SystemName == component.SystemName && cp.ComponentName == component.ComponentName):
						cp.ComponentName = component.node.get_name();
				#		print("that shit matches");
			_:
				print("component type \"" + component.ComponentType + "\" is invalid");
	
	print("GENERATED COMPONENTS: " + String(components.size()));
	#add components to systems
	for component in components:
		if(!component.node):
			print("no valid node was generated for the component");
			continue;
		#validate that it is a valid system, based on the name
		systemName = component.SystemName;
		if(!systems.has(systemName)):
			print("system " + component.SystemName + " doesn't exist - skip");
			break;
		var system = systems[systemName];
		system.add_child(component.node);
		print("add child " + component.node.get_name() + " to system " + systemName);
		
		
	#add component parts to system components
	for cp in componentParts:
		var system = systems[cp.SystemName];
		if(!system):
			print("system part is not in valid system");
			continue;
		var component = system.get_node(cp.ComponentName);
		if(!component):
			print("component is not valid");
			continue;
		component.AddComponentPart(cp);
		print(cp.SystemName + ":" + cp.ComponentName + ":" + cp.ComponentType);
		
		
	#initialize systems
	for i in systems:
		systems[i].Init();
